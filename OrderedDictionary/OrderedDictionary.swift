//
//  OrderedDictionary.swift
//  OrderedDictionary
//
//  Created by Shawn Moore on 4/16/16.
//  Copyright © 2016 Shawn Moore. All rights reserved.
//
//  Dictionary Documentation comes from Apple Inc.

import Foundation

public struct OrderedDictionary<Key: Hashable, Value>: Collection, ExpressibleByDictionaryLiteral, CustomStringConvertible, CustomDebugStringConvertible, RangeReplaceableCollection {

    // MARK: - Associated Types
    public typealias Index = Int
    
    // MARK: - Type Aliases
    public typealias Element = (Key, Value)
    
    // MARK: - Instance Properties
    /// An array containing just the keys of _self_ in order.
    private(set) var keys: [Key]
    
    /// An array containing just the values of _self_ in order.
    var values: [Value] {
        return map({$0.1})
    }
    
    public var startIndex: Index {
        return keys.startIndex
    }
    
    public var endIndex: Index {
        return keys.endIndex
    }
    
    public var description: String {
        return "[\(map({ "\($0.0): \($0.1)" }).joined(separator: ", "))]"
    }
    
    public var debugDescription: String {
        return description
    }
    
    public var capacity: Int {
        return keys.capacity
    }
    
    /// An unordered version of the OrderedDictionary.
    private(set) var dictionary: Dictionary<Key, Value>
    
    // MARK: - Initializers
    public init() {
        keys = []
        dictionary = [:]
    }
    
    public init(dictionaryLiteral elements: Element...) {
        self.init()
        
        for element in elements {
            keys.append(element.0)
            dictionary[element.0] = element.1
        }
    }
    
    /// Creates a collection instance that contains elements.
    public init<S : Sequence>(_ s: S, sort: ((Key, Key) -> Bool)? = nil ) where S.Iterator.Element == Element {
        self.init()
        
        for element in s {
            keys.append(element.0)
            dictionary[element.0] = element.1
        }
        
        if let sort = sort {
            keys.sort(by: sort)
        }
    }
    
    /// Creates a collection instance that contains elements.
    public init<C : Collection>(_ c: C, sort: ((Key, Key) -> Bool)? = nil ) where C.Iterator.Element == Element {
        self.init()
        
        for element in c {
            keys.append(element.0)
            dictionary[element.0] = element.1
        }
        
        if let sort = sort {
            keys.sort(by: sort)
        }
    }
    
    /// Create a dictionary with at least the given number of elements worth of storage. The actual capacity will be the smallest power of 2 that's >= minimumCapacity.
    public init(minimumCapacity: Int) {
        keys = []
        keys.reserveCapacity(minimumCapacity)
        dictionary = Dictionary(minimumCapacity: minimumCapacity)
    }
    
    // MARK: - Instance Methods
    
    public mutating func append(_ value: Value, forKey key: Key) {
        self.append((key, value))
    }
    
    public mutating func append(_ x: Element) {
        guard keys.index(of: x.0) == nil else { return }
        
        keys.append(x.0)
        dictionary[x.0] = x.1
    }
    
    /// Append the elements of newElements to self.
    public mutating func appendContentsOf<C : Collection>(_ newElements: C) where C.Iterator.Element == Element {
        for element in newElements {
            self.append(element)
        }
    }
    
    public mutating func append<S : Sequence>(contentsOf newElements: S) where S.Iterator.Element == Element {
        for element in newElements {
            self.append(element)
        }
    }
    
    /// Returns a generator over the (key, value) pairs.
    public func makeIterator() -> AnyIterator<Element> {
        var index = 0
        
        return AnyIterator<Element> {
            if let value = self.dictionary[self.keys[index]], index < self.keys.count {
                let returnValue = (self.keys[index], value)
                index += 1
                return returnValue
            }
            return nil
        }
    }
    
    /// Returns the Index for the given key, or nil if the key is not present in the dictionary.
    public func indexForKey(_ key: Key) -> Index? {
        return keys.index(of: key)
    }
    
    public mutating func insert(_ newElement: Element, at i: Int) {
        guard keys.index(of: newElement.0) == nil else { return }
        
        keys.insert(newElement.0, at: i)
        dictionary[newElement.0] = newElement.1
    }
    
    /// If !self.isEmpty, return the first key-value pair in the sequence of elements, otherwise return nil.
    public mutating func popFirst() -> Element? {
        guard !self.isEmpty else { return nil }
        
        let key = keys.removeFirst()
        
        if let value = dictionary[key] {
            return (key, value)
        } else {
            keys.insert(key, at: 0)
        }
        
        return nil
    }
    
    /// If !self.isEmpty, return the last key-value pair in the sequence of elements, otherwise return nil.
    public mutating func popLast() -> Element? {
        guard !self.isEmpty else { return nil }
        
        let key = keys.removeLast()
        
        if let value = dictionary[key] {
            return (key, value)
        } else {
            keys.insert(key, at: 0)
        }
        
        return nil
    }
    
    public mutating func removeAll(keepingCapacity keepCapacity: Bool = false) {
        dictionary.removeAll(keepingCapacity: keepCapacity)
        keys.removeAll(keepingCapacity: keepCapacity)
    }
    
    public mutating func remove(at index: Int) -> Element {
        let key = keys.remove(at: index)
        return (key, dictionary[key]!)
    }
    
    /// Remove a given key and the associated value from the dictionary. Returns the value that was removed, or nil if the key was not present in the dictionary.
    public mutating func removeValueForKey(_ key: Key) -> Value? {
        guard let value = dictionary.removeValue(forKey: key) else { return nil }
        
        if let index = keys.index(of: key) {
            keys.remove(at: index)
        }
        
        return value
    }
    
    /// Removes the elements at the given range. Returns the elements that was removed.
    public mutating func removeValuesAtRange(_ range: Range<Index>) -> [Element] {
        var returnArray = [Element]()
        
        let keys = Array(self.keys[range])
        self.keys.removeSubrange(range)
        
        for key in keys {
            if let value = self.dictionary.removeValue(forKey: key) {
                returnArray.append((key,value))
            }
        }
        
        return returnArray
    }
    
    /// Replaces the elements at the subrange with the provided elements
    public mutating func replaceSubrange<C : Collection>(_ subRange: Range<Int>, with newElements: C) where C.Iterator.Element == Element {
        for key in keys[subRange.lowerBound...subRange.upperBound] {
            dictionary.removeValue(forKey: key)
        }
        keys.removeSubrange(subRange)
        
        self.insert(contentsOf: newElements, at: subRange.lowerBound)
    }
    
    /// Returns the position immediately after the given index.
    ///
    /// - Parameter i: A valid index of the collection. `i` must be less than
    ///   `endIndex`.
    /// - Returns: The index value immediately after `i`.
    public func index(after i: Int) -> Int {
        return i + 1
    }
    
    /** 
    Sort _self_ in-place according to isOrderedBefore.
     
    The sorting algorithm is not stable (can change the relative order of elements for which isOrderedBefore does not establish an order).
     
    Requires: isOrderedBefore is a strict weak ordering over the elements in self.
    */
    public mutating func sortInPlace(_ isOrderedBefore: (Key, Key) -> Bool) {
        keys.sort(by: isOrderedBefore)
    }
    
    /// Update the value stored in the dictionary for the given key, or, if the key does not exist, add a new key-value pair to the dictionary.
    public mutating func updateValue(_ value: Value, forKey key: Key) -> Value? {
        let value = dictionary.updateValue(value, forKey: key)
        
        if value == nil {
            dictionary[key] = value
            keys.append(key)
        }
        
        return value
    }
    
    // MARK: - Subscripts
    public subscript(index: Index) -> Element {
        return (keys[index], dictionary[keys[index]]!)
    }
    
    /// Access the value associated with the given key.
    public subscript(key: Key) -> Value? {
        get {
            return dictionary[key]
        }
        set {
            if let value = newValue {
                _ = updateValue(value, forKey: key)
            } else {
                _ = removeValueForKey(key)
            }
        }
    }
    
    public subscript(keys: Key...) -> OrderedDictionary<Key, Value> {
        var dict = OrderedDictionary<Key, Value>()
        
        for key in keys {
            dict[key] = self[key]
        }
        
        return dict
    }
    
    public subscript(range: Range<Index>) -> OrderedDictionary<Key, Value> {
        get {
            var returnDict = OrderedDictionary<Key, Value>()
            var keys = self.keys
            var dict = self.dictionary
            
            keys.replaceSubrange(range, with: [])
            
            for key in keys {
                dict.removeValue(forKey: key)
            }
            
            returnDict.keys = Array(self.keys[range])
            returnDict.dictionary = dict
            
            return returnDict
        }
    }
}

//extension Dictionary {
//    /// Sort the current dictionary
//    public func sort(_ sort: @escaping ((Key, Key) -> Bool)) -> OrderedDictionary<Key, Value> {
//        return OrderedDictionary(self, sort: sort)
//    }
//}
