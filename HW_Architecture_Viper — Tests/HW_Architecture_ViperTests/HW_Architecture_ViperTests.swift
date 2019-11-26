//
//  HW_Architecture_ViperTests.swift
//  HW_Architecture_ViperTests
//
//  Created by Давид on 24/11/2019.
//  Copyright © 2019 David. All rights reserved.
//

@testable import HW_Architecture_Viper
import XCTest

class HW_Architecture_ViperTests: XCTestCase {
    
    var serverService: ServerService!
    var mockSession: MockURLSession!

    override func setUp() {
        super.setUp()
        mockSession = MockURLSession()
        serverService = ServerService(withSession: mockSession)
    }

    override func tearDown() {
        serverService = nil
        mockSession = nil
        super.tearDown()
    }
    
    func testThatCheckOnErrorLoadedData() {
        // arrange
        let promise = expectation(description: "Completion get data")
        let data = Data(base64Encoded: "267454238428")
        mockSession.data = data
        var responseData: Data?
        let url = "http://icons.iconarchive.com/icons/dtafalonso/ios8/512/Calendar-icon.png"
        //act
        serverService.downloadImage(imageURL: url) {data,_,_ in
            responseData = data
            promise.fulfill()
        }
        waitForExpectations(timeout: 5.0, handler: nil)
        //assets
        XCTAssertNotNil(responseData)
    }
}
