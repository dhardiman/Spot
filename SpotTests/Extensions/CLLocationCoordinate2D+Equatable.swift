//
//  CLLocationCoordinate2D+Equatable.swift
//  Spot
//
//  Created by David Hardiman on 26/09/2018.
//  Copyright © 2018 David Hardiman. All rights reserved.
//

import CoreLocation

extension CLLocationCoordinate2D: Equatable {}

public func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
    return fabs(lhs.latitude - rhs.latitude) < .ulpOfOne && fabs(lhs.longitude - rhs.longitude) < .ulpOfOne
}
