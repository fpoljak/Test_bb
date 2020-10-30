//
//  TestHelpers.swift
//  Test_bbTests
//
//  Created by Frane Poljak on 30/10/2020.
//  Copyright © 2020 Bellabeat. All rights reserved.
//

import XCTest

extension XCTest {
    func expectToEventually(
        _ isFulfilled: @autoclosure () -> Bool,
        timeout: TimeInterval,
        message: String = "",
        file: StaticString = #file,
        line: UInt = #line
    ) {
        func wait() { RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.01)) }
        
        let timeout = Date(timeIntervalSinceNow: timeout)
        func isTimeout() -> Bool { Date() >= timeout }

        repeat {
            if isFulfilled() { return }
            wait()
        } while !isTimeout()
        
        XCTFail(message, file: file, line: line)
    }
}
