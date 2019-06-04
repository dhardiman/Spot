//
//  LocationServiceTests.swift
//  Spot
//
//  Created by David Hardiman on 26/09/2018.
//  Copyright © 2018 David Hardiman. All rights reserved.
//

import CoreLocation
import Nimble
@testable import Spot
import XCTest

class MockLocationHandler: LocationHandling {
    var receivedCompletion: LocationCompletion?
    func requestLocation(_ completion: @escaping LocationCompletion) {
        receivedCompletion = completion
    }

    var receivedCancel = false
    func cancelCurrentRequest() {
        receivedCancel = true
    }

    var didChangeAuthorizationStatus: ((Result<Void, LocationPermissionError>) -> Void)?
}

class LocationServiceTests: XCTestCase {
    var locationService: LocationService!
    var mockLocationHandler: MockLocationHandler!

    override func setUp() {
        super.setUp()
        mockLocationHandler = MockLocationHandler()
        locationService = LocationService(locationManager: CLLocationManager(), locationHandler: mockLocationHandler)
    }

    override func tearDown() {
        locationService = nil
        mockLocationHandler = nil
        super.tearDown()
    }

    func testRequestLocationCancelAllOperations() {
        locationService.cancelRequestingLocation()
        expect(self.mockLocationHandler.receivedCancel).to(beTrue())
    }

    func testRequestLocationRequestsLocation() {
        locationService.requestLocation { _ in }
        expect(self.mockLocationHandler.receivedCompletion).notTo(beNil())
    }

    func testObserveAuthorizationChangesSetDidChangeAuthorizationStatus() {
        locationService.observeAuthorizationChanges { _ in }
        expect(self.mockLocationHandler.didChangeAuthorizationStatus).toNot(beNil())
    }
}
