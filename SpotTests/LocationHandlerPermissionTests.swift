//
//  LocationHandlerPermissionTests.swift
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
    func givenLocationPermissionHasNotBeenRequested() {
        MockLocationManager.currentAuthorizationStatus = .notDetermined
    }

    func whenLocationPermissionIsReceived(withStatus status: CLAuthorizationStatus) {
        let previouslyUndetermined = MockLocationManager.currentAuthorizationStatus == .notDetermined
        MockLocationManager.currentAuthorizationStatus = status
        // On calling requestWhenInUseAuthorization():
        // If the current authorization status is anything other than notDetermined,
        // this method does nothing and does not call the locationManager(_:didChangeAuthorization:) method.
        //
        // Emulate CLLocationManager's behaviour here.
        if previouslyUndetermined {
            handler.locationManager(actualLocationManager, didChangeAuthorization: status)
        }
    }

    func testRequestingLocationWhenNotAuthorisedRequestsWhenInUse() {
        givenLocationPermissionHasNotBeenRequested()
        handler.requestLocation { _ in }
        expect(self.mockLocationManager.requestWhenInUseAuthorizationCallCount).to(equal(1))
    }

    func testUIApplicationWillEnterForegroundAlsoCallsRequestPermission() {
        givenLocationPermissionHasNotBeenRequested()
        handler.requestLocation { _ in }
        expect(self.mockLocationManager.requestWhenInUseAuthorizationCallCount).to(equal(1))
        NotificationCenter.default.post(name: UIApplication.willEnterForegroundNotification, object: nil)
        expect(self.mockLocationManager.requestWhenInUseAuthorizationCallCount).to(equal(2))
    }

    func testLocationRequestReturnsDisabledErrorWhenLocationServicesAreDisabled() {
        MockLocationManager.isLocationServicesEnabled = false
        var receivedResult: LocationResult<CLLocationCoordinate2D, LocationRequestError>?
        handler.requestLocation { result in
            receivedResult = result
        }
        expect(receivedResult!.error()).to(equal(LocationRequestError.locationDisabled))
    }

    func testLocationRequestIsInitiatedWhenAuthorizationStatusIsAuthorizedAlways() {
        givenLocationPermissionHasNotBeenRequested()
        handler.requestLocation { _ in }
        whenLocationPermissionIsReceived(withStatus: .authorizedAlways)
        expect(self.mockLocationManager.requestLocationCallCount).to(equal(1))
    }

    func testLocationRequestIsInitiatedWhenAuthorizationStatusIsAuthorizedWhenInUse() {
        givenLocationPermissionHasNotBeenRequested()
        handler.requestLocation { _ in }
        whenLocationPermissionIsReceived(withStatus: .authorizedWhenInUse)
        expect(self.mockLocationManager.requestLocationCallCount).to(equal(1))
    }

    func testLocationRequestReportsErrorWhenAuthorizationStatusIsDenied() {
        givenLocationPermissionHasNotBeenRequested()
        var receivedResult: LocationResult<CLLocationCoordinate2D, LocationRequestError>?
        handler.requestLocation { result in
            receivedResult = result
        }
        whenLocationPermissionIsReceived(withStatus: .denied)
        expect(receivedResult!.error()).to(equal(LocationRequestError.locationDenied))
    }

    func testLocationRequestReportsErrorWhenAuthorizationStatusIsRestricted() {
        givenLocationPermissionHasNotBeenRequested()
        var receivedResult: LocationResult<CLLocationCoordinate2D, LocationRequestError>?
        handler.requestLocation { result in
            receivedResult = result
        }
        whenLocationPermissionIsReceived(withStatus: .restricted)
        expect(receivedResult!.error()).to(equal(LocationRequestError.locationDenied))
    }
}

// swiftlint:enable force_unwrapping
