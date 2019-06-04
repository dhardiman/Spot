//
//  LocationAccessTests.swift
//  Spot
//
//  Created by David Hardiman on 26/09/2018.
//  Copyright © 2018 David Hardiman. All rights reserved.
//

import CoreLocation
import Nimble
@testable import Spot
import XCTest

class LocationAccessTests: XCTestCase {
    func testCanProvideLocationWhenLocationServicesIsDisabled() {
        let locationAccess = LocationAccess(authorizationManagerType: LocationManagerDisabled.self)
        let canProvideLocation = locationAccess.canProvideLocation()
        expect(canProvideLocation).to(beFalse())
    }

    func testCannotProvideLocationWhenLocationManagerEnabledAndDenied() {
        let locationAccess = LocationAccess(authorizationManagerType: LocationManagerEnabledAndDenied.self)
        let canProvideLocation = locationAccess.canProvideLocation()
        expect(canProvideLocation).to(beFalse())
    }

    func testCannotProvideLocationWhenLocationManagerEnabledAndNotDetermined() {
        let locationAccess = LocationAccess(authorizationManagerType: LocationManagerEnabledAndNotDetermined.self)
        let canProvideLocation = locationAccess.canProvideLocation()
        expect(canProvideLocation).to(beFalse())
    }

    func testCannotProvideLocationWhenLocationManagerEnabledAndRestricted() {
        let locationAccess = LocationAccess(authorizationManagerType: LocationManagerEnabledAndRestricted.self)
        let canProvideLocation = locationAccess.canProvideLocation()
        expect(canProvideLocation).to(beFalse())
    }

    func testCanProvideLocationWhenLocationManagerEnabledAndAuthorizedAlways() {
        let locationAccess = LocationAccess(authorizationManagerType: LocationManagerEnabledAndAuthorizedAlways.self)
        let canProvideLocation = locationAccess.canProvideLocation()
        expect(canProvideLocation).to(beTrue())
    }

    func testCanProvideLocationWhenLocationManagerEnabledAndAuthorizedWhenInUse() {
        let locationAccess = LocationAccess(authorizationManagerType: LocationManagerEnabledAndAuthorizedWhenInUse.self)
        let canProvideLocation = locationAccess.canProvideLocation()
        expect(canProvideLocation).to(beTrue())
    }

    func testLocationServicesEnabledWhenLocationServicesIsDisabled() {
        let locationAccess = LocationAccess(authorizationManagerType: LocationManagerDisabled.self)
        let locationServicesEnabled = locationAccess.locationServicesEnabled()
        expect(locationServicesEnabled).to(beFalse())
    }

    func testLocationServicesAuthorizedWhenAuthorizationStatusIsDenied() {
        let locationAccess = LocationAccess(authorizationManagerType: LocationManagerEnabledAndDenied.self)
        let locationServicesAuthorized = locationAccess.locationServicesAuthorized()
        expect(locationServicesAuthorized).to(beFalse())
    }

    func testLocationServicesAuthorizedWhenAuthorizationStatusIsNotDetermined() {
        let locationAccess = LocationAccess(authorizationManagerType: LocationManagerEnabledAndNotDetermined.self)
        let locationServicesAuthorized = locationAccess.locationServicesAuthorized()
        expect(locationServicesAuthorized).to(beFalse())
    }

    func testLocationServicesAuthorizedWhenAuthorizationStatusIsRestricted() {
        let locationAccess = LocationAccess(authorizationManagerType: LocationManagerEnabledAndRestricted.self)
        let locationServicesAuthorized = locationAccess.locationServicesAuthorized()
        expect(locationServicesAuthorized).to(beFalse())
    }

    func testLocationServicesAuthorizedWhenAuthorizationStatusIsAuthorizedAlways() {
        let locationAccess = LocationAccess(authorizationManagerType: LocationManagerEnabledAndAuthorizedAlways.self)
        let locationServicesAuthorized = locationAccess.locationServicesAuthorized()
        expect(locationServicesAuthorized).to(beTrue())
    }

    func testLocationServicesAuthorizedWhenAuthorizationStatusIsAuthorizedWhenInUse() {
        let locationAccess = LocationAccess(authorizationManagerType: LocationManagerEnabledAndAuthorizedWhenInUse.self)
        let locationServicesAuthorized = locationAccess.locationServicesAuthorized()
        expect(locationServicesAuthorized).to(beTrue())
    }
}
