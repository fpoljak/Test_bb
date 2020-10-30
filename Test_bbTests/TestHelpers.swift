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

extension URLSession {
    func synchronousDataTask(with url: URL) -> (Data?, URLResponse?, Error?) {
        var data: Data?
        var response: URLResponse?
        var error: Error?

        let semaphore = DispatchSemaphore(value: 0)

        let dataTask = self.dataTask(with: url) {
            data = $0
            response = $1
            error = $2

            semaphore.signal()
        }
        dataTask.resume()

        _ = semaphore.wait(timeout: .distantFuture)

        return (data, response, error)
    }
}

