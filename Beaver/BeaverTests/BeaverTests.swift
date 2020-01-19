//
//  BeaverTests.swift
//  BeaverTests
//
//  Created by Ravi Tripathi on 19/01/20.
//  Copyright © 2020 Ravi Tripathi. All rights reserved.
//

import XCTest
@testable import Beaver

class BeaverTests: XCTestCase {
    
    var codableToBeStored: TestCodable!
    
    override func setUp() {
        super.setUp()
        codableToBeStored = TestCodable(userName: "Test Name", email: "Test Email", phoneNumber: "Test Phone Number", fullName: "Test Full Name")
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        codableToBeStored = nil
        super.tearDown()
    }

    func testStoreCodable() {
        //Given
        //self.codableToBeStored
        
        //When
        codableToBeStored.store(to: .documents, withFileName: "TestCodable.json") { (result) in
            //Then
            XCTAssertTrue(result.success)
        }
    }
    
    func testRetrieveCodable() {
        //Given
        //self.codableToBeStored exists and it has been store successfully
        codableToBeStored.store(to: .documents, withFileName: "TestCodable.json") { (result) in
            if result.success {
                //When
                self.codableToBeStored.retrieve(withFileName: "TestCodable.json", from: .documents) { (result) in
                    //Then
                    XCTAssertTrue(result.success)
                }
            }
        }
        
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
//            self.testStoreCodable()
//            self.testRetrieveCodable()
            // Put the code you want to measure the time of here.
        }
    }

}
