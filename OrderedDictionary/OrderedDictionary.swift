//
//  OrderedDictionary.swift
//  OrderedDictionary
//
//  Created by Shawn Moore on 4/16/16.
//  Copyright © 2016 Shawn Moore. All rights reserved.
//

import Foundation

public struct OrderedDictionary<Key: Hashable, Value>: CollectionType {
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
    
    // MARK: - Private Instance Properties
    private var _keys: [Key] = []
    private var _dictionary: Dictionary<Key, Value> = [:]
    
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