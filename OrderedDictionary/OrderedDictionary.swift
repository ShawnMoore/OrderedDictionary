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
    private(set) var keys: [Key]
    
    public var values: [Value] {
        return map({$0.1})
    }
    
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
    private var _dictionary: Dictionary<Key, Value>
    
    // MARK: - Initializers
    public init() {
        keys = []
        _dictionary = [:]
    }
    
    public init(dictionaryLiteral elements: Element...) {
        self.init()
        
        for element in elements {
            keys.append(element.0)
            _dictionary[element.0] = element.1
        }
    }
    
    public init(minimumCapacity: Int) {
        keys = []
        keys.reserveCapacity(minimumCapacity)
        _dictionary = Dictionary(minimumCapacity: minimumCapacity)
    }
    
    // MARK: - Instance Methods
    public func generate() -> AnyGenerator<Element> {
        var index = 0
        
        return AnyGenerator<Element> {
            if let value = self._dictionary[self.keys[index]] where index < self.keys.count {
                let returnValue = (self.keys[index], value)
                index += 1
                return returnValue
            }
            return nil
        }
    }
    
    @warn_unused_result func indexForKey(key: Key) -> Index? {
        return _dictionary.indexForKey(key)
    }
    
    mutating func popFirst() -> Element? {
        guard !self.isEmpty else { return nil }
        
        let key = keys.removeFirst()
        
        if let value = _dictionary[key] {
            return (key, value)
        } else {
            keys.insert(key, atIndex: 0)
        }
        
        return nil
    }
    
    mutating func removeAll(keepCapacity keepCapacity: Bool = false) {
        _dictionary.removeAll(keepCapacity: keepCapacity)
        keys.removeAll(keepCapacity: keepCapacity)
    }
    
    mutating func removeAtIndex(index: DictionaryIndex<Key, Value>) -> (Key, Value) {
        let element = _dictionary.removeAtIndex(index)
        
        if let index = keys.indexOf(element.0) {
            keys.removeAtIndex(index)
        }
        
        return element
    }
    
    mutating func removeValueForKey(key: Key) -> Value? {
        guard let value = _dictionary.removeValueForKey(key) else { return nil }
        
        if let index = keys.indexOf(key) {
            keys.removeAtIndex(index)
        }
        
        return value
    }
    
    mutating func updateValue(value: Value, forKey key: Key) -> Value? {
        let value = _dictionary.updateValue(value, forKey: key)
        
        if value == nil {
            _dictionary[key] = value
            keys.append(key)
        }
        
        return value
    }
    
    // MARK: - Subscripts
    public subscript(index: Index) -> Element {
        return _dictionary[index]
    }
    
    subscript (key: Key) -> Value? {
        get {
            return _dictionary[key]
        }
        set {
            if let value = newValue {
                _dictionary[key] = value
                
                if keys.indexOf(key) == nil {
                    keys.append(key)
                }
            } else {
                removeValueForKey(key)
            }
        }
    }
}