//
//  LocationService.swift
//  Spot
//
//  Created by David Hardiman on 26/09/2018.
//  Copyright © 2018 David Hardiman. All rights reserved.
//

import CoreLocation
import Foundation

/// Represents an error from the LocationRequestOperation
///
/// - locationDisabled: Location turned off in device
/// - locationDenied: Location denied by user
/// - locationUnknown: No location returned from CLLocationManager
public enum LocationRequestError: Error {
    case locationDisabled
    case locationDenied
    case locationUnknown
}

/// Represent the state of location permissions
///
/// - disabled:   Location has been disabled on the device
/// - denied:     User has denied location for this app
public enum LocationPermissionError: Error {
    case disabled
    case denied
}

// MARK: - Convenience extension to map LocationPermissionError to LocationRequestError

extension LocationRequestError {
    init(_ locationPermissionError: LocationPermissionError) {
        switch locationPermissionError {
        case .disabled:
            self = .locationDisabled
        case .denied:
            self = .locationDenied
        }
    }
}

public protocol LocationReporting {
    /// Method to request a users location
    ///
    /// - Parameter completion: Completion including the result of the request
    func requestLocation(completion: @escaping (Result<CLLocationCoordinate2D, LocationRequestError>) -> Void)

    /// Cancel all requests for location
    func cancelRequestingLocation()

    /// Register to observe authorisation changes
    ///
    /// - Parameter changesHandler: Closure to call when changes happen
    func observeAuthorizationChanges(changesHandler: @escaping (Result<Void, LocationPermissionError>) -> Void)
}

/// The operation context to use get a user location
@available(iOS 9, *)
public class LocationService: LocationReporting {
    private let locationManager: CLLocationManager

    private let locationHandler: LocationHandling

    public convenience init() {
        let locationManager = CLLocationManager()
        let locationHandler = LocationHandler(locationManager: locationManager)
        self.init(locationManager: locationManager, locationHandler: locationHandler)
    }

    public init(locationManager: CLLocationManager, locationHandler: LocationHandling) {
        self.locationManager = locationManager
        self.locationHandler = locationHandler
    }

    public func requestLocation(completion: @escaping (Result<CLLocationCoordinate2D, LocationRequestError>) -> Void) {
        locationHandler.requestLocation(completion)
    }

    public func cancelRequestingLocation() {
        locationHandler.cancelCurrentRequest()
    }

    public func observeAuthorizationChanges(changesHandler: @escaping (Result<Void, LocationPermissionError>) -> Void) {
        locationHandler.didChangeAuthorizationStatus = changesHandler
    }
}
