//
//  XCTestCase+Additions.swift
//  Spot
//
//  Created by David Hardiman on 26/09/2018.
//  Copyright © 2018 David Hardiman. All rights reserved.
//

import XCTest

extension XCTestCase {
    func waitForExpectation(file: StaticString = #file, line: UInt = #line) {
        waitForExpectations(timeout: 1) { error in
            if let error = error { XCTFail("\(error)", file: file, line: line) }
        }
    }
}
