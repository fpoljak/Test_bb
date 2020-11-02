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
        
        continueAfterFailure = false
        
        server = HttpServer()
        server.stubRequestsForEndpoint("interview.json")
        try server.start()
        
        app = XCUIApplication()
        app.launchArguments += ["TESTING"]
        
        app.launch()
    }

    override func tearDownWithError() throws {
        server.stop()
        try super.tearDownWithError()
    }

    func testExample() throws {
        let label = app.staticTexts.matching(identifier: "main_title_label").firstMatch
        
        let textColorButton = app.buttons["Promijeni boju teksta"]
        let backgroundColorButton = app.buttons["Promijeni boju pozadine"]
        
        let exists = NSPredicate(format: "exists == true")
        
        expectation(for: exists, evaluatedWith: textColorButton, handler: nil)
        expectation(for: exists, evaluatedWith: backgroundColorButton, handler: nil)
        
        waitForExpectations(timeout: 5.0) { [unowned self] error in
            guard error == nil else {
                return
            }
            
            XCTAssertEqual(label.label, "Title text")
            
            var testColorPicker: ((XCUIElement, Bool) -> Void)!
            testColorPicker = { [unowned self] (button: XCUIElement, isText: Bool) -> Void in
                button.tap()
                
                let label = self.app.staticTexts.matching(identifier: "colorpicker_title_label").firstMatch
                let cells = self.app.collectionViews.cells
                let firstCell = cells.firstMatch
                
                self.expectation(for: exists, evaluatedWith: firstCell, handler: nil)
                
                self.waitForExpectations(timeout: 5.0, handler: { error in
                    guard error == nil else {
                        return
                    }
                    XCTAssertEqual(label.label, "Odaberi boju \(isText ? "teksta" : "pozadine")")
                    XCTAssertEqual(cells.count, 5, "There should be 5 colors to choose from")
                    
                    cells.element(boundBy: Int.random(in: 0...4)).tap() // tap on any cell, beehaviour should be identical (we don't test colors here
                    
                    if isText {
                        self.expectation(for: exists, evaluatedWith: button, handler: nil)
                        self.waitForExpectations(timeout: 1.0, handler: { error in
                            testColorPicker(backgroundColorButton, false)
                        })
                    }
                })
            }
            
            testColorPicker(textColorButton, true)
        }
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}

extension HttpServer {
    func stubRequestsForEndpoint(_ endpoint: String) {
        var filename = endpoint
        if filename.hasSuffix(".json") {
            filename = String(filename.dropLast(5))
        }
        
        self["/" + endpoint] = { _ in
            guard let url = Bundle(for: Test_bbUITests.self).url(forResource: filename, withExtension: "json") else {
                return HttpResponse.ok(.json("{}".data(using: .utf8) as AnyObject))
            }
            guard let data = try? Data(contentsOf: url) else {
                return HttpResponse.ok(.json("{}".data(using: .utf8) as AnyObject))
            }
            
            return HttpResponse.ok(.data(data, contentType: "application/json"))
        }
    }
}
