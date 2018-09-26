//
//  LocationHandlerTests.swift
//  Spot
//
//  Created by David Hardiman on 26/09/2018.
//  Copyright © 2018 David Hardiman. All rights reserved.
//

import CoreLocation
import Nimble
@testable import Spot
import XCTest

class LocationHandlerTests: XCTestCase {
    var mockLocationManager: MockLocationManager!
    var mockLocationAccess: LocationAccess!
    var handler: LocationHandler!
    var actualLocationManager: CLLocationManager!

    override func setUp() {
        super.setUp()
        mockLocationManager = MockLocationManager()
        mockLocationAccess = LocationAccess(authorizationManagerType: MockLocationManager.self)
        handler = LocationHandler(locationManager: mockLocationManager, locationAccess: mockLocationAccess)
        actualLocationManager = CLLocationManager()
    }

    override func tearDown() {
        mockLocationAccess = nil
        mockLocationManager = nil
        actualLocationManager = nil
        handler = nil
        super.tearDown()
    }
}
