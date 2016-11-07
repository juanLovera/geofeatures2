/*
 *   LineString.swift
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
    NOTE: This file was auto generated by gyb from file CoordinateCollection.swift.gyb using the following command.

        ~/gyb --line-directive '' -DSelf=LineString  -o LineString.swift CoordinateCollection.swift.gyb

    Do NOT edit this file directly as it will be regenerated automatically when needed.
*/

/**
    LineString

    A LineString is a Curve with linear interpolation between Coordinates. Each consecutive pair of
    Coordinates defines a Line segment.
 */
public struct LineString<CoordinateType: Coordinate & CopyConstructable> {

    public let precision: Precision
    public let coordinateReferenceSystem: CoordinateReferenceSystem

    public init(coordinateReferenceSystem: CoordinateReferenceSystem) {
        self.init(precision: defaultPrecision, coordinateReferenceSystem: coordinateReferenceSystem)
    }

    public init(precision: Precision) {
        self.init(precision: precision, coordinateReferenceSystem: defaultCoordinateReferenceSystem)
    }

    public init(precision: Precision, coordinateReferenceSystem: CoordinateReferenceSystem) {
        self.precision = precision
        self.coordinateReferenceSystem = coordinateReferenceSystem

        storage = CollectionBuffer<CoordinateType>.create(minimumCapacity: 8) { _ in 0 } as! CollectionBuffer<CoordinateType> // swiftlint:disable:this force_cast
    }

    /**
        Construct a LineString from another LineString (copy constructor).

        - parameters:
            - other: The LineString of the same type that you want to construct a new LineString from.
            - precision: The `Precision` model this polygon should use in calculations on it's coordinates.
            - coordinateReferenceSystem: The 'CoordinateReferenceSystem` this polygon should use in calculations on it's coordinates.

        - seealso: `CoordinateReferenceSystem`
        - seealso: `Precision`
     */
    public init(other: LineString<CoordinateType>, precision: Precision = defaultPrecision, coordinateReferenceSystem: CoordinateReferenceSystem = defaultCoordinateReferenceSystem) {

        self.init(precision: precision, coordinateReferenceSystem: coordinateReferenceSystem)

        other.storage.withUnsafeMutablePointers { (count, elements) -> Void in

            self.reserveCapacity(numericCast(count.pointee))

            for index in 0..<count.pointee {
                self.append(elements[index])
            }
        }
    }

    internal var storage: CollectionBuffer<CoordinateType>
}

extension LineString {

    @inline(__always)
    fileprivate mutating func _ensureUniquelyReferenced() {
        if !isKnownUniquelyReferenced(&storage) {
            storage = storage.clone()
        }
    }

    @inline(__always)
    fileprivate mutating func _resizeIfNeeded() {
        if storage.capacity == count {
            storage = storage.resize(count * 2)
        }
    }
}

// MARK: Collection conformance

extension LineString: Collection {

    /**
        LineStrings are empty constructable
     */
    public init() {
        self.init(precision: defaultPrecision, coordinateReferenceSystem: defaultCoordinateReferenceSystem)
    }

    /**
        LineString can be constructed from any Sequence as long as it has an
        Element type equal the Coordinate type specified in Element.
     */
    public init<S: Sequence>(elements: S, precision: Precision = defaultPrecision, coordinateReferenceSystem: CoordinateReferenceSystem = defaultCoordinateReferenceSystem) where S.Iterator.Element == CoordinateType {

        self.init(precision: precision, coordinateReferenceSystem: coordinateReferenceSystem)

        var Iterator = elements.makeIterator()

        while let coordinate = Iterator.next() {
            self.append(coordinate)
        }
    }

    /**
        LineString can be constructed from any Swift.Collection including Array as
        long as it has an Element type equal the Coordinate type specified in Element
        and the Distance is an Int type.
     */
    public init<C: Swift.Collection>(elements: C, precision: Precision = defaultPrecision, coordinateReferenceSystem: CoordinateReferenceSystem = defaultCoordinateReferenceSystem) where C.Iterator.Element == CoordinateType {

        self.init(precision: precision, coordinateReferenceSystem: coordinateReferenceSystem)

        self.reserveCapacity(numericCast(elements.count))

        var Iterator = elements.makeIterator()

        while let coordinate = Iterator.next() {
            self.append(coordinate)
        }
    }

    /**
        - Returns: The number of Coordinate3D objects.
     */
    public var count: Int {
        get { return self.storage.header }
    }

    /**
        - Returns: The current minimum capacity.
     */
    public var capacity: Int {
        get { return self.storage.capacity }
    }

    /**
        Reserve enough space to store `minimumCapacity` elements.

        - Postcondition: `capacity >= minimumCapacity` and the array has mutable contiguous storage.
     */
    public mutating func reserveCapacity(_ minimumCapacity: Int) {

        if storage.capacity < minimumCapacity {

            _ensureUniquelyReferenced()

            let newSize = Math.max(storage.capacity * 2, minimumCapacity)

            storage = storage.resize(newSize)
        }
    }

    /**
        Reserve enough space to store `minimumCapacity` elements.

        - Postcondition: `capacity >= minimumCapacity` and the array has mutable contiguous storage.
     */
    public mutating func append(_ newElement: CoordinateType) {

        _ensureUniquelyReferenced()
        _resizeIfNeeded()

        let convertedCoordinate = CoordinateType(other: newElement, precision: precision)

        storage.withUnsafeMutablePointers { (value, elements) -> Void in

            (elements + value.pointee).initialize(to: convertedCoordinate)
            value.pointee = value.pointee &+ 1
        }
    }

    /**
        Append the elements of `newElements` to this LineString.
     */
    public mutating func append<S: Sequence>(contentsOf newElements: S) where S.Iterator.Element == CoordinateType {

        var Iterator = newElements.makeIterator()

        while let coordinate = Iterator.next() {
            self.append(coordinate)
        }
    }

    /**
        Append the elements of `newElements` to this LineString.
     */
    public mutating func append<C: Swift.Collection>(contentsOf newElements: C) where C.Iterator.Element == CoordinateType {

        self.reserveCapacity(numericCast(newElements.count))

        var Iterator = newElements.makeIterator()

        while let coordinate = Iterator.next() {
            self.append(coordinate)
        }
    }

    /**
        Insert `newElement` at index `i` of this LineString.

        - Requires: `i <= count`.
     */
    public mutating func insert(_ newElement: CoordinateType, atIndex index: Int) {
        guard (index >= 0) && (index < storage.header) else { preconditionFailure("Index out of range.") }

        _ensureUniquelyReferenced()
        _resizeIfNeeded()

        let convertedCoordinate = CoordinateType(other: newElement, precision: precision)

        storage.withUnsafeMutablePointers { (count, elements) -> Void in
            var m = count.pointee

            count.pointee = count.pointee &+ 1

            // Move the other elements
            while  m >= index {
                (elements + (m &+ 1)).moveInitialize(from: (elements + m), count: 1)
                m = m &- 1
            }
            (elements + index).initialize(to: convertedCoordinate)
        }
    }

    /**
        Remove and return the element at index `i` of this LineString.
     */
    @discardableResult
    public mutating func remove(at index: Int) -> CoordinateType {
        guard (index >= 0) && (index < storage.header) else { preconditionFailure("Index out of range.") }

        return storage.withUnsafeMutablePointers { (count, elements) -> CoordinateType in

            let result = (elements + index).move()

            var m = index

            // Move the other elements
            while  m <  count.pointee {
                (elements + m).moveInitialize(from: (elements + (m &+ 1)), count: 1)
                m = m &+ 1
            }
            count.pointee = count.pointee &- 1

            return result
        }
    }

    /**
        Remove an element from the end of this LineString.

        - Requires: `count > 0`.
     */
    @discardableResult
    public mutating func removeLast() -> CoordinateType {
        guard storage.header > 0 else { preconditionFailure("can't removeLast from an empty LineString.") }

        return storage.withUnsafeMutablePointers { (count, elements) -> CoordinateType in

            // No need to check for overflow in `count.pointee - 1` because `i` is known to be positive.
            count.pointee = count.pointee &- 1
            return (elements + count.pointee).move()
        }
    }

    /**
        Remove all elements of this LineString.

        - Postcondition: `capacity == 0` iff `keepCapacity` is `false`.
     */
    public mutating func removeAll(_ keepCapacity: Bool = false) {

        if keepCapacity {

            storage.withUnsafeMutablePointers { (count, elements) -> Void in
                count.pointee = 0
            }
        } else {
            storage = CollectionBuffer<CoordinateType>.create(minimumCapacity: 0) { _ in 0 } as! CollectionBuffer<CoordinateType> // swiftlint:disable:this force_cast
        }
    }
}

/**
    TupleConvertable extensions

    Coordinates that are TupleConvertable allow initialization via an ordinary Swift tuple.
 */
extension LineString where CoordinateType: TupleConvertable & CopyConstructable {

    /**
        LineString can be constructed from any Sequence if it's Elements are tuples that match
        Self.Element's TupleType.

        ----

        - seealso: TupleConvertable.
     */
    public init<S: Sequence>(elements: S, precision: Precision = defaultPrecision, coordinateReferenceSystem: CoordinateReferenceSystem = defaultCoordinateReferenceSystem) where S.Iterator.Element == CoordinateType.TupleType {

        self.init(precision: precision, coordinateReferenceSystem: coordinateReferenceSystem)

        var Iterator = elements.makeIterator()

        while let coordinate = Iterator.next() {
            self.append(coordinate)
        }
    }

    /**
        LineString can be constructed from any Swift.Collection if it's Elements are tuples that match
        Self.Element's TupleType.

        ----

        - seealso: TupleConvertable.
     */
    public init<C: Swift.Collection>(elements: C, precision: Precision = defaultPrecision, coordinateReferenceSystem: CoordinateReferenceSystem = defaultCoordinateReferenceSystem) where C.Iterator.Element == CoordinateType.TupleType {

        self.init(precision: precision, coordinateReferenceSystem: coordinateReferenceSystem)

        self.reserveCapacity(numericCast(elements.count))

        var Iterator = elements.makeIterator()

        while let coordinate = Iterator.next() {
            self.append(coordinate)
        }
    }

    /**
        Reserve enough space to store `minimumCapacity` elements.

        - Postcondition: `capacity >= minimumCapacity` and the array has mutable contiguous storage.
     */
    public mutating func append(_ newElement: CoordinateType.TupleType) {
        self.append(CoordinateType(tuple: newElement))
    }

    /**
        Append the elements of `newElements` to this LineString.
     */
    public mutating func append<S: Sequence>(contentsOf newElements: S) where S.Iterator.Element == CoordinateType.TupleType {

        var Iterator = newElements.makeIterator()

        while let coordinate = Iterator.next() {
            self.append(CoordinateType(tuple: coordinate))
        }
    }

    /**
        Append the elements of `newElements` to this LineString.
     */
    public mutating func append<C: Swift.Collection>(contentsOf newElements: C) where C.Iterator.Element == CoordinateType.TupleType {

        _ensureUniquelyReferenced()

        self.reserveCapacity(numericCast(newElements.count) + storage.header)

        var Iterator = newElements.makeIterator()

        while let coordinate = Iterator.next() {
            self.append(CoordinateType(tuple: coordinate))
        }
    }

    /**
        Insert `newElement` at index `i` of this LineString.

        - Requires: `i <= count`.
     */
    public mutating func insert(_ newElement: CoordinateType.TupleType, atIndex i: Int) {
        self.insert(CoordinateType(tuple: newElement), atIndex: i)
    }
}

// MARK: Swift.Collection conformance

extension LineString: Swift.Collection, MutableCollection, _DestructorSafeContainer {

    /**
        Returns the position immediately after `i`.

        - Precondition: `(startIndex..<endIndex).contains(i)`
     */
    public func index(after i: Int) -> Int {
        return i+1
    }

    /**
        Always zero, which is the index of the first element when non-empty.
     */
    public var startIndex: Int {
        return 0
    }

    /**
        A "past-the-end" element index; the successor of the last valid subscript argument.
     */
    public var endIndex: Int {
        return storage.header
    }

    public subscript(index: Int) -> CoordinateType {

        get {
            guard (index >= 0) && (index < storage.header) else { preconditionFailure("Index out of range.") }

            return storage.withUnsafeMutablePointerToElements { $0[index] }
        }

        set (newValue) {
            guard (index >= 0) && (index < storage.header) else { preconditionFailure("Index out of range.") }

            _ensureUniquelyReferenced()

            let convertedCoordinate = CoordinateType(other: newValue, precision: precision)

            storage.withUnsafeMutablePointerToElements { elements -> Void in

                (elements + index).deinitialize()
                (elements + index).initialize(to: convertedCoordinate)
            }
        }
    }
}

// MARK: CustomStringConvertible & CustomDebugStringConvertible Conformance

extension LineString: CustomStringConvertible, CustomDebugStringConvertible {

    public var description: String {
        return "\(type(of: self))(\(self.flatMap { String(describing: $0) }.joined(separator: ", ")))"
    }

    public var debugDescription: String {
        return self.description
    }
}

// MARK: Equatable Conformance

extension LineString: Equatable {}

public func == <CoordinateType: Coordinate & CopyConstructable>(lhs: LineString<CoordinateType>, rhs: LineString<CoordinateType>) -> Bool {
    return lhs.equals(rhs)
}
