//
//  OrderedDictionary.swift
//  OrderedDictionary
//
//  Created by Shawn Moore on 4/16/16.
//  Copyright © 2016 Shawn Moore. All rights reserved.
//
//  Dictionary Documentation comes from Apple Inc.

import Foundation

public struct OrderedDictionary<Key: Hashable, Value>: CollectionType, DictionaryLiteralConvertible, CustomStringConvertible, CustomDebugStringConvertible, RangeReplaceableCollectionType {
    // MARK: - Associated Types
    public typealias Index = Int
    
    // MARK: - Type Aliases
    public typealias Element = (Key, Value)
    
    // MARK: - Instance Properties
    /// An array containing just the keys of _self_ in order.
    private(set) var keys: [Key]
    
    /// An array containing just the values of _self_ in order.
    public var values: [Value] {
        return map({$0.1})
    }
    
    public var startIndex: Index {
        return keys.startIndex
    }
    
    public var endIndex: Index {
        return keys.endIndex
    }
    
    public var description: String {
        return "[\(map({ "\($0.0): \($0.1)" }).joinWithSeparator(", "))]"
    }
    
    public var debugDescription: String {
        return description
    }
    
    public var capacity: Int {
        return keys.capacity
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
    
    public init<S : SequenceType where S.Generator.Element == Element>(_ s: S) {
        self.init()
        
        for element in s {
            keys.append(element.0)
            _dictionary[element.0] = element.1
        }
    }
    
    /// Create a dictionary with at least the given number of elements worth of storage. The actual capacity will be the smallest power of 2 that's >= minimumCapacity.
    public init(minimumCapacity: Int) {
        keys = []
        keys.reserveCapacity(minimumCapacity)
        _dictionary = Dictionary(minimumCapacity: minimumCapacity)
    }
    
    // MARK: - Instance Methods
    
    public mutating func append(value: Value, forKey key: Key) {
        self.append((key, value))
    }
    
    public mutating func append(x: Element) {
        guard keys.indexOf(x.0) == nil else { return }
        
        keys.append(x.0)
        _dictionary[x.0] = x.1
    }
    
    /// Append the elements of newElements to self.
    public mutating func appendContentsOf<C : CollectionType where C.Generator.Element == Element>(newElements: C) {
        for element in newElements {
            self.append(element)
        }
    }
    
    public mutating func appendContentsOf<S : SequenceType where S.Generator.Element == Element>(newElements: S) {
        for element in newElements {
            self.append(element)
        }
    }
    
    /// Returns a generator over the (key, value) pairs.
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
    
    /// Returns the Index for the given key, or nil if the key is not present in the dictionary.
    @warn_unused_result public func indexForKey(key: Key) -> Index? {
        return keys.indexOf(key)
    }
    
    public mutating func insert(newElement: Element, atIndex i: Int) {
        guard keys.indexOf(newElement.0) == nil else { return }
        
        keys.insert(newElement.0, atIndex: i)
        _dictionary[newElement.0] = newElement.1
    }
    
    /// If !self.isEmpty, return the first key-value pair in the sequence of elements, otherwise return nil.
    public mutating func popFirst() -> Element? {
        guard !self.isEmpty else { return nil }
        
        let key = keys.removeFirst()
        
        if let value = _dictionary[key] {
            return (key, value)
        } else {
            keys.insert(key, atIndex: 0)
        }
        
        return nil
    }
    
    /// If !self.isEmpty, return the last key-value pair in the sequence of elements, otherwise return nil.
    public mutating func popLast() -> Element? {
        guard !self.isEmpty else { return nil }
        
        let key = keys.removeLast()
        
        if let value = _dictionary[key] {
            return (key, value)
        } else {
            keys.insert(key, atIndex: 0)
        }
        
        return nil
    }
    
    public mutating func removeAll(keepCapacity keepCapacity: Bool = false) {
        _dictionary.removeAll(keepCapacity: keepCapacity)
        keys.removeAll(keepCapacity: keepCapacity)
    }
    
    public mutating func removeAtIndex(index: Int) -> Element {
        let key = keys.removeAtIndex(index)
        return (key, _dictionary[key]!)
    }
    
    /// Remove a given key and the associated value from the dictionary. Returns the value that was removed, or nil if the key was not present in the dictionary.
    public mutating func removeValueForKey(key: Key) -> Value? {
        guard let value = _dictionary.removeValueForKey(key) else { return nil }
        
        if let index = keys.indexOf(key) {
            keys.removeAtIndex(index)
        }
        
        return value
    }
    
    public mutating func replaceRange<C : CollectionType where C.Generator.Element == Element>(subRange: Range<Int>, with newElements: C) {
        for key in keys[subRange.startIndex...subRange.endIndex] {
            _dictionary.removeValueForKey(key)
        }
        keys.removeRange(subRange)
        
        self.insertContentsOf(newElements, at: subRange.startIndex)
    }
    
    /** 
    Sort self in-place according to isOrderedBefore.
     
    The sorting algorithm is not stable (can change the relative order of elements for which isOrderedBefore does not establish an order).
     
    Requires: isOrderedBefore is a strict weak ordering over the elements in self.
    */
    public mutating func sortInPlace(isOrderedBefore: (Key, Key) -> Bool) {
        keys.sortInPlace(isOrderedBefore)
    }
    
    /// Update the value stored in the dictionary for the given key, or, if the key does not exist, add a new key-value pair to the dictionary.
    public mutating func updateValue(value: Value, forKey key: Key) -> Value? {
        let value = _dictionary.updateValue(value, forKey: key)
        
        if value == nil {
            _dictionary[key] = value
            keys.append(key)
        }
        
        return value
    }
    
    // MARK: - Subscripts
    public subscript(index: Index) -> Element {
        return (keys[index], _dictionary[keys[index]]!)
    }
    
    /// Access the value associated with the given key.
    public subscript (key: Key) -> Value? {
        get {
            return _dictionary[key]
        }
        set {
            if let value = newValue {
                updateValue(value, forKey: key)
            } else {
                removeValueForKey(key)
            }
        }
    }
}