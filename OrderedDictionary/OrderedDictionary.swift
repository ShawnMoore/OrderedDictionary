//
//  OrderedDictionary.swift
//  OrderedDictionary
//
//  Created by Shawn Moore on 4/16/16.
//  Copyright © 2016 Shawn Moore. All rights reserved.
//

import Foundation

public struct OrderedDictionary<Key: Hashable, Value>: CollectionType, DictionaryLiteralConvertible, CustomStringConvertible, CustomDebugStringConvertible {
    // MARK: - Associated Types
    public typealias Index = DictionaryIndex<Key, Value>
    
    // MARK: - Type Aliases
    public typealias Element = (Key, Value)
    
    // MARK: - Instance Properties
    public var startIndex: Index {
        return _dictionary.startIndex
    }
    
    public var endIndex: Index {
        return _dictionary.endIndex
    }
    
    public var description: String {
        return "[\(map({ "\($0.0): \($0.1)" }).joinWithSeparator(", "))]"
    }
    
    public var debugDescription: String {
        return description
    }
    
    // MARK: - Private Instance Properties
    private var _keys: [Key]
    private var _dictionary: Dictionary<Key, Value>
    
    // MARK: - Initializers
    public init() {
        _keys = []
        _dictionary = [:]
    }
    
    public init(dictionaryLiteral elements: Element...) {
        self.init()
        
        for element in elements {
            _keys.append(element.0)
            _dictionary[element.0] = element.1
        }
    }
    
    public init(minimumCapacity: Int) {
        _keys = []
        _keys.reserveCapacity(minimumCapacity)
        _dictionary = Dictionary(minimumCapacity: minimumCapacity)
    }
    
    // MARK: - Instance Methods
    public func generate() -> AnyGenerator<Element> {
        var index = 0
        
        return AnyGenerator<Element> {
            if let value = self._dictionary[self._keys[index]] where index < self._keys.count {
                let returnValue = (self._keys[index], value)
                index += 1
                return returnValue
            }
            return nil
        }
    }
    
    // MARK: - Subscripts
    public subscript(index: Index) -> Element {
        return _dictionary[index]
    }
}