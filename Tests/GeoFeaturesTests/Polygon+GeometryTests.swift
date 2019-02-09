///
///  Polygon+GeometryTests.swift
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
///  Created by Tony Stone on 4/24/2016.
///
import XCTest
import GeoFeatures

#if (os(OSX) || os(iOS) || os(tvOS) || os(watchOS)) && SWIFT_PACKAGE
    /// Note: Resolution of GeoFeatures.Polygon is ambiguous when ApplicationsServices is included in the app (ApplicationsServices is used by XCTest), this resolves the ambiguity.
    import struct GeoFeatures.Polygon
#endif

// MARK: - Coordinate2D, FloatingPrecision, Cartesian -

class PolygonGeometryCoordinate2DFloatingPrecisionCartesianTests: XCTestCase {

    let precision = Floating()
    let cs       = Cartesian()

    // MARK: - Dimension

    func testDimension () {
        XCTAssertEqual(Polygon([[[6.0, 1.0], [1.0, 1.0], [1.0, 3.0], [3.5, 4.0], [6.0, 3.0]]], precision: precision, coordinateSystem: cs).dimension, .two)
    }

    func testDimensionEmpty () {
        XCTAssertEqual(Polygon(precision: precision, coordinateSystem: cs).dimension, .empty)
    }

    // MARK: - Boundary

    func testBoundaryWithOuterRing() {
        let input = Polygon([[6.0, 1.0], [1.0, 1.0], [1.0, 3.0], [3.5, 4.0], [6.0, 3.0]], innerRings: [], precision: precision, coordinateSystem: cs).boundary()
        let expected = MultiLineString([LineString([[6.0, 1.0], [1.0, 1.0], [1.0, 3.0], [3.5, 4.0], [6.0, 3.0]])], precision: precision, coordinateSystem: cs)

        XCTAssertTrue(input == expected, "\(input) is not equal to \(expected)")
    }

    func testBoundaryWithOuterRingAnd1InnerRing() {
        let input = Polygon([[6.0, 1.0], [1.0, 1.0], [1.0, 3.0], [3.5, 4.0], [6.0, 3.0]], innerRings: [[[5.0, 2.0], [2.0, 2.0], [2.0, 3.0], [3.5, 3.5], [5.0, 3.0]]], precision: precision, coordinateSystem: cs).boundary()
        let expected = MultiLineString([LineString([[6.0, 1.0], [1.0, 1.0], [1.0, 3.0], [3.5, 4.0], [6.0, 3.0]]), LineString([[5.0, 2.0], [2.0, 2.0], [2.0, 3.0], [3.5, 3.5], [5.0, 3.0]])], precision: precision, coordinateSystem: cs)

        XCTAssertTrue(input == expected, "\(input) is not equal to \(expected)")
    }

    func testBoundaryEmpty() {
        let input = Polygon(precision: precision, coordinateSystem: cs).boundary()
        let expected = MultiLineString(precision: precision, coordinateSystem: cs)

        XCTAssertTrue(input == expected, "\(input) is not equal to \(expected)")
    }

    // MARK: - Bounds

    func testBoundsEmpty() {
        let input = Polygon(precision: precision, coordinateSystem: cs)
        let expected: Bounds? = nil

        XCTAssertEqual(input.bounds(), expected)
    }

    func testBounds() {
        let input = Polygon([[6.0, 1.0], [1.0, 1.0], [1.0, 3.0], [3.5, 4.0], [6.0, 3.0]], innerRings: [], precision: precision, coordinateSystem: cs)
        let expected = Bounds(min: (x: 1.0, y: 1.0), max: (x: 6.0, y: 4.0))

        XCTAssertEqual(input.bounds(), expected)
    }

    // MARK: - Equal

    func testEqualTrue() {
        let input1 = Polygon([[6.0, 1.0], [1.0, 1.0], [1.0, 3.0], [3.5, 4.0], [6.0, 3.0]], innerRings: [[[5.0, 2.0], [2.0, 2.0], [2.0, 3.0], [3.5, 3.5], [5.0, 3.0]]], precision: precision, coordinateSystem: cs)
        let input2 = Polygon([[6.0, 1.0], [1.0, 1.0], [1.0, 3.0], [3.5, 4.0], [6.0, 3.0]], innerRings: [[[5.0, 2.0], [2.0, 2.0], [2.0, 3.0], [3.5, 3.5], [5.0, 3.0]]], precision: precision, coordinateSystem: cs)

        XCTAssertEqual(input1, input2)
     }

     func testEqualFalse() {
        let input1            = Polygon([[6.0, 1.0], [1.0, 1.0], [1.0, 3.0], [3.5, 4.0], [6.0, 3.0]], innerRings: [[[5.0, 2.0], [2.0, 2.0], [2.0, 3.0], [3.5, 3.5], [5.0, 3.0]]], precision: precision, coordinateSystem: cs)
        let input2: Geometry  = Point([1.0, 1.0], precision: precision, coordinateSystem: cs)

        XCTAssertFalse(input1.equals(input2), "\(input1) is not equal to \(input2)")
     }

    // MARK: - Simplify

    func testPolygonSimplify_empty() {
        let polygon = Polygon()
        let polygonResult = polygon.simplify(tolerance: 1.0)

        XCTAssert(polygonResult.count == 0)
    }

    func testPolygonSimplify_singlePoint() {
        let polygon = Polygon([[1.0, 1.0]], innerRings: [])
        let polygonResult = polygon.simplify(tolerance: 1.0)

        XCTAssert(polygonResult.count == 1)
        XCTAssert(polygonResult[0].count == 1)
    }

    func testPolygonSimplify_square() {
        let polygon = Polygon([[1.0, 1.0], [1.0, 5.0], [5.0, 5.0], [5.0, 5.0], [5.0, 1.0], [5.0, 1.0], [1.0, 1.0], [1.0, 5.0], [1.0, 1.0]], innerRings: [])
        let polygonResult = polygon.simplify(tolerance: 1.0)

        XCTAssert(polygonResult.count == 1)
        XCTAssert(polygonResult[0].count == 7)
    }

    func testPolygonSimplify_squareWithHole() {
        let polygon = Polygon([[1.0, 1.0], [1.0, 5.0], [5.0, 5.0], [5.0, 5.0], [5.0, 1.0], [5.0, 1.0], [1.0, 1.0], [1.0, 5.0], [1.0, 1.0]], innerRings: [[[4.0, 2.0], [4.0, 4.0], [4.0, 4.0], [2.0, 4.0], [3.5, 3.5], [4.0, 2.0], [4.0, 2.0]]])
        let polygonResult = polygon.simplify(tolerance: 1.0)

        XCTAssert(polygonResult.count == 2)
        XCTAssert(polygonResult[0].count == 7)
        XCTAssert(polygonResult[1].count == 5)
    }

    func testPolygonSimplify_polygonWithMultipleHoles() {
        let polygon = Polygon([[0.0, 0.0], [-10.0, 10.0], [-10.0, 10.0], [-10.0, 10.0], [0.0, 20.0], [10.0, 20.0], [20.0, 10.0], [10.0, 0.0], [0.0, 0.0]],
                              innerRings: [[[1.0, 1.0], [2.0, 1.0], [2.0, 2.0], [1.0, 2.0], [1.0, 1.0], [1.0, 1.0], [2.0, 1.0], [2.0, 2.0], [1.0, 2.0], [1.0, 1.0], [1.0, 1.0], [2.0, 1.0], [2.0, 2.0], [1.0, 2.0], [1.0, 1.0]],
                                           [[8.0, 2.0], [8.0, 1.0], [9.0, 1.0], [9.0, 1.0], [9.0, 1.0], [9.0, 1.0], [9.0, 2.0], [8.0, 2.0]],
                                           [[5.0, 19.0], [3.0, 17.0], [5.0, 15.0], [7.0, 17.0], [5.0, 19.0], [5.0, 19.0], [3.0, 17.0], [5.0, 15.0], [7.0, 17.0], [5.0, 19.0]]])
        let polygonResult = polygon.simplify(tolerance: 1.0)

        XCTAssert(polygonResult.count == 4)
        XCTAssert(polygonResult[0].count == 7)
        XCTAssert(polygonResult[1].count == 5)
        XCTAssert(polygonResult[2].count == 5)
        XCTAssert(polygonResult[3].count == 5)
    }
}

