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
    var firstEntry_string: (String, String)?
    var secondEntry_string: (String, String)?
    var thirdEntry_string: (String, String)?
    
    // MARK: Integer
    var firstEntry_int: (Int, String)?
    var secondEntry_int: (Int, String)?
    var thirdEntry_int: (Int, String)?
    
    // MARK: - Setup
    func setUpString() {
        firstEntry_string = ("Key 1", "Value 1")
        secondEntry_string = ("Key 2", "Value 2")
        thirdEntry_string = ("Key 3", "Value 3")
    }
    
    func setUpInt() {
        firstEntry_int = (1, "Value 1")
        secondEntry_int = (2, "Value 1")
        thirdEntry_int = (2, "Value 1")
    }
    
    // MARK: - Tear Down
    override func tearDown() {
        // String
        firstEntry_string = nil
        secondEntry_string = nil
        thirdEntry_string = nil
        
        // Int
        firstEntry_int = nil
        secondEntry_int = nil
        thirdEntry_int = nil
        
        super.tearDown()
    }
    
    // MARK: - Tests
    
    
    // MARK: - Private Helper Functions
    /// A derivative over the provided setUp function but without initializing every single property every single time. Allows multiple setUps to simplify initilization.
    private func test(setUp setUp: ()->()..., test: ()->()) {
        for setUp in setUp {
            setUp()
        }
        test()
    }
    
}
