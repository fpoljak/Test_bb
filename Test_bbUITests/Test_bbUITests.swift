//
//  Test_bbUITests.swift
//  Test_bbUITests
//
//  Created by Frane Poljak on 28/10/2020.
//  Copyright © 2020 Bellabeat. All rights reserved.
//

import XCTest
import Swifter

class Test_bbUITests: XCTestCase {
    var app: XCUIApplication!
    var server: HttpServer!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        server = HttpServer()
        try server.start()
        
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments += ["TESTING"]
    }

    override func tearDownWithError() throws {
//        server.stop()
        try super.tearDownWithError()
    }

    func testExample() throws {
        server.stubRequestsForEndpoint("interview.json")
        app.launch()
        
        let label = app.staticTexts.element.firstMatch
        
        let textColorButton = app.buttons["Promijeni boju teksta"]
        let backgroundColorButton = app.buttons["Promijeni boju pozadine"]
        
        let exists = NSPredicate(format: "exists == true")
        
        expectation(for: exists, evaluatedWith: textColorButton, handler: nil)
        expectation(for: exists, evaluatedWith: backgroundColorButton, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        textColorButton.tap()
    }

//    func testLaunchPerformance() throws {
//        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
//            // This measures how long it takes to launch your application.
//            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
//                XCUIApplication().launch()
//            }
//        }
//    }
}

extension HttpServer {
    func stubRequestsForEndpoint(_ endpoint: String) {
        var filename = endpoint
        if filename.hasSuffix(".json") {
            filename = String(filename.dropLast(5))
        }
        
        NSLog("filename: %@", filename)
        
        self["/" + endpoint] = { _ in
            NSLog("loading")
//            let url = Bundle.main.resourceURL!.appendingPathComponent(filename)
            let url = Bundle.main.url(forResource: filename, withExtension: "json")
            let session = URLSession(configuration: .default)
            NSLog("loading json...")
            let (data, _, _) = session.synchronousDataTask(with: url!)
            NSLog("Data: %@", data?.debugDescription ?? "null")
            
            guard let jsonData = data, let json = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) else {
                assertionFailure("Could not convert data to json")
                return HttpResponse.ok(.json("{}".data(using: .utf8) as AnyObject))
            }
            
            return HttpResponse.ok(.json(json as AnyObject))
        }
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
