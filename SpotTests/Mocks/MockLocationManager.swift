//
//  MockCLLocationManager.swift
//  Spot
//
//  Created by David Hardiman on 26/09/2018.
//  Copyright © 2018 David Hardiman. All rights reserved.
//

import CoreLocation
@testable import Spot

class MockLocationManager: LocationManaging {
    init() {
        MockLocationManager.isLocationServicesEnabled = true
        MockLocationManager.currentAuthorizationStatus = .authorizedWhenInUse
    }

    static var isLocationServicesEnabled = true
    static func locationServicesEnabled() -> Bool {
        return isLocationServicesEnabled
    }

    static var currentAuthorizationStatus = CLAuthorizationStatus.authorizedWhenInUse
    static func authorizationStatus() -> CLAuthorizationStatus {
        return currentAuthorizationStatus
    }

    var desiredAccuracy: CLLocationAccuracy = kCLLocationAccuracyBest

    weak var delegate: CLLocationManagerDelegate?

    var requestLocationCallCount = 0
    func requestLocation() {
        requestLocationCallCount += 1
    }

    var requestWhenInUseAuthorizationCallCount = 0
    func requestWhenInUseAuthorization() {
        requestWhenInUseAuthorizationCallCount += 1
    }
}
