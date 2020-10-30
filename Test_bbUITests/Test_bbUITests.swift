//
//  Test_bbUITests.swift
//  Test_bbUITests
//
//  Created by Frane Poljak on 28/10/2020.
//  Copyright © 2020 Bellabeat. All rights reserved.
//

import XCTest

class Test_bbUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws { }

    func testExample() throws {
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
