//
//  LocationAccess.swift
//  Spot
//
//  Created by David Hardiman on 26/09/2018.
//  Copyright © 2018 David Hardiman. All rights reserved.
//

import CoreLocation

public protocol AuthorizationManaging: AnyObject {
    static func locationServicesEnabled() -> Bool
    static func authorizationStatus() -> CLAuthorizationStatus
}

public protocol LocationManaging: AuthorizationManaging {
    var desiredAccuracy: CLLocationAccuracy { get set }

    var delegate: CLLocationManagerDelegate? { get set }

    func requestLocation()

    func requestWhenInUseAuthorization()
}

extension CLLocationManager: LocationManaging {}

/// Proxy object to access enabled and authorization status of CLLocationManager,
/// open for creating mocks through subclassing
open class LocationAccess {
    public convenience init() {
        self.init(authorizationManagerType: CLLocationManager.self)
    }

    private let authorizationManagerType: AuthorizationManaging.Type
    public init(authorizationManagerType: AuthorizationManaging.Type) {
        self.authorizationManagerType = authorizationManagerType
    }

    /// Method to know whether location is enabled and authorized
    ///
    /// - Returns: Returns true iff location is enabled and authorized
    open func canProvideLocation() -> Bool {
        return locationServicesEnabled() &&
            locationServicesAuthorized()
    }

    func locationServicesEnabled() -> Bool {
        return authorizationManagerType.locationServicesEnabled()
    }

    func locationServicesUndetermined() -> Bool {
        return authorizationManagerType.authorizationStatus() == .notDetermined
    }

    func locationServicesAuthorized() -> Bool {
        switch authorizationManagerType.authorizationStatus() {
        case .denied, .notDetermined, .restricted:
            return false
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        @unknown default:
            return false
        }
    }
}
