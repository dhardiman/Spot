//
//  LocationHandler.swift
//  Spot
//
//  Created by David Hardiman on 26/09/2018.
//  Copyright © 2018 David Hardiman. All rights reserved.
//

import CoreLocation
import Foundation
import UIKit

public typealias LocationCompletion = ((Result<CLLocationCoordinate2D, LocationRequestError>) -> Void)

public protocol LocationHandling: AnyObject {
    func requestLocation(_ completion: @escaping LocationCompletion)
    func cancelCurrentRequest()
    var didChangeAuthorizationStatus: ((Result<Void, LocationPermissionError>) -> Void)? { get set }
}

// MARK: - CLLocationManagerDelegate

class LocationHandler: NSObject, LocationHandling, CLLocationManagerDelegate {
    private var requestLocationCompletion: LocationCompletion?

    let locationManager: LocationManaging
    let locationAccess: LocationAccess

    /// Closure called when authorization status changes
    var didChangeAuthorizationStatus: ((Result<Void, LocationPermissionError>) -> Void)?

    init(locationManager: LocationManaging, locationAccess: LocationAccess = LocationAccess()) {
        self.locationManager = locationManager
        self.locationAccess = locationAccess
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.delegate = self
    }

    deinit {
        if locationManager.delegate === self {
            locationManager.delegate = nil
        }
    }

    func requestLocation(_ completion: @escaping LocationCompletion) {
        requestLocationCompletion = completion

        guard locationAccess.locationServicesEnabled() else {
            return completion(.failure(.locationDisabled))
        }
        guard locationAccess.locationServicesAuthorized() else {
            // Location permission is re-requested if the user puts the device to sleep
            // and comes back to the app otherwise the permission alert gets dismissed
            NotificationCenter.default.addObserver(self, selector: #selector(requestPermission), name: UIApplication.willEnterForegroundNotification, object: nil)

            if locationAccess.locationServicesUndetermined() {
                return requestPermission()
            } else {
                return completion(.failure(.locationDenied))
            }
        }

        locationManager.requestLocation()
    }

    @objc func requestPermission() {
        locationManager.requestWhenInUseAuthorization()
    }

    func cancelCurrentRequest() {
        requestLocationCompletion = nil
    }

    public func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            requestLocationCompletion?(.success(location.coordinate))
        } else {
            requestLocationCompletion?(.failure(.locationUnknown))
        }
        requestLocationCompletion = nil
    }

    public func locationManager(_: CLLocationManager, didFailWithError _: Error) {
        requestLocationCompletion?(.failure(.locationUnknown))
        requestLocationCompletion = nil
    }

    public func locationManager(_: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            if let requestLocationCompletion = requestLocationCompletion {
                requestLocation(requestLocationCompletion)
            }
            didChangeAuthorizationStatus?(.success(()))
        case .denied, .restricted:
            if locationAccess.locationServicesEnabled() == false {
                requestLocationCompletion?(.failure(.locationDisabled))
                didChangeAuthorizationStatus?(.failure(.disabled))
            } else {
                requestLocationCompletion?(.failure(.locationDenied))
                didChangeAuthorizationStatus?(.failure(.denied))
            }
            requestLocationCompletion = nil
        case .notDetermined:
            // Not determined is the initial state and is not used for observing changes to the authorization status
            break
        @unknown default:
            break
        }
    }
}
