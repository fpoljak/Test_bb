//
//  Test_bbTests.swift
//  Test_bbTests
//
//  Created by Frane Poljak on 28/10/2020.
//  Copyright © 2020 Bellabeat. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
import RxBlocking
import OHHTTPStubs

@testable import Test_bb

class Test_bbTests: XCTestCase {
    
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!

    override func setUpWithError() throws {
        try super.setUpWithError()
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        HTTPStubs.setEnabled(true)
        let host = URL(string: ApiService.baseUrl)!.host!
        stub(condition: isHost(host)) { request in
            if let endpoint = request.url?.lastPathComponent {
                var filename = endpoint
                if !filename.hasSuffix(".json") {
                    filename += ".json"
                }
                if let path = OHPathForFile(filename, type(of: self)) {
                    return fixture(filePath: path, headers: ["Content-Type":"application/json"])
                }
            }
            let data = "{}".data(using: String.Encoding.utf8)
            return HTTPStubsResponse(data: data!, statusCode: 200, headers: ["Content-Type":"application/json"])
        }
    }

    override func tearDownWithError() throws {
        HTTPStubs.removeAllStubs()
        try super.tearDownWithError()
    }

    func testHexColorValidity() throws {
        // valid colors:
        XCTAssertTrue(UIColor.isValidHexColor(hexStr: "000000"))
        XCTAssertTrue(UIColor.isValidHexColor(hexStr: "FFFFFF"))
        XCTAssertTrue(UIColor.isValidHexColor(hexStr: "cfcfcf")) // should support lowercase too
        XCTAssertTrue(UIColor.isValidHexColor(hexStr: "A1B2C3"))
        // invalid colors:
        XCTAssertFalse(UIColor.isValidHexColor(hexStr: "ABCD"))
        XCTAssertFalse(UIColor.isValidHexColor(hexStr: "12345T"))
        XCTAssertFalse(UIColor.isValidHexColor(hexStr: "1234567"))
    }
    
    func testColorFormHExString() throws {
        // valid color:
        var color = UIColor.fromHexString(hexStr: "FFFFFF")
        var (r, g, b, a) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        XCTAssertTrue(r == 1.0 && g == 1.0 && b == 1.0 && a == 1.0, "FFFFFF should create UIColor with rgba coomponents: 1.0, 1.0, 1.0, 1.0")
        
        // invalid color:
        color = UIColor.fromHexString(hexStr: "12345T")
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        XCTAssertTrue(r == 0.0 && g == 0.0 && b == 0.0 && a == 1.0, "Invalid colors should fall back to black color (0, 0, 0, 1)")
    }

//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
