//
//  OrderedDictionaryTests.swift
//  OrderedDictionaryTests
//
//  Created by Shawn Moore on 4/15/16.
//  Copyright © 2016 Shawn Moore. All rights reserved.
//

import XCTest
@testable import OrderedDictionary

class OrderedDictionaryTests: XCTestCase {
    // MARK: - Properties
    // MARK: String
    var firstKey_string: String?
    var firstValue_string: String?
    var secondKey_string: String?
    var secondValue_string: String?
    var thirdKey_string: String?
    var thirdValue_string: String?
    
    // MARK: Integer
    var firstKey_int: Int?
    var secondKey_int: Int?
    var thirdKey_int: Int?
    
    // MARK: - Setup
    override func setUp() {
        // Setup String
        firstKey_string = "Key 1"
        secondKey_string = "Key 2"
        thirdKey_string = "Key 3"
        
        firstValue_string = "Value 1"
        secondValue_string = "Value 2"
        thirdValue_string = "Value 3"
        
        // Setup Int
        firstKey_int = 1
        secondKey_int = 2
        thirdKey_int = 3
    }
    
    // MARK: - Tear Down
    override func tearDown() {
        // String
        firstKey_string = nil
        firstKey_string = nil
        secondKey_string = nil
        secondValue_string = nil
        thirdValue_string = nil
        thirdKey_string = nil
        
        // Int
        firstKey_int = nil
        secondKey_int = nil
        thirdKey_int = nil
        
        super.tearDown()
    }
    
    // MARK: - Init Tests
    func testEmptyInit() {
        let dict = OrderedDictionary<Int,String>()
        
        // Verify count
        XCTAssertEqual(dict.count, 0, "Init() -> Empty Dictionary was not empty")
        XCTAssertEqual(dict.keys.count, 0, "Init() -> Empty Dictionary keys were not empty")
        XCTAssertEqual(dict.values.count, 0, "Init() -> Empty Dictionary values were not empty")
    }
    
    func testDictionaryLiteralInit() {
        let dict: OrderedDictionary = [firstKey_int!: firstValue_string!]
        
        // Verify count
        XCTAssertEqual(dict.count, 1, "Init(elements: Element...) -> Dictionary did not contain element")
        XCTAssertEqual(dict.keys.count, 1, "Init(elements: Element...) -> Dictionary keys did not contain a key")
        XCTAssertEqual(dict.values.count, 1, "Init(elements: Element...) -> Dictionary keys did not contain a value")
        
        // Verify element
        XCTAssertEqual(dict.first!.0, firstKey_int!, "Init(elements: Element...) -> Keys did not match")
        XCTAssertEqual(dict.first!.1, firstValue_string!, "Init(elements: Element...) -> Values did not match")
    }
}
