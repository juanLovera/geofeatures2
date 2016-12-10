///
///  MultiPolygonTests.swift
///
///  Copyright (c) 2016 Tony Stone
///
///  Licensed under the Apache License, Version 2.0 (the "License");
///  you may not use this file except in compliance with the License.
///  You may obtain a copy of the License at
///
///  http://www.apache.org/licenses/LICENSE-2.0
///
///  Unless required by applicable law or agreed to in writing, software
///  distributed under the License is distributed on an "AS IS" BASIS,
///  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
///  See the License for the specific language governing permissions and
///  limitations under the License.
///
///  Created by Tony Stone on 3/6/2016.
///
import XCTest
import GeoFeatures

#if (os(OSX) || os(iOS) || os(tvOS) || os(watchOS)) && SWIFT_PACKAGE
    /// TODO: Remove this after figuring out why there seems to be a symbol conflict (error: cannot specialize a non-generic definition) with another Polygon on Swift PM on Apple platforms only.
    import struct GeoFeatures.Polygon
#endif

///
/// NOTE: This file was auto generated by gyb from file GeometryCollectionTests.swift.gyb using the following command.
///
/// ../bin/gyb --line-directive '' -DTestInput='MultiPolygonTestInput' -o MultiPolygonTests.swift GeometryCollectionTests.swift.gyb
///
/// Do NOT edit this file directly as it will be regenerated automatically when needed.
///
// MARK: - Coordinate2D, FloatingPrecision, Cartesian -

class MultiPolygonCoordinate2DFloatingPrecisionCartesianTests: XCTestCase {

    let precision = FloatingPrecision()
    let cs        = Cartesian()

    // MARK: Construction

    func testInitWithNoArg() {
        let input = MultiPolygon<Coordinate2D>()

        XCTAssertTrue(input.isEmpty())
    }

    func testInitWithNoArgAndDefaults() {
        let input    = MultiPolygon<Coordinate2D>()

        // FIXME: Currently Precision and CoordinateSystem can not be Equitable and be used for anything other than Generic constraints because it's a protocol, this limits testing of the defaultPrecision and defaultCoordinateSystem
        // XCTAssertEqual(input.precision as? FloatingPrecision, GeoFeatures.defaultPrecision)
        XCTAssertEqual(input.coordinateSystem as? Cartesian, GeoFeatures.defaultCoordinateSystem)
    }

    func testInitWithPrecisionAndCRS() {
        let input = MultiPolygon<Coordinate2D>(precision: precision, coordinateSystem: cs)

        XCTAssertEqual(input.precision as? FloatingPrecision, precision)
        XCTAssertEqual(input.coordinateSystem as? Cartesian, cs)
    }

    func testInitWithPrecision() {
        let input    = MultiPolygon<Coordinate2D>(precision: precision)
        let expected = precision

        XCTAssertEqual(input.precision as? FloatingPrecision, expected)
    }

    func testInitWithCRS() {
        let input = MultiPolygon<Coordinate2D>(coordinateSystem: cs)
        let expected = cs

        XCTAssertEqual(input.coordinateSystem as? Cartesian, expected)
    }

    func testInitWithTuple() {

        let input = MultiPolygon<Coordinate2D>(elements: [Polygon<Coordinate2D>(rings: ([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], [])), Polygon<Coordinate2D>(rings: ([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], []))], precision: precision, coordinateSystem: cs)
        let expected = [Polygon<Coordinate2D>(rings: ([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], [])), Polygon<Coordinate2D>(rings: ([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], []))]

        XCTAssertTrue(
            (input.elementsEqual(expected) { (lhs: MultiPolygon.Element, rhs: MultiPolygon.Element) -> Bool in
                    return lhs == rhs
            }
        ), "\(input) is not equal to \(expected)")
    }

    // MARK: CustomStringConvertible & CustomDebugStringConvertible

    func testDescription() {

        let input    = MultiPolygon<Coordinate2D>(elements: [Polygon<Coordinate2D>(rings: ([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], [])), Polygon<Coordinate2D>(rings: ([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], []))], precision: precision, coordinateSystem: cs)
        let expected = "MultiPolygon<Coordinate2D>(Polygon<Coordinate2D>([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], []), Polygon<Coordinate2D>([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], []))"

        XCTAssertEqual(input.description, expected)
    }

    func testDebugDescription() {

        let input    = MultiPolygon<Coordinate2D>(elements: [Polygon<Coordinate2D>(rings: ([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], [])), Polygon<Coordinate2D>(rings: ([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], []))], precision: precision, coordinateSystem: cs)
        let expected = "MultiPolygon<Coordinate2D>(Polygon<Coordinate2D>([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], []), Polygon<Coordinate2D>([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], []))"

        XCTAssertEqual(input.debugDescription, expected)
    }

    // MARK: Collection conformance

    func testReserveCapacity() {

        var input = MultiPolygon<Coordinate2D>(precision: precision, coordinateSystem: cs)
        let expected = input.capacity * 2

        input.reserveCapacity(expected)

        XCTAssertEqual(input.capacity, expected)
    }

    func testAppend() {

        var input    = MultiPolygon<Coordinate2D>(precision: precision, coordinateSystem: cs)
        let expected = [Polygon<Coordinate2D>(rings: ([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], []))]

        input.append(Polygon<Coordinate2D>(rings: ([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], [])))

        XCTAssertTrue(input.elementsEqual(expected) { (lhs: MultiPolygon.Element, rhs: MultiPolygon.Element) -> Bool in
                return lhs == rhs
        }, "\(input) is not equal to \(expected)")
    }

    func testAppendContentsOf() {

        let input1 = MultiPolygon<Coordinate2D>(elements: [Polygon<Coordinate2D>(rings: ([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], [])), Polygon<Coordinate2D>(rings: ([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], []))], precision: precision, coordinateSystem: cs)
        var input2 = MultiPolygon<Coordinate2D>(precision: precision, coordinateSystem: cs)

        input2.append(contentsOf: input1)

        XCTAssertEqual(input1, input2)
    }

    func testInsert2ExistingElements() {

        var input = MultiPolygon<Coordinate2D>(elements: [Polygon<Coordinate2D>(rings: ([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], [])), Polygon<Coordinate2D>(rings: ([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], []))], precision: precision, coordinateSystem: cs)
        let expected = [Polygon<Coordinate2D>(rings: ([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], [])), Polygon<Coordinate2D>(rings: ([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], [])), Polygon<Coordinate2D>(rings: ([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], []))]

        input.insert(Polygon<Coordinate2D>(rings: ([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], [])), at: 0)

        XCTAssertTrue(input.elementsEqual(expected) { (lhs: MultiPolygon.Element, rhs: MultiPolygon.Element) -> Bool in
                return lhs == rhs
            }, "\(input) is not equal to \(expected)")
    }

    func testInsert1ExistingElements() {

        var input = MultiPolygon<Coordinate2D>(elements: [Polygon<Coordinate2D>(rings: ([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], []))], precision: precision, coordinateSystem: cs)
        let expected = [Polygon<Coordinate2D>(rings: ([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], [])), Polygon<Coordinate2D>(rings: ([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], []))]

        input.insert(Polygon<Coordinate2D>(rings: ([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], [])), at: 0)

        XCTAssertTrue(input.elementsEqual(expected) { (lhs: MultiPolygon.Element, rhs: MultiPolygon.Element) -> Bool in
                return lhs == rhs
            }, "\(input) is not equal to \(expected)")
    }

    func testRemove() {

        var input =  MultiPolygon<Coordinate2D>(elements: [Polygon<Coordinate2D>(rings: ([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], [])), Polygon<Coordinate2D>(rings: ([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], []))], precision: precision, coordinateSystem: cs)
        let expected = MultiPolygon<Coordinate2D>(elements: [Polygon<Coordinate2D>(rings: ([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], []))], precision: precision, coordinateSystem: cs)

        let _ = input.remove(at: 0)

        XCTAssertEqual(input, expected)
    }

    func testRemoveLast() {

        var input =  MultiPolygon<Coordinate2D>(elements: [Polygon<Coordinate2D>(rings: ([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], [])), Polygon<Coordinate2D>(rings: ([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], []))], precision: precision, coordinateSystem: cs)
        let expected = MultiPolygon<Coordinate2D>(elements: [Polygon<Coordinate2D>(rings: ([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], []))], precision: precision, coordinateSystem: cs)

        let _ = input.removeLast()

        XCTAssertEqual(input, expected)
    }

    func testRemoveAll() {

        var input =  MultiPolygon<Coordinate2D>(elements: [Polygon<Coordinate2D>(rings: ([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], [])), Polygon<Coordinate2D>(rings: ([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], []))], precision: precision, coordinateSystem: cs)
        let expected =  MultiPolygon<Coordinate2D>(precision: precision, coordinateSystem: cs)

        input.removeAll()

        XCTAssertEqual(input, expected)
    }

    func testRemoveAllKeepCapacity() {

        var input =  MultiPolygon<Coordinate2D>(elements: [Polygon<Coordinate2D>(rings: ([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], [])), Polygon<Coordinate2D>(rings: ([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], []))], precision: precision, coordinateSystem: cs)
        let expected = input.capacity

        input.removeAll(keepingCapacity: true)

        XCTAssertEqual(input.capacity, expected)
    }

    // MARK: Swift.Collection Conformance

    func testSubscriptGet() {

        let input    = MultiPolygon<Coordinate2D>(elements: [Polygon<Coordinate2D>(rings: ([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], [])), Polygon<Coordinate2D>(rings: ([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], []))], precision: precision, coordinateSystem: cs)
        let expected = Polygon<Coordinate2D>(rings: ([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], []))

        XCTAssertTrue(input[1].equals(expected))
    }

    func testSubscriptSet() {

        var input    = MultiPolygon<Coordinate2D>(elements: [Polygon<Coordinate2D>(rings: ([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], [])), Polygon<Coordinate2D>(rings: ([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], []))], precision: precision, coordinateSystem: cs)
        let expected = MultiPolygon<Coordinate2D>(elements: [Polygon<Coordinate2D>(rings: ([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], [])), Polygon<Coordinate2D>(rings: ([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], []))], precision: precision, coordinateSystem: cs)

        input[1] = Polygon<Coordinate2D>(rings: ([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], []))

        XCTAssertEqual(input, expected)
    }

    func testEquals() {

        let input    = MultiPolygon<Coordinate2D>(elements: [Polygon<Coordinate2D>(rings: ([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], [])), Polygon<Coordinate2D>(rings: ([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], []))], precision: precision, coordinateSystem: cs)
        let expected = MultiPolygon<Coordinate2D>(elements: [Polygon<Coordinate2D>(rings: ([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], [])), Polygon<Coordinate2D>(rings: ([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], []))], precision: precision, coordinateSystem: cs)

        XCTAssertEqual(input, expected)
    }

    func testIsEmpty() {

        let input = MultiPolygon<Coordinate2D>(precision: precision, coordinateSystem: cs)
        let expected = true

        XCTAssertEqual(input.isEmpty(), expected)
    }

    func testIsEmptyFalse() {

        let input    = MultiPolygon<Coordinate2D>(elements: [Polygon<Coordinate2D>(rings: ([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], [])), Polygon<Coordinate2D>(rings: ([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], []))], precision: precision, coordinateSystem: cs)
        let expected = false

        XCTAssertEqual(input.isEmpty(), expected)
    }

    func testCount() {

        let input    = MultiPolygon<Coordinate2D>(elements: [Polygon<Coordinate2D>(rings: ([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], [])), Polygon<Coordinate2D>(rings: ([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], []))], precision: precision, coordinateSystem: cs)
        let expected = 2

        XCTAssertEqual(input.count, expected)
    }

    // MARK: Misc Internal

    func testEnsureUniquelyReferenced() {

        var input = MultiPolygon<Coordinate2D>(precision: precision, coordinateSystem: cs)
        let expected = input.capacity * 2

        let copy = input    // This should force the reserveCapacity to clone
        let _ = copy.capacity

        input.reserveCapacity(expected)

        XCTAssertEqual(input.capacity, expected)
    }

    func testResizeIfNeeded() {

        var input = MultiPolygon<Coordinate2D>(precision: precision, coordinateSystem: cs)
        let expected = input.capacity * 2

        // Force it beyond its initial capacity
        for _ in 0..<input.capacity + 1 {
            input.append(Polygon<Coordinate2D>(rings: ([(x: 6.0, y: 1.0), (x: 1.0, y: 1.0), (x: 1.0, y: 3.0), (x: 3.5, y: 4.0), (x: 6.0, y: 3.0)], [])))
        }
        XCTAssertEqual(input.capacity, expected)
    }
}
