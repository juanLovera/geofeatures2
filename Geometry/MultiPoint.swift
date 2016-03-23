/*
 *   MultiPoint.swift
 *
 *   Copyright 2016 Tony Stone
 *
 *   Licensed under the Apache License, Version 2.0 (the "License");
 *   you may not use this file except in compliance with the License.
 *   You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 *   Unless required by applicable law or agreed to in writing, software
 *   distributed under the License is distributed on an "AS IS" BASIS,
 *   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *   See the License for the specific language governing permissions and
 *   limitations under the License.
 *
 *   Created by Tony Stone on 2/14/16.
 */
import Swift

/*
    NOTE: This file was auto generated by gyb from file GeometryCollection.swift.gyb using the following command.

        ~/gyb --line-directive '' -DSelf=MultiPoint -DElement=Point -DCoordinateSpecialized=true -o MultiPoint.swift MultiCollection.swift.gyb

    Do NOT edit this file directly as it will be regenerated automatically when needed.
*/

/**
    MultiPoint
 
    A MultiPoint is a collection of some number of Point objects.
 
    All the elements in a MultiPoint shall be in the same Spatial Reference System. This is also the Spatial Reference System for the MultiPoint.
 */

public struct MultiPoint<CoordinateType : protocol<Coordinate, CopyConstructable>> : Geometry  {

    public typealias Element = Point<CoordinateType>
    
    public let precision: Precision
    public let coordinateReferenceSystem: CoordinateReferenceSystem

    public init(coordinateReferenceSystem: CoordinateReferenceSystem) {
        self.init(coordinateReferenceSystem: coordinateReferenceSystem, precision: defaultPrecision)
    }
    
    public init(precision: Precision) {
        self.init(coordinateReferenceSystem: defaultCoordinateReferenceSystem, precision: precision)
    }
    
    public init(coordinateReferenceSystem: CoordinateReferenceSystem, precision: Precision) {
        self.precision = precision
        self.coordinateReferenceSystem = coordinateReferenceSystem
        
        storage = CollectionBuffer<Element>.create(8) { _ in 0 } as! CollectionBuffer<Element>
    }
    
    internal var storage: CollectionBuffer<Element>
}

// MARK: Private methods

extension MultiPoint {
    
    @inline(__always)
    private mutating func _ensureUniquelyReferenced() {
        if !isUniquelyReferencedNonObjC(&storage) {
            storage = storage.clone()
        }
    }
    
    @inline(__always)
    private mutating func _resizeIfNeeded() {
        if storage.allocatedElementCount == count {
            storage = storage.resize(count * 2)
        }
    }
}

// MARK:  Collection conformance

extension MultiPoint : Collection {

    /**
        MultiPoints are empty constructable
     */
    public init() {
        self.init(coordinateReferenceSystem: defaultCoordinateReferenceSystem, precision: defaultPrecision)
    }
    
    /**
        MultiPoint can be constructed from any SequenceType as long as it has an
        Element type equal the Geometry Element.
     */
    public init<S : SequenceType where S.Generator.Element == Element>(elements: S, coordinateReferenceSystem: CoordinateReferenceSystem = defaultCoordinateReferenceSystem, precision: Precision = defaultPrecision) {
    
        self.init(coordinateReferenceSystem: coordinateReferenceSystem, precision: precision)
        
        var generator = elements.generate()
        
        while let element = generator.next() {
            self.append(element)
        }
    }
    
    /**
        MultiPoint can be constructed from any CollectionType including Array as
        long as it has an Element type equal the Geometry Element and the Distance
        is an Int type.
     */
    public init<C : CollectionType where C.Generator.Element == Element>(elements: C, coordinateReferenceSystem: CoordinateReferenceSystem = defaultCoordinateReferenceSystem, precision: Precision = defaultPrecision) {
        
        self.init(coordinateReferenceSystem: coordinateReferenceSystem, precision: precision)
        
        self.reserveCapacity(numericCast(elements.count))

        var generator = elements.generate()
        
        while let element = generator.next() {
            self.append(element)
        }
    }
    
    /**
        - Returns: The number of Point objects.
     */
    public var count: Int {
        get { return self.storage.value }
    }

    /**
        - Returns: The current minimum capacity.
     */
    public var capacity: Int {
        get { return self.storage.allocatedElementCount }
    }

    /**
        Reserve enough space to store `minimumCapacity` elements.
     
        - Postcondition: `capacity >= minimumCapacity` and the array has mutable contiguous storage.
     */
    public mutating func reserveCapacity(minimumCapacity: Int) {
        
        if storage.allocatedElementCount < minimumCapacity {
            
            _ensureUniquelyReferenced()
            
            let newSize = max(storage.allocatedElementCount * 2, minimumCapacity)
            
            storage = storage.resize(newSize)
        }
    }

    /**
        Append `newElement` to this MultiPoint.
     */
    public mutating func append(newElement: Element) {
        
        _ensureUniquelyReferenced()
        _resizeIfNeeded()
        
        storage.withUnsafeMutablePointers { (value, elements)->Void in
            
            (elements + value.memory).initialize(newElement)
            value.memory += 1
        }
    }

    /**
        Append the elements of `newElements` to this MultiPoint.
     */
    public mutating func append<S : SequenceType where S.Generator.Element == Element>(contentsOf newElements: S) {
       
        var generator = newElements.generate()
        
        while let element = generator.next() {
            self.append(element)
        }
    }

    /**
        Append the elements of `newElements` to this MultiPoint.
     */
    public mutating func append<C : CollectionType where C.Generator.Element == Element>(contentsOf newElements: C) {
        
        self.reserveCapacity(numericCast(newElements.count))
        
        var generator = newElements.generate()
        
        while let element = generator.next() {
            self.append(element)
        }
    }


    /**
        Insert `newElement` at index `i` of this MultiPoint.
     
        - Requires: `i <= count`.
     */
    public mutating func insert(newElement: Element, atIndex index: Int) {
        guard ((index >= 0) && (index < storage.value)) else { preconditionFailure("Index out of range, can't insert Point.") }
        
        _ensureUniquelyReferenced()
        _resizeIfNeeded()
        
        storage.withUnsafeMutablePointers { (count, elements)->Void in
            
            var m = count.memory
            
            count.memory = count.memory &+ 1
            
            // Move the other elements
            while  m >= index {
                (elements + (m &+ 1)).moveInitializeFrom((elements + m), count: 1)
                m = m &- 1
            }
            (elements + index).initialize(newElement)
        }
    }

    
    /**
        Remove and return the element at index `i` of this MultiPoint.
     */
    public mutating func remove(at index: Int) -> Element {
        guard ((index >= 0) && (index < storage.value)) else { preconditionFailure("Index out of range, can't remove Point.") }
        
        return storage.withUnsafeMutablePointers { (count, elements)-> Element in
            
            let result = (elements + index).move()
            
            var m = index
            
            // Move the other elements
            while  m <  count.memory {
                (elements + m).moveInitializeFrom((elements + (m &+ 1)), count: 1)
                m = m &+ 1
            }
            count.memory = count.memory &- 1
            
            return result
        }
    }
    
    /**
     Remove an element from the end of this MultiPoint.
     
     - Requires: `count > 0`.
     */
    public mutating func removeLast() -> Element {
        guard storage.value > 0 else { preconditionFailure("can't removeLast from an empty MultiPoint.") }
        
        return storage.withUnsafeMutablePointers { (count, elements)-> Element in
            
            // No need to check for overflow in `count.memory - 1` because `count.memory` is known to be positive.
            count.memory = count.memory &- 1
            return (elements + count.memory).move()
        }
    }

    /**
        Remove all elements of this MultiPoint.
     
        - Postcondition: `capacity == 0` iff `keepCapacity` is `false`.
     */
    public mutating func removeAll(keepCapacity keepCapacity: Bool = false) {
        
        if keepCapacity {
        
            storage.withUnsafeMutablePointers { (count, elements)-> Void in
                count.memory = 0
            }
        } else {
            storage = CollectionBuffer<Element>.create(0) { _ in 0 } as! CollectionBuffer<Element>
        }
    }
}

// MARK: Collection conformance

extension MultiPoint {
    
    /**
        Always zero, which is the index of the first element when non-empty.
     */
    public var startIndex : Int { return 0 }

    /**
        A "past-the-end" element index; the successor of the last valid subscript argument.
     */
    public var endIndex   : Int { return storage.value  }
    
    public subscript(index : Int) -> Element {
        get {
            guard ((index >= 0) && (index < storage.value)) else { preconditionFailure("Index out of range.") }
            
            
            return storage.withUnsafeMutablePointerToElements { $0[index] }
        }
        set (newValue) {
            guard ((index >= 0) && (index < storage.value)) else { preconditionFailure("Index out of range.") }
            
            _ensureUniquelyReferenced()
        
            storage.withUnsafeMutablePointerToElements { elements->Void in
                
                (elements + index).destroy()
                (elements + index).initialize(newValue)
            }
        }
    }
}

// MARK: CustomStringConvertible & CustomDebugStringConvertible protocol conformance

extension MultiPoint : CustomStringConvertible, CustomDebugStringConvertible {
    
    public var description : String {
        return "\(self.dynamicType)(\(self.flatMap { String($0) }.joinWithSeparator(", ")))"
    }
    
    public var debugDescription : String {
        return self.description
    }
}

