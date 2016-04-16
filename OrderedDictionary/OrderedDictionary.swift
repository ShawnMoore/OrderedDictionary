//
//  OrderedDictionary.swift
//  OrderedDictionary
//
//  Created by Shawn Moore on 4/16/16.
//  Copyright © 2016 Shawn Moore. All rights reserved.
//

import Foundation

struct OrderedDictionary<Key: Hashable, Value>: CollectionType {
    // MARK: - Private Properties
    private var _keys: [Key] = []
    private var _dictionary: Dictionary<Key, Value> = [:]
    
    // MARK: - Associated Types
    typealias Index = DictionaryIndex<Key, Value>
    
    // MARK: - Type Aliases
    typealias Element = (Key, Value)
    
    // MARK: - Instance Properties
    var startIndex: Index {
        return _dictionary.startIndex
    }
    
    var endIndex: Index {
        return _dictionary.endIndex
    }
    
    // MARK: - Instance Methods
    func generate() -> AnyGenerator<Element> {
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
    subscript(index: Index) -> Element {
        return _dictionary[index]
    }
}