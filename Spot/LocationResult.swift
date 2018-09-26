//
//  Result+Additions.swift
//  Spot
//
//  Created by David Hardiman on 26/09/2018.
//  Copyright © 2018 David Hardiman. All rights reserved.
//

import Foundation

/// Encapsulates the result of task that can succeed or fail
///
/// - success: Success result with object
/// - failure: Failure result with error
public enum LocationResult<T, E: Error> {
    case success(T)
    case failure(E)
}

extension LocationResult {
    /// Returns the success result if it exists, otherwise nil
    func successResult() -> T? {
        switch self {
        case let .success(successResult):
            return successResult
        case .failure:
            return nil
        }
    }

    /// Returns the error if it exists, otherwise nil
    func error() -> E? {
        switch self {
        case .success:
            return nil
        case let .failure(error):
            return error
        }
    }
}
