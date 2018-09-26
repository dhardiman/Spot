//
//  LocationManagerType+Mocks.swift
//  Spot
//
//  Created by David Hardiman on 26/09/2018.
//  Copyright © 2018 David Hardiman. All rights reserved.
//

import CoreLocation
@testable import Spot

// MARK: - Default values

extension AuthorizationManaging {
    static func locationServicesEnabled() -> Bool {
        return true
    }
}

class LocationManagerDisabled: AuthorizationManaging {
    static func locationServicesEnabled() -> Bool {
        return false
    }

    static func authorizationStatus() -> CLAuthorizationStatus {
        return .authorizedWhenInUse
    }
}

class LocationManagerEnabledAndDenied: AuthorizationManaging {
    static func authorizationStatus() -> CLAuthorizationStatus {
        return .denied
    }
}

class LocationManagerEnabledAndNotDetermined: AuthorizationManaging {
    static func authorizationStatus() -> CLAuthorizationStatus {
        return .notDetermined
    }
}

class LocationManagerEnabledAndRestricted: AuthorizationManaging {
    static func authorizationStatus() -> CLAuthorizationStatus {
        return .restricted
    }
}

// swiftlint:disable type_name Justfication this is mock and a long name is better for clarity

class LocationManagerEnabledAndAuthorizedAlways: AuthorizationManaging {
    static func authorizationStatus() -> CLAuthorizationStatus {
        return .authorizedAlways
    }
}

class LocationManagerEnabledAndAuthorizedWhenInUse: AuthorizationManaging {
    static func authorizationStatus() -> CLAuthorizationStatus {
        return .authorizedWhenInUse
    }
}

// swiftlint:enable type_name
