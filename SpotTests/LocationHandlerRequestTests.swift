//
//  LocationHandlerRequestTests.swift
//  Spot
//
//  Created by David Hardiman on 26/09/2018.
//  Copyright © 2018 David Hardiman. All rights reserved.
//

import CoreLocation
import Nimble
@testable import Spot
import XCTest

// swiftlint:disable force_unwrapping
extension LocationHandlerTests {
    func testLocationManagerIsConfiguredCorrectly() {
        expect(self.mockLocationManager.desiredAccuracy).to(equal(kCLLocationAccuracyThreeKilometers))
        expect(self.mockLocationManager.delegate).to(beIdenticalTo(handler))
    }

    @discardableResult
    func whenALocationIsReturned() -> CLLocation {
        let location = CLLocation(latitude: 10, longitude: 10)
        handler.locationManager(actualLocationManager, didUpdateLocations: [location])
        return location
    }

    func testLocationRequestDoesNotCallBackIfCancelled() {
        var receivedResult: LocationResult<CLLocationCoordinate2D, LocationRequestError>?
        handler.requestLocation { result in
            receivedResult = result
        }
        handler.cancelCurrentRequest()
        whenALocationIsReturned()
        expect(receivedResult).to(beNil())
    }

    func testLocationRequestDoesNotCallRequestWhenLocationServicesDisabled() {
        MockLocationManager.isLocationServicesEnabled = false
        var receivedResult: LocationResult<CLLocationCoordinate2D, LocationRequestError>?
        handler.requestLocation { result in
            receivedResult = result
        }
        expect(receivedResult!.error()).to(equal(LocationRequestError.locationDisabled))
        expect(self.mockLocationManager.requestLocationCallCount).to(equal(0))
    }

    func testLocationRequestDoesNotCallRequestLocationWhenLocationServicesDenied() {
        MockLocationManager.currentAuthorizationStatus = .denied
        var receivedResult: LocationResult<CLLocationCoordinate2D, LocationRequestError>?
        handler.requestLocation { result in
            receivedResult = result
        }
        whenLocationPermissionIsReceived(withStatus: .denied)
        expect(receivedResult!.error()).to(equal(LocationRequestError.locationDenied))
        expect(self.mockLocationManager.requestLocationCallCount).to(equal(0))
    }

    func testLocationRequestCallsRequestLocationWhenCanProvideLocationUpdatesIsTrue() {
        handler.requestLocation { _ in }
        expect(self.mockLocationManager.requestLocationCallCount).to(equal(1))
    }

    func testLocationManagerDidUpdateLocationCallsBackWithErrorWhenNoLocationsAreReturned() {
        var receivedResult: LocationResult<CLLocationCoordinate2D, LocationRequestError>?
        handler.requestLocation { result in
            receivedResult = result
        }
        handler.locationManager(actualLocationManager, didUpdateLocations: [])
        expect(receivedResult!.error()).to(equal(LocationRequestError.locationUnknown))
    }

    func testLocationManagerDidUpdateLocationCallsBackWithLocationOnSuccess() {
        var receivedResult: LocationResult<CLLocationCoordinate2D, LocationRequestError>?
        handler.requestLocation { result in
            receivedResult = result
        }
        let location = whenALocationIsReturned()
        expect(receivedResult!.successResult()).to(equal(location.coordinate))
    }

    func testLocationManagerDidFailWithErrorCallsBackForwardingError() {
        let mockedError = LocationRequestError.locationUnknown
        var receivedResult: LocationResult<CLLocationCoordinate2D, LocationRequestError>?
        handler.requestLocation { result in
            receivedResult = result
        }
        handler.locationManager(actualLocationManager, didFailWithError: mockedError)
        expect(receivedResult!.error()).to(equal(mockedError))
    }
}

// swiftlint:enable force_unwrapping
