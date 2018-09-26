//
//  LocationHandlerAuthorisationTests.swift
//  Spot
//
//  Created by David Hardiman on 26/09/2018.
//  Copyright © 2018 David Hardiman. All rights reserved.
//

import Nimble
@testable import Spot
import XCTest

extension LocationHandlerTests {
    func givenSuccessExpectation() {
        let closureExpectation = expectation(description: #function)
        handler.didChangeAuthorizationStatus = { result in
            expect(result.successResult()).toNot(beNil())
            closureExpectation.fulfill()
        }
    }

    func testDidChangeAuthorizationWithAuthorizedAlwaysCallClosureWithSuccess() {
        givenSuccessExpectation()
        handler.locationManager(actualLocationManager, didChangeAuthorization: .authorizedAlways)
        waitForExpectation()
    }

    func testDidChangeAuthorizationWithAuthorizedWhenInUseCallClosureWithSuccess() {
        givenSuccessExpectation()
        handler.locationManager(actualLocationManager, didChangeAuthorization: .authorizedWhenInUse)
        waitForExpectation()
    }

    func givenExpectationForFailure(with error: LocationPermissionError) {
        let closureExpectation = expectation(description: #function)
        handler.didChangeAuthorizationStatus = { result in
            expect(result.error()).to(equal(error))
            closureExpectation.fulfill()
        }
    }

    func testDidChangeAuthorizationWithDeniedCallClosureWithFailureDenied() {
        givenExpectationForFailure(with: .denied)
        handler.locationManager(actualLocationManager, didChangeAuthorization: .denied)
        waitForExpectation()
    }

    func testDidChangeAuthorizationWithRestrictedCallClosureWithFailureDenied() {
        givenExpectationForFailure(with: .denied)
        handler.locationManager(actualLocationManager, didChangeAuthorization: .restricted)
        waitForExpectation()
    }

    func testDidChangeAuthorizationWithDeniedCallClosureWithFailureDisabled() {
        MockLocationManager.isLocationServicesEnabled = false
        givenExpectationForFailure(with: .disabled)
        handler.locationManager(actualLocationManager, didChangeAuthorization: .denied)
        waitForExpectation()
    }

    func testDidChangeAuthorizationWithRestrictedCallClosureWithFailureDisabled() {
        MockLocationManager.isLocationServicesEnabled = false
        givenExpectationForFailure(with: .disabled)
        handler.locationManager(actualLocationManager, didChangeAuthorization: .restricted)
        waitForExpectation()
    }
}
