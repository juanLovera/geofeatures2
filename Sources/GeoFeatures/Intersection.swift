//
//  Intersection.swift
//  GeoFeatures
//
//  Created by Ed Swiss Default on 10/29/18.
//

import Foundation

enum Subset: Int {
    case
    overlap = 0,            /// Indicates some parts of each geometry intersect the other and are outside the other
    firstInSecondInterior,  /// Indicates the first geometry is completely contained within the second geometry
    secondInFirstInterior,  /// Indicates the second geometry is completely contained within the first geometry
    identical,              /// Indicates the geometries are the same
    firstInSecondBoundary,  /// Indicates the first geometry exists
    secondInFirstBoundary
}

/// Describes the relationship between the first and second geometries
struct RelatedTo {

    var firstInteriorTouchesSecondBoundary: Dimension           = .empty
    var firstBoundaryTouchesSecondBoundary: Dimension           = .empty
    var firstExteriorTouchesSecondBoundary: Dimension           = .empty
    var firstTouchesSecondBoundary: Dimension {
        var tempDimension: Dimension = .empty
        if firstInteriorTouchesSecondBoundary > tempDimension {
            tempDimension = firstInteriorTouchesSecondBoundary
        }
        if firstBoundaryTouchesSecondBoundary > tempDimension {
            tempDimension = firstBoundaryTouchesSecondBoundary
        }
        return tempDimension
    }

    var firstInteriorTouchesSecondInterior: Dimension   = .empty
    var firstBoundaryTouchesSecondInterior: Dimension   = .empty
    var firstExteriorTouchesSecondInterior: Dimension   = .empty
    var firstTouchesSecondInterior: Dimension {
        var tempDimension: Dimension = .empty
        if firstInteriorTouchesSecondInterior > tempDimension {
            tempDimension = firstInteriorTouchesSecondInterior
        }
        if firstBoundaryTouchesSecondInterior > tempDimension {
            tempDimension = firstBoundaryTouchesSecondInterior
        }
        return tempDimension
    }
    var firstTouchesSecondInteriorOnly: Bool {
        return firstTouchesSecondInterior > .empty && firstTouchesSecondBoundary == .empty && firstTouchesSecondExterior == .empty
    }
    var firstTouchesSecondInteriorOrBoundaryOnly: Bool {
        return (firstTouchesSecondInterior > .empty || firstTouchesSecondBoundary > .empty) && firstTouchesSecondExterior == .empty
    }

    var firstInteriorTouchesSecondExterior: Dimension   = .empty
    var firstBoundaryTouchesSecondExterior: Dimension   = .empty
    var firstExteriorTouchesSecondExterior: Dimension   = .two
    var firstTouchesSecondExterior: Dimension {
        var tempDimension: Dimension = .empty
        if firstInteriorTouchesSecondExterior > tempDimension {
            tempDimension = firstInteriorTouchesSecondExterior
        }
        if firstBoundaryTouchesSecondExterior > tempDimension {
            tempDimension = firstBoundaryTouchesSecondExterior
        }
        return tempDimension
    }
    var firstTouchesSecondExteriorOnly: Bool {
        return firstTouchesSecondExterior > .empty && firstTouchesSecondBoundary == .empty && firstTouchesSecondInterior == .empty
    }
}

/// Describes the relationship between two Segments
///
/// This was developed to help to determine the intersection between a LineString and a Polygon.
/// In particular, it will be used to determine the overlap of a Segment with segments in a LinearRing,
/// whether it is the main LinearRing of the Polygon or a hole.
///
/// - parameters:
///     - segmentNumber: The segment number of the LinearRing, base 0.
///     - hole: Is the LinearRing a hole in the Polygon or the main outer ring?
///     - firstSubsetOfSecond: Is the first Segment a subset of the second Segment?
///     - secondSubsetOfFirst: Is the second Segment a subset of the first Segment?
///     - point: A single point at which the two segments touch.
///     - segment: The Segment at which the two segments overlap.
///
struct SegmentOverlap {

    var segmentNumber: Int = 0
    var hole: Bool
    var firstSubsetOfSecond: Bool
    var secondSubsetOfFirst: Bool
    var point: Point?
    var segment: Segment?
}

func intersection(_ geometry1: Geometry, _ geometry2: Geometry) -> Geometry {

    let resultIntersectionGeometry = intersectionGeometry(geometry1, geometry2)

    return resultIntersectionGeometry
}

/// Returns the intersection geometry.
/// Note that in general the intersection of two geometries will result in a collection of geometries, not just one.
fileprivate func intersectionGeometry(_ geometry1: Geometry, _ geometry2: Geometry) -> Geometry {

    switch geometry1.dimension {

    /// The interior of a geometry of dimension zero is the geometry itself.
    case .zero:

        switch geometry2.dimension {

        case .zero:
            return intersectionZeroZero(geometry1, geometry2)
        case .one:
            return intersectionZeroOne(geometry1, geometry2)
        case .two:
            return intersectionZeroTwo(geometry1, geometry2)
        default: break
        }

    case .one:
        /// TODO
        switch geometry2.dimension {
        case .zero:
            return intersectionOneZero(geometry1, geometry2)
        case .one:
            return intersectionOneOne(geometry1, geometry2)
        case .two:
            return intersectionOneTwo(geometry1, geometry2)
        default: break
        }

    case .two:
        /// TODO
        switch geometry2.dimension {
        case .zero:
            return intersectionTwoZero(geometry1, geometry2)
        case .one:
            return intersectionTwoOne(geometry1, geometry2)
        case .two:
            return intersectionTwoTwo(geometry1, geometry2)
        default: break
        }

    default: break
    }

    return GeometryCollection()
}

/// For the intersection of two geometries of dimension .zero
fileprivate func intersectionZeroZero(_ geometry1: Geometry, _ geometry2: Geometry) -> Geometry {

    if let point1 = geometry1 as? Point, let point2 = geometry2 as? Point {
        return generateIntersection(point1, point2)
    } else if let point = geometry1 as? Point, let points = geometry2 as? MultiPoint {
        return generateIntersection(point, points)
    } else if let points = geometry1 as? MultiPoint, let point = geometry2 as? Point {
        return generateIntersection(point, points)
    } else if let points1 = geometry1 as? MultiPoint, let points2 = geometry2 as? MultiPoint {
        return generateIntersection(points1, points2)
    }
    return GeometryCollection()
}

/// For the intersection of two geometries of dimension .zero and .one, respectively.
fileprivate func intersectionZeroOne(_ geometry1: Geometry, _ geometry2: Geometry) -> Geometry {

    if let point = geometry1 as? Point, let lineString = geometry2 as? LineString {
        return generateIntersection(point, lineString)
    } else if let points = geometry1 as? MultiPoint, let lineString = geometry2 as? LineString {
        return generateIntersection(points, lineString)
    } else if let point = geometry1 as? Point, let multilineString = geometry2 as? MultiLineString {
        return generateIntersection(point, multilineString)
    } else if let points = geometry1 as? MultiPoint, let multilineString = geometry2 as? MultiLineString {
        return generateIntersection(points, multilineString)
    } else if let point = geometry1 as? Point, let linearRing = geometry2 as? LinearRing {
        return generateIntersection(point, linearRing)
    } else if let points = geometry1 as? MultiPoint, let linearRing = geometry2 as? LinearRing {
        return generateIntersection(points, linearRing)
    }
    return GeometryCollection()
}

/// For the intersection of two geometries of dimension .zero and .two, respectively.
fileprivate func intersectionZeroTwo(_ geometry1: Geometry, _ geometry2: Geometry) -> Geometry {

    if let point = geometry1 as? Point, let polygon = geometry2 as? Polygon {
        return generateIntersection(point, polygon)
    } else if let points = geometry1 as? MultiPoint, let polygon = geometry2 as? Polygon {
        return generateIntersection(points, polygon)
    } else if let point = geometry1 as? Point, let multipolygon = geometry2 as? MultiPolygon {
        return generateIntersection(point, multipolygon)
    } else if let points = geometry1 as? MultiPoint, let multipolygon = geometry2 as? MultiPolygon {
        return generateIntersection(points, multipolygon)
    }
    return GeometryCollection()
}

/// For the intersection of two geometries of dimension .one and .zero, respectively.
fileprivate func intersectionOneZero(_ geometry1: Geometry, _ geometry2: Geometry) -> Geometry {

    if let lineString = geometry1 as? LineString, let point = geometry2 as? Point {
        return generateIntersection(point, lineString)
    } else if let lineString = geometry1 as? LineString, let points = geometry2 as? MultiPoint {
        return generateIntersection(points, lineString)
    } else if let multilineString = geometry1 as? MultiLineString, let point = geometry2 as? Point {
        return generateIntersection(point, multilineString)
    } else if let multilineString = geometry1 as? MultiLineString, let points = geometry2 as? MultiPoint {
        return generateIntersection(points, multilineString)
    } else if let linearRing = geometry1 as? LinearRing, let point = geometry2 as? Point {
        return generateIntersection(point, linearRing)
    } else if let linearRing = geometry1 as? LinearRing, let points = geometry2 as? MultiPoint {
        return generateIntersection(points, linearRing)
    }
    return GeometryCollection()
}

/// For the intersection of two geometries of dimension .one.
fileprivate func intersectionOneOne(_ geometry1: Geometry, _ geometry2: Geometry) -> Geometry {

    if let lineString1 = geometry1 as? LineString, let lineString2 = geometry2 as? LineString {
        return generateIntersection(lineString1, lineString2)
    } else if let lineString = geometry1 as? LineString, let multilineString = geometry2 as? MultiLineString {
        return generateIntersection(lineString, multilineString)
    } else if let lineString = geometry1 as? LineString, let linearRing = geometry2 as? LinearRing {
        return generateIntersection(lineString, linearRing)
    } else if let multilineString = geometry1 as? MultiLineString, let lineString = geometry2 as? LineString {
        return generateIntersection(lineString, multilineString)
    } else if let multilineString1 = geometry1 as? MultiLineString, let multilineString2 = geometry2 as? MultiLineString {
        return generateIntersection(multilineString1, multilineString2)
    } else if let multilineString = geometry1 as? MultiLineString, let linearRing = geometry2 as? LinearRing {
        return generateIntersection(linearRing, multilineString)
    } else if let linearRing = geometry1 as? LinearRing, let lineString = geometry2 as? LineString {
        return generateIntersection(lineString, linearRing)
    } else if let linearRing = geometry1 as? LinearRing, let multilineString = geometry2 as? MultiLineString {
        return generateIntersection(linearRing, multilineString)
    } else if let linearRing1 = geometry1 as? LinearRing, let linearRing2 = geometry2 as? LinearRing {
        return generateIntersection(linearRing1, linearRing2)
    }
    return GeometryCollection()
}

/// For the intersection of two geometries of dimension .one and .two, respectively.
fileprivate func intersectionOneTwo(_ geometry1: Geometry, _ geometry2: Geometry) -> Geometry {

    if let lineString = geometry1 as? LineString, let polygon = geometry2 as? Polygon {
        return generateIntersection(lineString, polygon)
    } else if let lineString = geometry1 as? LineString, let multipolygon = geometry2 as? MultiPolygon {
        return generateIntersection(lineString, multipolygon)
    } else if let multilineString = geometry1 as? MultiLineString, let polygon = geometry2 as? Polygon {
        return generateIntersection(multilineString, polygon)
    } else if let multilineString = geometry1 as? MultiLineString, let multipolygon = geometry2 as? MultiPolygon {
        return generateIntersection(multilineString, multipolygon)
    } else if let linearRing = geometry1 as? LinearRing, let polygon = geometry2 as? Polygon {
        return generateIntersection(linearRing, polygon)
    } else if let linearRing = geometry1 as? LinearRing, let multipolygon = geometry2 as? MultiPolygon {
        return generateIntersection(linearRing, multipolygon)
    }
    return GeometryCollection()
}

/// For the intersection of two geometries of dimension .two and .zero, respectively.
fileprivate func intersectionTwoZero(_ geometry1: Geometry, _ geometry2: Geometry) -> Geometry {

    if let polygon = geometry1 as? Polygon, let point = geometry2 as? Point {
        return generateIntersection(point, polygon)
    } else if let polygon = geometry1 as? Polygon, let points = geometry2 as? MultiPoint {
        return generateIntersection(points, polygon)
    } else if let multipolygon = geometry1 as? MultiPolygon, let point = geometry2 as? Point {
        return generateIntersection(point, multipolygon)
    } else if let multipolygon = geometry1 as? MultiPolygon, let points = geometry2 as? MultiPoint {
        return generateIntersection(points, multipolygon)
    }
    return GeometryCollection()
}

/// For the intersection of two geometries of dimension .two and .one, respectively.
fileprivate func intersectionTwoOne(_ geometry1: Geometry, _ geometry2: Geometry) -> Geometry {

    if let polygon = geometry1 as? Polygon, let lineString = geometry2 as? LineString {
        return generateIntersection(lineString, polygon)
    } else if let polygon = geometry1 as? Polygon, let multilineString = geometry2 as? MultiLineString {
        return generateIntersection(multilineString, polygon)
    } else if let polygon = geometry1 as? Polygon, let linearRing = geometry2 as? LinearRing {
        return generateIntersection(linearRing, polygon)
    } else if let multipolygon = geometry1 as? MultiPolygon, let lineString = geometry2 as? LineString {
        return generateIntersection(lineString, multipolygon)
//    } else if let multipolygon = geometry1 as? MultiPolygon, let multilineString = geometry2 as? MultiLineString {
//        let intersectionMatrix = generateIntersection(multilineString, multipolygon)
//        return intersectionMatrix.transposed()
//    } else if let multipolygon = geometry1 as? MultiPolygon, let linearRing = geometry2 as? LinearRing {
//        let intersectionMatrix = generateIntersection(linearRing, multipolygon)
//        return intersectionMatrix.transposed()
    }
    return GeometryCollection()
}

/// For the intersection of two geometries of dimension .two.
fileprivate func intersectionTwoTwo(_ geometry1: Geometry, _ geometry2: Geometry) -> Geometry {

//    if let polgyon1 = geometry1 as? Polygon, let polygon2 = geometry2 as? Polygon {
//        return generateIntersection(polgyon1, polygon2)
//    } else if let polgyon = geometry1 as? Polygon, let multipolygon = geometry2 as? MultiPolygon {
//        return generateIntersection(polgyon, multipolygon)
//    } else if let multipolygon = geometry1 as? MultiPolygon, let polgyon = geometry2 as? Polygon {
//        let intersectionMatrix = generateIntersection(polgyon, multipolygon)
//        return intersectionMatrix.transposed()
//    } else if let multipolygon1 = geometry1 as? MultiPolygon, let multipolygon2 = geometry2 as? MultiPolygon {
//        return generateIntersection(multipolygon1, multipolygon2)
//    }
    return GeometryCollection()
}

///
/// Dimension .zero and dimension .zero
///

fileprivate func generateIntersection(_ point1: Point, _ point2: Point) -> Geometry {

    if point1 == point2 {
        return point1
    }

    return GeometryCollection()
}

fileprivate func generateIntersection(_ point: Point, _ points: MultiPoint) -> Geometry {

    for tempPoint in points {

        if tempPoint == point {
            return point
        }

    }

    return GeometryCollection()
}

fileprivate func generateIntersection(_ points1: MultiPoint, _ points2: MultiPoint) -> Geometry {

    /// Using a set here to make sure the resulting collection of Points is unique.  No duplicates.
    /// The returned value will be a MultiPoint, which may be empty.

    var intersectionCoordinatesSet = Set<Coordinate>()

    for tempPoint1 in points1 {

        for tempPoint2 in points2 {

            if tempPoint1 == tempPoint2 {
                intersectionCoordinatesSet.insert(tempPoint1.coordinate)
            }

        }

    }

    var multiPointGeometry = MultiPoint(precision: Floating(), coordinateSystem: Cartesian())

    for coordinate in intersectionCoordinatesSet {
        multiPointGeometry.append(Point(coordinate))
    }

    return multiPointGeometry
}

    ///
    /// Dimension .zero and dimension .one
    ///

    /// Returns true if the coordinate is on the line segment.
    fileprivate func coordinateIsOnLineSegment(_ coordinate: Coordinate, segment: Segment) -> LocationType {

        /// Will likely use precision later, but use EPSILON for now.
        let EPSILON = 0.01

        /// Check if the coordinate is in between the line segment endpoints in both x and y.
        let segmentLeft     = segment.leftCoordinate
        let segmentRight    = segment.rightCoordinate
        let leftX           = segmentLeft.x
        let leftY           = segmentLeft.y
        let rightX          = segmentRight.x
        let rightY          = segmentRight.y
        if  (coordinate.x < leftX && coordinate.x < rightX) ||
            (coordinate.x > leftX && coordinate.x > rightX) ||
            (coordinate.y < leftY && coordinate.y < rightY) ||
            (coordinate.y > leftY && coordinate.y > rightY) {
            return .onExterior
        }

        /// Check if the coordinate is on the boundary of the line segment
        if (coordinate == segmentLeft) || (coordinate == segmentRight) {
            return .onBoundary
        }

        /// Check for the case where the line segment is horizontal
        if (leftY == rightY) && (coordinate.y == leftY) && ((coordinate.x <= leftX && coordinate.x >= rightX) || (coordinate.x >= leftX && coordinate.x <= rightX)) {
            return .onInterior
        }

        /// Check for the cases where the line segment is vertical
        if (leftX == rightX) && (coordinate.x == leftX) && ((coordinate.y <= leftY && coordinate.y >= rightY) || (coordinate.y >= leftY && coordinate.y <= rightY)) {
            return .onInterior
        }

        /// General case
        let slope = (rightY - leftY) / (rightX - leftX)
        let value = leftY - slope * leftX
        if abs(coordinate.y - (slope * coordinate.x + value)) < EPSILON {
            return .onInterior
        }

        return .onExterior
    }

    fileprivate func generateIntersection(_ point: Point, _ lineString: LineString) -> Geometry {

        /// Check if the point is on any of the line segments in the line string.
        let mainCoord = point.coordinate
        for firstCoordIndex in 0..<lineString.count - 1 {
            let firstCoord  = lineString[firstCoordIndex]
            let secondCoord = lineString[firstCoordIndex + 1]
            let segment = Segment(left: firstCoord, right: secondCoord)
            if coordinateIsOnLineSegment(mainCoord, segment: segment) != .onExterior {
                return point
            }
        }

        /// No intersection
        return GeometryCollection()
    }

    fileprivate func generateIntersection(_ point: Point, _ linearRing: LinearRing) -> Geometry {

        /// Check if the point is on any of the line segments in the linear ring.
        let mainCoord = point.coordinate
        for firstCoordIndex in 0..<linearRing.count - 1 {
            let firstCoord  = linearRing[firstCoordIndex]
            let secondCoord = linearRing[firstCoordIndex + 1]
            let segment = Segment(left: firstCoord, right: secondCoord)
            if coordinateIsOnLineSegment(mainCoord, segment: segment) != .onExterior {
                return point
            }
        }

        /// No intersection
        return GeometryCollection()
    }

    fileprivate func generateIntersection(_ point: Point, _ multiLineString: MultiLineString) -> Geometry {

        /// Check if the point is on any of the line segments in any of the line strings.
        let mainCoord = point.coordinate
        for lineString in multiLineString {
            for firstCoordIndex in 0..<lineString.count - 1 {
                let firstCoord  = lineString[firstCoordIndex]
                let secondCoord = lineString[firstCoordIndex + 1]
                let segment = Segment(left: firstCoord, right: secondCoord)
                if coordinateIsOnLineSegment(mainCoord, segment: segment) != .onExterior {
                    return point
                }
            }
        }

        /// No intersection
        return GeometryCollection()
    }

//    fileprivate static func subset(_ coordinate: Coordinate, _ coordinates: [Coordinate]) -> Bool {
//
//        for tempCoordinate in coordinates {
//            if coordinate == tempCoordinate {
//                return true
//            }
//        }
//        return false
//    }
//
//    fileprivate static func subset(_ coordinates1: [Coordinate], _ coordinates2: [Coordinate]) -> Bool {
//
//        for tempCoordinate in coordinates1 {
//            if subset(tempCoordinate, coordinates2) {
//                continue
//            } else {
//                return false
//            }
//        }
//        return true
//    }
//
//    fileprivate static func subset(_ coordinate: Coordinate, _ lineString: LineString) -> Bool {
//
//        for firstCoordIndex in 0..<lineString.count - 1 {
//            let firstCoord  = lineString[firstCoordIndex]
//            let secondCoord = lineString[firstCoordIndex + 1]
//            let segment = Segment(left: firstCoord, right: secondCoord)
//            let location = coordinateIsOnLineSegment(coordinate, segment: segment)
//            if location == .onInterior || location == .onBoundary {
//                return true
//            }
//        }
//        return false
//    }
//
//    fileprivate static func subset(_ coordinate: Coordinate, _ multiLineString: MultiLineString) -> Bool {
//
//        for lineString in multiLineString {
//            for firstCoordIndex in 0..<lineString.count - 1 {
//                let firstCoord  = lineString[firstCoordIndex]
//                let secondCoord = lineString[firstCoordIndex + 1]
//                let segment = Segment(left: firstCoord, right: secondCoord)
//                let location = coordinateIsOnLineSegment(coordinate, segment: segment)
//                if location == .onInterior || location == .onBoundary {
//                    return true
//                }
//            }
//        }
//        return false
//    }
//
//    fileprivate static func relatedTo(_ coordinates: [Coordinate], _ lineString: LineString) -> RelatedTo {
//
//        var relatedTo = RelatedTo()
//
//        guard let lineStringBoundary = lineString.boundary() as? MultiPoint else {
//            return relatedTo
//        }
//
//        let lineStringBoundaryCoordinateArray = multiPointToCoordinateArray(lineStringBoundary)
//
//        relatedTo.firstExteriorTouchesSecondInterior = .one
//
//        if subset(lineStringBoundaryCoordinateArray, coordinates) {
//            relatedTo.firstExteriorTouchesSecondBoundary = .empty
//        } else {
//            relatedTo.firstExteriorTouchesSecondBoundary = .zero
//        }
//
//        for tempCoordinate in coordinates {
//
//            if subset(tempCoordinate, lineStringBoundaryCoordinateArray) {
//                relatedTo.firstInteriorTouchesSecondBoundary = .zero
//                continue
//            }
//
//            /// If this line is reached, a coordinate that touches the boundary of the line string has been removed
//            for firstCoordIndex in 0..<lineString.count - 1 {
//                let firstCoord  = lineString[firstCoordIndex]
//                let secondCoord = lineString[firstCoordIndex + 1]
//                let segment = Segment(left: firstCoord, right: secondCoord)
//                let location = coordinateIsOnLineSegment(tempCoordinate, segment: segment)
//                if location == .onInterior {
//                    relatedTo.firstInteriorTouchesSecondInterior = .zero
//                    break
//                } else if location == .onBoundary {
//                    /// Touching the boundary of any line segment is necessarily on the interior
//                    relatedTo.firstInteriorTouchesSecondInterior = .zero
//                    break
//                }
//
//                if firstCoordIndex == lineString.count - 2 {
//                    relatedTo.firstInteriorTouchesSecondExterior = .zero
//                }
//            }
//        }
//        return relatedTo
//    }
//
//    fileprivate static func subset(_ coordinate: Coordinate, _ linearRing: LinearRing) -> Bool {
//
//        for firstCoordIndex in 0..<linearRing.count - 1 {
//            let firstCoord  = linearRing[firstCoordIndex]
//            let secondCoord = linearRing[firstCoordIndex + 1]
//            let segment = Segment(left: firstCoord, right: secondCoord)
//            let location = coordinateIsOnLineSegment(coordinate, segment: segment)
//            if location == .onInterior || location == .onBoundary {
//                return true
//            }
//        }
//        return false
//    }
//
    /// The coordinates array consists of a collection of tuples where each item contains a Coordinate and a boolean indicating
    /// whether the Coordinate is a boundary point.
    fileprivate func relatedTo(_ coordinates: [(Coordinate, Bool)], _ linearRing: LinearRing) -> RelatedTo {

        var relatedTo = RelatedTo()
        for (tempCoordinate, isBoundaryPoint) in coordinates {
            var pointIsOnExterior = true // The point cannot touch the boundary or interior of any segment to be on the exterior
            for firstCoordIndex in 0..<linearRing.count - 1 {
                let firstCoord  = linearRing[firstCoordIndex]
                let secondCoord = linearRing[firstCoordIndex + 1]
                let segment = Segment(left: firstCoord, right: secondCoord)
                let location = coordinateIsOnLineSegment(tempCoordinate, segment: segment)
                if location == .onInterior {
                    pointIsOnExterior = false
                    if isBoundaryPoint {
                        relatedTo.firstBoundaryTouchesSecondInterior = .zero
                    } else {
                        relatedTo.firstInteriorTouchesSecondInterior = .zero
                    }
                } else if location == .onBoundary {
                    /// The boundary of any line segment on the linear ring is necessarily on the interior of the linear ring
                    pointIsOnExterior = false
                    if isBoundaryPoint {
                        relatedTo.firstBoundaryTouchesSecondInterior = .zero
                    } else {
                        relatedTo.firstInteriorTouchesSecondInterior = .zero
                    }
                }
            }

            if pointIsOnExterior {
                if isBoundaryPoint {
                    relatedTo.firstBoundaryTouchesSecondExterior = .zero
                } else {
                    relatedTo.firstInteriorTouchesSecondExterior = .zero
                }
            }
        }
        return relatedTo
    }

    /// This assumes a GeometryCollection where all of the elements are LinearRings.
    /// The coordinates array is a collection of Coordinate, Bool tuples, where the Bool is a flag indicating whether the point is a boundary point.
    fileprivate func relatedTo(_ coordinates: [(Coordinate, Bool)], _ geometryCollection: GeometryCollection) -> RelatedTo {

        var relatedTo = RelatedTo()

        for index in 0..<geometryCollection.count {

            guard let linearRing = geometryCollection[index] as? LinearRing else {
                return relatedTo
            }

            for (tempCoordinate, _) in coordinates {
                for firstCoordIndex in 0..<linearRing.count - 1 {
                    let firstCoord  = linearRing[firstCoordIndex]
                    let secondCoord = linearRing[firstCoordIndex + 1]
                    let segment = Segment(left: firstCoord, right: secondCoord)
                    let location = coordinateIsOnLineSegment(tempCoordinate, segment: segment)
                    if location == .onInterior {
                        relatedTo.firstInteriorTouchesSecondInterior = .zero
                    } else if location == .onBoundary {
                        /// The boundary of any line segment on the linear ring is necessarily on the interior of the linear ring
                        relatedTo.firstInteriorTouchesSecondInterior = .zero
                    } else {
                        relatedTo.firstInteriorTouchesSecondExterior = .zero
                    }
                }
            }
        }

        return relatedTo
    }

//    fileprivate static func relatedTo(_ coordinates: [Coordinate], _ multiLineString: MultiLineString) -> RelatedTo {
//
//        var relatedTo = RelatedTo()
//
//        guard let multiLineStringBoundary = multiLineString.boundary() as? MultiPoint else {
//            return relatedTo
//        }
//
//        let multiLineStringCoordinateArray = multiPointToCoordinateArray(multiLineStringBoundary)
//
//        for tempCoordinate in coordinates {
//
//            if subset(tempCoordinate, multiLineStringCoordinateArray) {
//                relatedTo.firstInteriorTouchesSecondBoundary = .zero
//                continue
//            }
//
//            /// If this point is reached, any point that touches the boundary of the multi line string has been removed
//            var tempPointNotTouchingAnyLineString = true
//            for lineString in multiLineString {
//                for firstCoordIndex in 0..<lineString.count - 1 {
//                    let firstCoord  = lineString[firstCoordIndex]
//                    let secondCoord = lineString[firstCoordIndex + 1]
//                    let segment = Segment(left: firstCoord, right: secondCoord)
//                    let location = coordinateIsOnLineSegment(tempCoordinate, segment: segment)
//                    if location == .onInterior {
//                        relatedTo.firstInteriorTouchesSecondInterior = .zero
//                        tempPointNotTouchingAnyLineString = false
//                    } else if location == .onBoundary {
//                        /// Touching the boundary of any line segment is necessarily on the interior
//                        relatedTo.firstInteriorTouchesSecondInterior = .zero
//                        tempPointNotTouchingAnyLineString = false
//                    }
//                }
//            }
//
//            if tempPointNotTouchingAnyLineString {
//                relatedTo.firstInteriorTouchesSecondExterior = .zero
//            }
//        }
//        return relatedTo
//    }
//
    /// This code parallels that of a point and a simple polygon.
    /// Algorithm taken from: https://stackoverflow.com/questions/29344791/check-whether-a-point-is-inside-of-a-simple-polygon
    /// The coordinate is a Coordinate object and a flag indicating whether it is a boundary point.
    fileprivate func relatedTo(_ coordinateTuple: (Coordinate, Bool), _ linearRing: LinearRing) -> RelatedTo {

        var relatedToResult = RelatedTo()

        /// Check if the coordinate is on the boundary of the linear ring
        var coordinates = [(Coordinate, Bool)]()
        coordinates.append(coordinateTuple)
        let tempRelatedToResult = relatedTo(coordinates, linearRing)
        if tempRelatedToResult.firstTouchesSecondInterior != .empty {
            relatedToResult.firstInteriorTouchesSecondInterior = .zero
            return relatedToResult
        }

        let coordinate = coordinateTuple.0

        var secondCoord = linearRing[linearRing.count - 1]

        var isSubset = false

        for firstCoordIndex in 0..<linearRing.count - 1 {
            let firstCoord  = linearRing[firstCoordIndex]

            if ((firstCoord.y >= coordinate.y) != (secondCoord.y >= coordinate.y)) &&
                (coordinate.x <= (secondCoord.x - firstCoord.x) * (coordinate.y - firstCoord.y) / (secondCoord.y - firstCoord.y) + firstCoord.x) {
                isSubset = !isSubset
            }

            secondCoord = firstCoord
        }

        relatedToResult = RelatedTo() /// Resets to default values

        if isSubset {
            relatedToResult.firstInteriorTouchesSecondInterior = .zero
        } else {
            relatedToResult.firstInteriorTouchesSecondExterior = .zero
        }

        return relatedToResult
    }

    /// Assume here that the polygon is a simple polygon with no holes, just a single simple boundary.
    /// Algorithm taken from: https://stackoverflow.com/questions/29344791/check-whether-a-point-is-inside-of-a-simple-polygon
    /// The algorithm was modified because we assume the polygon is defined as a LinearRing, whose first and last points are the same.
    /// The coordinate tuple is a Coordinate object and a flag indicating whether it is a boundary point.
    fileprivate func relatedTo(_ coordinateTuple: (Coordinate, Bool), _ simplePolygon: Polygon) -> RelatedTo {

        var relatedToResult = RelatedTo()

        guard let polygonBoundary = simplePolygon.boundary() as? GeometryCollection,
            polygonBoundary.count > 0,
            let outerLinearRing = polygonBoundary[0] as? LinearRing,
            outerLinearRing.count > 0 else {
                return relatedToResult
        }

        /// Check if the point is on the boundary of the polygon
        var coordinatesTupleArray = [(Coordinate, Bool)]()
        coordinatesTupleArray.append(coordinateTuple)
        let tempRelatedToResult = relatedTo(coordinatesTupleArray, outerLinearRing)
        let isBoundaryPoint = coordinateTuple.1
        if tempRelatedToResult.firstTouchesSecondInterior != .empty || tempRelatedToResult.firstTouchesSecondBoundary != .empty {
            if isBoundaryPoint {
                relatedToResult.firstBoundaryTouchesSecondBoundary = .zero
            } else {
                relatedToResult.firstInteriorTouchesSecondBoundary = .zero
            }
            relatedToResult.firstExteriorTouchesSecondInterior = .two
            relatedToResult.firstExteriorTouchesSecondBoundary = .one
            return relatedToResult
        }

        /// Coordinate does not touch the polygon boundary
        let coordinate = coordinateTuple.0

        var isSubset = false

        var firstCoord  = outerLinearRing[0]

        for firstCoordIndex in 1..<outerLinearRing.count {
            let secondCoord = outerLinearRing[firstCoordIndex]

            if ((secondCoord.y >= coordinate.y) != (firstCoord.y >= coordinate.y)) &&
                (coordinate.x <= (firstCoord.x - secondCoord.x) * (coordinate.y - secondCoord.y) / (firstCoord.y - secondCoord.y) + secondCoord.x) {
                isSubset = !isSubset
            }

            firstCoord = secondCoord
        }

        relatedToResult = RelatedTo() /// Resets to default values
        relatedToResult.firstExteriorTouchesSecondInterior = .two
        relatedToResult.firstExteriorTouchesSecondBoundary = .one

        if isSubset {
            relatedToResult.firstInteriorTouchesSecondInterior = .zero
            if isBoundaryPoint {
                relatedToResult.firstBoundaryTouchesSecondInterior = .zero
            }
        } else {
            if isBoundaryPoint {
                relatedToResult.firstBoundaryTouchesSecondExterior = .zero
            } else {
                relatedToResult.firstInteriorTouchesSecondExterior = .zero
            }
        }

        return relatedToResult
    }

//    fileprivate static func relatedTo(_ coordinate: Coordinate, _ simplePolygon: Polygon) -> RelatedTo {
//
//        return relatedTo((coordinate, false), simplePolygon)
//    }
//
//    fileprivate static func relatedTo(_ coordinate: Coordinate, _ linearRing: LinearRing) -> RelatedTo {
//
//        return relatedTo((coordinate, false), linearRing)
//    }
//
    /// Assume here that the polygon is a general polygon with holes.
    /// Note we've changed the name so as not to conflict with the simple polygon case.  This may change later.
    /// The coordinate tuple is a Coordinate object and a flag indicating whether it is a boundary point.
    fileprivate func relatedToGeneral(_ coordinateTuple: (Coordinate, Bool), _ polygon: Polygon) -> RelatedTo {

        var relatedToResult = RelatedTo()

        guard let polygonBoundary = polygon.boundary() as? GeometryCollection,
            polygonBoundary.count > 0,
            let outerLinearRing = polygonBoundary[0] as? LinearRing,
            outerLinearRing.count > 0 else {
                return relatedToResult
        }

        /// Get the relationship between the coordinate and the main polygon
        let tempPolygon = Polygon(outerLinearRing, precision: Floating(), coordinateSystem: Cartesian())
        let coordinateRelatedToResult = relatedTo(coordinateTuple, tempPolygon)

        /// Check if the coordinate is on the exterior of the main polygon
        if coordinateRelatedToResult.firstTouchesSecondExterior > .empty {
            return coordinateRelatedToResult
        }

        /// Check if the coordinate is on the boundary of the main polygon
        if coordinateRelatedToResult.firstTouchesSecondBoundary > .empty {
            return coordinateRelatedToResult
        }

        /// From this coordinate on, the coordinate must be on the interior of the main polygon.
        /// Now we have to check to see if the coordinate is on the boundary or interior of any holes.

        for index in 1..<polygonBoundary.count {

            guard let innerLinearRing = polygonBoundary[index] as? LinearRing,
                innerLinearRing.count > 0 else {
                    return coordinateRelatedToResult
            }

            /// Get the relationship between the coordinate and the hole
            let tempPolygon = Polygon(innerLinearRing, precision: Floating(), coordinateSystem: Cartesian())
            /// Flag the line below.
            /// This variable name is the same as one outside the loop.  Check this.
            let coordinateRelatedToResult = relatedTo(coordinateTuple, tempPolygon)

            /// Check if the coordinate is on the interior of the hole
            if coordinateRelatedToResult.firstTouchesSecondInterior > .empty {
                relatedToResult.firstInteriorTouchesSecondExterior = .zero
                return relatedToResult
            }

            /// Check if the coordinate is on the boundary of the hole
            if coordinateRelatedToResult.firstTouchesSecondBoundary > .empty {
                return coordinateRelatedToResult
            }

        }

        /// If we've gotten this far, the coordinate must on the interior of the polygon
        relatedToResult.firstInteriorTouchesSecondInterior = .zero

        return relatedToResult
    }

    /// Assume here that the multi polygon is a general multi polygon with a collection of non-intersecting general polygons.
    /// The coordinate tuple is a Coordinate object and a flag indicating whether it is a boundary point.
    fileprivate func relatedTo(_ coordinateTuple: (Coordinate, Bool), _ multipolygon: MultiPolygon) -> RelatedTo {

        var relatedToResult = RelatedTo()

        /// There is a special case where a coordinate touches the exterior of a MultiPolygon only when it
        /// touches the exterior of every Polygon in the MultiPolygon.  Therefore, we will track the
        /// total number of times the point touches the exterior of a Polygon.
        var coordinateTouchesExteriorOfPolygonCount = 0

        /// Loop over the polygons and update the relatedToResult struct as needed on each pass.

        for polygon in multipolygon {

            /// Get the relationship between the coordinate and the polygon
            let coordinateRelatedToResult = relatedToGeneral(coordinateTuple, polygon)

            /// Update the exterior count
            if coordinateRelatedToResult.firstTouchesSecondExterior > .empty {
                coordinateTouchesExteriorOfPolygonCount += 1
            }

            /// Update the relatedToResult as needed
            update(relatedToBase: &relatedToResult, relatedToNew: coordinateRelatedToResult)

        }

        /// Update the interior, exterior or boundary, exterior parameter
        if coordinateTuple.1 { // Is this a boundary point?
            relatedToResult.firstBoundaryTouchesSecondExterior = .empty
            if coordinateTouchesExteriorOfPolygonCount == multipolygon.count {
                relatedToResult.firstBoundaryTouchesSecondExterior = .zero
            }
        } else {
            relatedToResult.firstInteriorTouchesSecondExterior = .empty
            if coordinateTouchesExteriorOfPolygonCount == multipolygon.count {
                relatedToResult.firstInteriorTouchesSecondExterior = .zero
            }
        }

        return relatedToResult
    }

    /// This function takes one RelatedTo struct, the base struct, and compares a new RelatedTo struct to it.
    /// If the values of the new RelatedTo struct are greater than the base struct, the base struct is updated with the new values.
    fileprivate func update(relatedToBase: inout RelatedTo, relatedToNew: RelatedTo) {

        if relatedToNew.firstInteriorTouchesSecondInterior > relatedToBase.firstInteriorTouchesSecondInterior {
            relatedToBase.firstInteriorTouchesSecondInterior = relatedToNew.firstInteriorTouchesSecondInterior
        }

        if relatedToNew.firstInteriorTouchesSecondBoundary > relatedToBase.firstInteriorTouchesSecondBoundary {
            relatedToBase.firstInteriorTouchesSecondBoundary = relatedToNew.firstInteriorTouchesSecondBoundary
        }

        if relatedToNew.firstInteriorTouchesSecondExterior > relatedToBase.firstInteriorTouchesSecondExterior {
            relatedToBase.firstInteriorTouchesSecondExterior = relatedToNew.firstInteriorTouchesSecondExterior
        }

        if relatedToNew.firstBoundaryTouchesSecondInterior > relatedToBase.firstBoundaryTouchesSecondInterior {
            relatedToBase.firstBoundaryTouchesSecondInterior = relatedToNew.firstBoundaryTouchesSecondInterior
        }

        if relatedToNew.firstBoundaryTouchesSecondBoundary > relatedToBase.firstBoundaryTouchesSecondBoundary {
            relatedToBase.firstBoundaryTouchesSecondBoundary = relatedToNew.firstBoundaryTouchesSecondBoundary
        }

        if relatedToNew.firstBoundaryTouchesSecondExterior > relatedToBase.firstBoundaryTouchesSecondExterior {
            relatedToBase.firstBoundaryTouchesSecondExterior = relatedToNew.firstBoundaryTouchesSecondExterior
        }

        if relatedToNew.firstExteriorTouchesSecondInterior > relatedToBase.firstExteriorTouchesSecondInterior {
            relatedToBase.firstExteriorTouchesSecondInterior = relatedToNew.firstExteriorTouchesSecondInterior
        }

        if relatedToNew.firstExteriorTouchesSecondBoundary > relatedToBase.firstExteriorTouchesSecondBoundary {
            relatedToBase.firstExteriorTouchesSecondBoundary = relatedToNew.firstExteriorTouchesSecondBoundary
        }

        if relatedToNew.firstExteriorTouchesSecondExterior > relatedToBase.firstExteriorTouchesSecondExterior {
            relatedToBase.firstExteriorTouchesSecondExterior = relatedToNew.firstExteriorTouchesSecondExterior
        }
    }

//    /// This function takes one IntersectionMatrix struct, the base struct, and compares a new IntersectionMatrix struct to it.
//    /// If the values of the new IntersectionMatrix struct are greater than the base struct, the base struct is updated with the new values.
//    /// Note the RelatedTo struct has evolved into an IntersectionMatrix equivalent.
//    /// We may use both or simply replace RelatedTo with IntersectionMatric everywhere.
//    fileprivate static func update(intersectionMatrixBase: inout IntersectionMatrix, intersectionMatrixNew: IntersectionMatrix) {
//
//        if intersectionMatrixNew[.interior, .interior] > intersectionMatrixBase[.interior, .interior] {
//            intersectionMatrixBase[.interior, .interior] = intersectionMatrixNew[.interior, .interior]
//        }
//
//        if intersectionMatrixNew[.interior, .boundary] > intersectionMatrixBase[.interior, .boundary] {
//            intersectionMatrixBase[.interior, .boundary] = intersectionMatrixNew[.interior, .boundary]
//        }
//
//        if intersectionMatrixNew[.interior, .exterior] > intersectionMatrixBase[.interior, .exterior] {
//            intersectionMatrixBase[.interior, .exterior] = intersectionMatrixNew[.interior, .exterior]
//        }
//
//        if intersectionMatrixNew[.boundary, .interior] > intersectionMatrixBase[.boundary, .interior] {
//            intersectionMatrixBase[.boundary, .interior] = intersectionMatrixNew[.boundary, .interior]
//        }
//
//        if intersectionMatrixNew[.boundary, .boundary] > intersectionMatrixBase[.boundary, .boundary] {
//            intersectionMatrixBase[.boundary, .boundary] = intersectionMatrixNew[.boundary, .boundary]
//        }
//
//        if intersectionMatrixNew[.boundary, .exterior] > intersectionMatrixBase[.boundary, .exterior] {
//            intersectionMatrixBase[.boundary, .exterior] = intersectionMatrixNew[.boundary, .exterior]
//        }
//
//        if intersectionMatrixNew[.exterior, .interior] > intersectionMatrixBase[.exterior, .interior] {
//            intersectionMatrixBase[.exterior, .interior] = intersectionMatrixNew[.exterior, .interior]
//        }
//
//        if intersectionMatrixNew[.exterior, .boundary] > intersectionMatrixBase[.exterior, .boundary] {
//            intersectionMatrixBase[.exterior, .boundary] = intersectionMatrixNew[.exterior, .boundary]
//        }
//
//        if intersectionMatrixNew[.exterior, .exterior] > intersectionMatrixBase[.exterior, .exterior] {
//            intersectionMatrixBase[.exterior, .exterior] = intersectionMatrixNew[.exterior, .exterior]
//        }
//    }
//
    /// The polygon is a general polygon.  This polygon has holes.
    /// The coordinate tuple array consists of a tuple of Coordinate and Bool, where the Bool is a flag indicating whether the coordinate is a boundary point.
    fileprivate func relatedTo(_ coordinatesTupleArray: [(Coordinate, Bool)], _ polygon: Polygon) -> RelatedTo {

        var relatedToResult = RelatedTo()

        /// It is assumed that the polygon boundary is a collection of LinearRings with the first
        /// being the main polygon boundary and the rest being the holes inside the polygon.
        /// In this case, we should have just one LinearRing, which is the outer LinearRing.
        guard let polygonBoundary = polygon.boundary() as? GeometryCollection,
            polygonBoundary.count > 0 else {
                return relatedToResult
        }

        /// Check if any of the coordinates are on the boundary
        let coordinatesRelatedToBoundary = relatedTo(coordinatesTupleArray, polygonBoundary)
        if coordinatesRelatedToBoundary.firstTouchesSecondInterior != .empty || coordinatesRelatedToBoundary.firstTouchesSecondBoundary != .empty {
            relatedToResult.firstInteriorTouchesSecondBoundary = .zero
        }

        var coordinatesOnInteriorOfMainRing     = [Coordinate]()
        var coordinatesOnInteriorOfInnerRings   = [Coordinate]()
        var coordinatesOnBoundaryOfInnerRings   = [Coordinate]()

        for (tempCoordinate, boundaryPoint) in coordinatesTupleArray {

            var firstTime = true

            for element in polygonBoundary {

                guard let linearRing = element as? LinearRing else {
                    return relatedToResult
                }

                let tempPolygon = Polygon(linearRing, precision: Floating(), coordinateSystem: Cartesian())

                let tempRelatedToResult = relatedTo((tempCoordinate, boundaryPoint), tempPolygon)

                /// The first linear ring is the outer boundary of the polygon
                if firstTime {
                    if tempRelatedToResult.firstTouchesSecondExterior > .empty {
                        relatedToResult.firstInteriorTouchesSecondExterior = .zero
                        break
                    } else if tempRelatedToResult.firstTouchesSecondBoundary > .empty {
                        relatedToResult.firstInteriorTouchesSecondBoundary = .zero
                        break
                    } else {
                        coordinatesOnInteriorOfMainRing.append(tempCoordinate)
                    }
                    firstTime = false

                } else {
                    /// The algorithm will only reach this point if the coordinate is on the interior of the main polygon.
                    /// Note, too, that the tempPolygon above now refers to one of the main polygon's holes.
                    /// If the coordinate is on the interior of a hole, it is on the exterior of the main polygon.
                    if tempRelatedToResult.firstTouchesSecondInterior > .empty {
                        coordinatesOnInteriorOfInnerRings.append(tempCoordinate)
                        relatedToResult.firstInteriorTouchesSecondExterior = .zero
                        break
                    }

                    if tempRelatedToResult.firstTouchesSecondBoundary > .empty {
                        coordinatesOnBoundaryOfInnerRings.append(tempCoordinate)
                        relatedToResult.firstInteriorTouchesSecondBoundary = .zero
                        break
                    }
                }
            }
        }

        if coordinatesOnInteriorOfMainRing.count > coordinatesOnInteriorOfInnerRings.count + coordinatesOnBoundaryOfInnerRings.count {
            relatedToResult.firstInteriorTouchesSecondInterior = .zero
        }

        return relatedToResult
    }

    /// Assume here that the polygon is a general polygon with holes.
    /// Note we've changed the name so as not to conflict with the simply polygon case.  This may change later.
    /// Each element of the coordinate tuple array consists of a Coordinate and Bool, where the Bool is a flag indicating whether the coordinate is a boundary point.
    fileprivate func relatedToGeneral(_ coordinateTupleArray: [(Coordinate, Bool)], _ polygon: Polygon) -> RelatedTo {

        var relatedToResult = RelatedTo()

        /// Get the polygon boundary
        guard let polygonBoundary = polygon.boundary() as? GeometryCollection,
            polygonBoundary.count > 0,
            let outerLinearRing = polygonBoundary[0] as? LinearRing,
            outerLinearRing.count > 0 else {
                return relatedToResult
        }

        for (coordinate, boundaryPoint) in coordinateTupleArray {

            /// Get the relationships between each coordinate and the general polygon
            let coordinateRelatedToResult = relatedToGeneral((coordinate, boundaryPoint), polygon)

            /// Check if the coordinate is on the interior of the polygon
            if coordinateRelatedToResult.firstTouchesSecondInterior > .empty {
                if boundaryPoint {
                    relatedToResult.firstBoundaryTouchesSecondInterior = .zero
                } else {
                    relatedToResult.firstInteriorTouchesSecondInterior = .zero
                }
            }

            /// Check if the coordinate is on the boundary of the polygon
            if coordinateRelatedToResult.firstTouchesSecondBoundary > .empty {
                if boundaryPoint {
                    relatedToResult.firstBoundaryTouchesSecondBoundary = .zero
                } else {
                    relatedToResult.firstInteriorTouchesSecondBoundary = .zero
                }
            }

            /// Check if the coordinate is on the exterior of the polygon
            if coordinateRelatedToResult.firstTouchesSecondExterior > .empty {
                if boundaryPoint {
                    relatedToResult.firstBoundaryTouchesSecondExterior = .zero
                } else {
                    relatedToResult.firstInteriorTouchesSecondExterior = .zero
                }
            }

        }

        return relatedToResult
    }

    /// Assume here that the multi polygon is a general multi polygon with holes.
    /// The coordinate tuple array consists of a tuple of Coordinate and Bool, where the Bool is a flag indicating whether the coordinate is a boundary point.
    fileprivate func relatedTo(_ coordinateTupleArray: [(Coordinate, Bool)], _ multipolygon: MultiPolygon) -> RelatedTo {

        var relatedToResult = RelatedTo()

        /// Loop over the coordinate tuples and update the relatedToResult struct as needed on each pass.

        for coodinateTuple in coordinateTupleArray {

            /// Get the relationships between each coordinate tuple and the general multipolygon
            let pointRelatedToResult = relatedTo(coodinateTuple, multipolygon)

            /// Update the relatedToResult as needed
            update(relatedToBase: &relatedToResult, relatedToNew: pointRelatedToResult)
        }

        return relatedToResult
    }

    ///
    /// Describes the relationship between a single Segment and the Segments of a LinearRing.
    ///
    /// This was developed to help to determine the intersection between a LineString and a Polygon.
    /// In particular, it will be used to determine the overlap of a Segment with segments in a LinearRing,
    /// whether it is the main LinearRing of the Polygon or a hole.
    ///
    /// - parameters:
    ///     - segment: The segment which will be checked for overlaps with the LinearRing.
    ///     - linearRing: The LinearRing which the segment may overlap in a variety of ways.
    ///     - hole: Is the LinearRing a hole in some polgyon or the main outer ring?
    ///
    ///  - returns: An array of SegmentOverlap structs, one for each segment in the linear ring.
    ///
    fileprivate func crosses(_ segment: Segment, _ linearRing: LinearRing, _ hole: Bool) -> [SegmentOverlap] {

        var overlapResults = [SegmentOverlap]()

        let simplifiedLinearRing = linearRing.simplify(tolerance: 1.0)

        /// For each line segment in the simplified linear ring, check the following:
        /// - Is the main segment a subset of the linear ring segment?
        /// - Is the linear ring segment a subset of the main segment?
        /// - Do the main segment and the linear ring segment intersect at a single point and what is that point?
        /// - Do the main segment and the linear ring segment intersect at another segment and what is that segment?
        for firstCoordIndex in 0..<simplifiedLinearRing.count - 1 {
            let firstCoord  = simplifiedLinearRing[firstCoordIndex]
            let secondCoord = simplifiedLinearRing[firstCoordIndex + 1]
            let segment2 = Segment(left: firstCoord, right: secondCoord)

            let lineSegmentIntersection = intersection(segment: segment, other: segment2)

            /// Check for a LineString or Point intersection.
            var lineSegmentOverlap: Segment?
            var pointOverlap: Point?
            if let lineString = lineSegmentIntersection.geometry as? LineString, lineString.count == 2 {
                lineSegmentOverlap = Segment(left: lineString[0], right: lineString[1])
            } else if let point = lineSegmentIntersection.geometry as? Point {
                pointOverlap = point
            }

            overlapResults.append(SegmentOverlap(segmentNumber: firstCoordIndex, hole: hole, firstSubsetOfSecond: lineSegmentIntersection.firstSubsetOfSecond, secondSubsetOfFirst: lineSegmentIntersection.secondSubsetOfFirst, point: pointOverlap, segment: lineSegmentOverlap))
        }

        /// Return

        return overlapResults
    }

    ///
    /// Collects all the points for a SegmentOverlap array and returns a single MultiPoint
    ///
    /// This was developed to help to determine the intersection between a LineString and a Polygon.
    ///
    /// - parameters:
    ///     - overlaps: An array of SegmentOverlap structs.
    ///
    ///  - returns: A MultiPoint containing all the points in the SegmentOverlap array.
    ///
    fileprivate func points(_ overlaps: [SegmentOverlap]) -> MultiPoint {

        var multiPointGeometry = MultiPoint(precision: Floating(), coordinateSystem: Cartesian())

        /// For each segment overlap, check if there is a point.  If so, add it to the MultiPoint.
        for segmentOverlap in overlaps {
            if let point = segmentOverlap.point {
                multiPointGeometry.append(point)
            }
        }

        /// Return
        return multiPointGeometry
    }

    ///
    /// Collects all the coordinates for a SegmentOverlap array and the endpoints of a segment.
    /// This includes the coordinates of individual points and the endpoints of the segments.
    /// These may be duplicated.
    /// Note the first coordinate of the segment will always be first.
    ///
    /// This was developed to help to determine the intersection between a LineString and a Polygon.
    ///
    /// - parameters:
    ///     - segment: The segment of interest.
    ///     - overlaps: An array of SegmentOverlap structs.
    ///
    ///  - returns: A MultiPoint containing all the points in the SegmentOverlap array.
    ///
    fileprivate func segmentCoordinates(_ segment: Segment, _ overlaps: [SegmentOverlap]) -> [Coordinate] {

        var coordinates = [Coordinate]()

        /// Add the first and last coordinates of the segment endpoints.
        /// Note that the first coordinate of the segment will always be first.
        coordinates.append(segment.leftCoordinate)
        coordinates.append(segment.rightCoordinate)

        /// For each segment overlap, check if there is a point or a segment.
        /// If so, add the coordinates of the point, or the coordinates of the segment endpoints to the final array.
        for segmentOverlap in overlaps {
            if let point = segmentOverlap.point {
                coordinates.append(point.coordinate)
            }
            if let segment = segmentOverlap.segment {
                coordinates.append(segment.leftCoordinate)
                coordinates.append(segment.rightCoordinate)
            }
        }

        /// Return
        return coordinates
    }

    ///
    /// Sorts the coordinates of a line segment from those nearest the first coordinate to those farthest away.
    /// Some coordinates may be duplicated.
    /// Note the first coordinate of the segment will always be first.
    /// Removes duplicate coordinates.
    ///
    /// This was developed to help to determine the intersection between a LineString and a Polygon.
    ///
    /// - parameters:
    ///     - coordinates: An array of Coordinates represent points on a segment.
    ///
    ///  - returns: A MultiPoint containing all the points in the SegmentOverlap array.
    ///
    fileprivate func sortSegmentCoordinates(_ coordinates: [Coordinate]) -> [Coordinate] {

        /// Create a new array consisting of tuples or coordinates and their distance from the first coordinate.
        var distances = [(Coordinate, Double)]()
        let firstCoordinate = coordinates[0]
        for newCoordinate in coordinates {
            let distanceFromFirst = distance(firstCoordinate, newCoordinate)
            distances.append((newCoordinate, distanceFromFirst))
        }

        /// Sort the coordinates from closest to the first coordinate to the farthest.
        let sortedDistances = distances.sorted(by: {$0.1 < $1.1})
        let sortedCoordinates = sortedDistances.map{ $0.0 }

        /// Remove duplicate coordinates.
        var sortedUniqueCoordinates = [Coordinate]()
        var currentCoordinate = firstCoordinate
        sortedUniqueCoordinates.append(currentCoordinate)
        for index in 1..<sortedCoordinates.count {
            let newCoordinate = sortedCoordinates[index]
            if newCoordinate != currentCoordinate {
                currentCoordinate = newCoordinate
                sortedUniqueCoordinates.append(currentCoordinate)
            }
        }

        /// Return
        return sortedUniqueCoordinates
    }

    ///
    /// - parameters:
    ///     - coord1: The first coordinate.
    ///     - coord2: The second coordinate.
    ///
    ///  - returns: The midpoint coordinate of the two input coordinates.
    ///
    fileprivate func midpoint(_ coord1: Coordinate, _ coord2: Coordinate) -> Coordinate {

        return Coordinate(x: (coord1.x + coord2.x) / 2.0, y: (coord1.y + coord2.y) / 2.0)

    }

    ///
    /// - parameters:
    ///     - coord1: The first coordinate.
    ///     - coord2: The second coordinate.
    ///
    ///  - returns: The distance between the two input coordinates.
    ///
    fileprivate func distance(_ coord1: Coordinate, _ coord2: Coordinate) -> Double {

        return sqrt(pow((coord1.x - coord2.x), 2.0) + pow((coord1.y - coord2.y), 2.0))

    }

//    /// This code parallels that where the second geometry is a simple polygon.
//    fileprivate static func relatedTo(_ segment: Segment, _ linearRing: LinearRing) -> RelatedTo {
//
//        var relatedToResult = RelatedTo()
//
//        /// For each line segment in the line string, check the following:
//        /// - Is all the line segment in the interior of the linear ring?  If so, set the firstTouchesSecondInterior to .one.
//        /// - Is a > 0 length proper subset of the line segment in the interior of the linear ring?  If so, set the firstTouchesSecondInterior to .one.
//        ///   Also, generate an ordered array of points at which the line segment touches the interior.  (The line segment could touch the linear ring interior at
//        ///   more than one sub line segment.)  This array will include the end points of sub line segments.  From this array generate a second array of the
//        ///   midpoints.  Check whether each point in that array is inside or outside of the linear ring.  If inside, set the firstTouchesSecondInterior to .one.
//        ///   If outside, set firstTouchesSecondExterior to .one.
//        /// - Does the line segment touch the linear ring interior at one or more points?  If so, set the firstTouchesSecondInterior to .zero.
//        /// - Does either line segment endpoint touch outside the linear ring?  If so, set the firstTouchesSecondExterior to .one.
//
//        /// Array of geometries at which the segment intersects the linear ring boundary
//        var intersectionGeometries = [Geometry]()
//
//        /// Do a first pass to get the basic relationship of the line segment to the linear ring
//        var segmentCompletelyContainedInLinearRing = false
//        for firstCoordIndex in 0..<linearRing.count - 1 {
//            let firstCoord  = linearRing[firstCoordIndex]
//            let secondCoord = linearRing[firstCoordIndex + 1]
//            let segment2 = Segment(left: firstCoord, right: secondCoord)
//
//            let lineSegmentIntersection = intersection(segment: segment, other: segment2)
//
//            if let intersectionGeometry = lineSegmentIntersection.geometry {
//                intersectionGeometries.append(intersectionGeometry)
//
//                if intersectionGeometry.dimension == .one {
//                    relatedToResult.firstInteriorTouchesSecondInterior = .one
//                    if lineSegmentIntersection.firstSubsetOfSecond {
//                        segmentCompletelyContainedInLinearRing = true
//                    }
//                } else if intersectionGeometry.dimension == .zero {
//                    if lineSegmentIntersection.firstSegmentFirstBoundaryLocation == .onInterior || lineSegmentIntersection.firstSegmentSecondBoundaryLocation == .onInterior {
//                        relatedToResult.firstBoundaryTouchesSecondInterior = .zero
//                    }
//                }
//
//                if lineSegmentIntersection.firstSegmentFirstBoundaryLocation == .onBoundary || lineSegmentIntersection.firstSegmentSecondBoundaryLocation == .onBoundary {
//                    relatedToResult.firstBoundaryTouchesSecondInterior = .zero
//                }
//            }
//        }
//
//        if segmentCompletelyContainedInLinearRing {
//            relatedToResult.firstInteriorTouchesSecondInterior = .one
//            relatedToResult.firstBoundaryTouchesSecondInterior = .zero
//        } else {
//            relatedToResult.firstInteriorTouchesSecondExterior = .one
//            relatedToResult.firstBoundaryTouchesSecondExterior = .zero
//        }
//
//        /// Check the cases where no further work is needed.
//        if (relatedToResult.firstTouchesSecondInterior == .one && relatedToResult.firstTouchesSecondExterior == .one) ||
//            (relatedToResult.firstTouchesSecondInterior == .empty) ||
//            (intersectionGeometries.count <= 1) {
//            return relatedToResult
//        }
//
//        /// Check the case where the line segment interior lies on the interior or exterior of the linear ring.  This is why we have been collecting the geometries.
//        /// Do the following:
//        /// - Generate an array of the midpoints of the consecutive geometries.
//        /// - Check whether each point in that array is inside or outside of the linear ring.
//        ///   If inside, set the firstTouchesSecondInterior to .one.
//        ///   If outside, set firstTouchesSecondExterior to .one.
//        ///
//        /// Note that this algorithm can likely be made better in the cases where two midpoints are created rather than just one.
//
//        guard intersectionGeometries.count >= 2 else { return relatedToResult }
//
//        var midpointCoordinates = [Coordinate]()
//
//        for firstGeometryIndex in 0..<intersectionGeometries.count - 1 {
//            let intersectionGeometry1 = intersectionGeometries[firstGeometryIndex]
//            let intersectionGeometry2 = intersectionGeometries[firstGeometryIndex + 1]
//
//            var midpointCoord1: Coordinate?
//            var midpointCoord2: Coordinate?
//            if let point1 = intersectionGeometry1 as? Point, let point2 = intersectionGeometry2 as? Point {
//
//                midpointCoord1 = midpoint(point1.coordinate, point2.coordinate)
//
//            } else if let point = intersectionGeometry1 as? Point, let segment = intersectionGeometry2 as? Segment {
//
//                /// Since we don't know which end of the segment is sequentially next to the point, we add both midpoints
//                midpointCoord1 = midpoint(point.coordinate, segment.leftCoordinate)
//                midpointCoord2 = midpoint(point.coordinate, segment.rightCoordinate)
//
//            } else if let point = intersectionGeometry2 as? Point, let segment = intersectionGeometry1 as? Segment {
//
//                /// Since we don't know which end of the segment is sequentially next to the point, we add both midpoints
//                midpointCoord1 = midpoint(point.coordinate, segment.leftCoordinate)
//                midpointCoord2 = midpoint(point.coordinate, segment.rightCoordinate)
//
//            } else if let segment1 = intersectionGeometry1 as? Segment, let segment2 = intersectionGeometry2 as? Segment {
//
//                /// Both line segments lie on a straight line.
//                /// The midpoint of interest lies either (1) between the leftCoordinate of the first and the rightCoordinate of the second or
//                /// (2) the rightCoordinate of the first and the leftCoordinate of the second.  We add both midpoints.
//                midpointCoord1 = midpoint(segment1.leftCoordinate, segment2.rightCoordinate)
//                midpointCoord2 = midpoint(segment1.rightCoordinate, segment2.leftCoordinate)
//
//            }
//
//            if let midpointCoord1 = midpointCoord1 { midpointCoordinates.append(midpointCoord1) }
//            if let midpointCoord2 = midpointCoord2 { midpointCoordinates.append(midpointCoord2) }
//        }
//
//        /// The midpoints have all been generated.  Check whether each is inside or outside of the linear ring.
//
//        for coord in midpointCoordinates {
//
//            let pointRelatedToResult = relatedTo(coord, linearRing)
//
//            if pointRelatedToResult.firstInteriorTouchesSecondInterior > .empty {
//                relatedToResult.firstInteriorTouchesSecondInterior = pointRelatedToResult.firstInteriorTouchesSecondInterior
//            }
//
//            if pointRelatedToResult.firstBoundaryTouchesSecondInterior > .empty {
//                relatedToResult.firstBoundaryTouchesSecondInterior = pointRelatedToResult.firstBoundaryTouchesSecondInterior
//            }
//
//            if pointRelatedToResult.firstInteriorTouchesSecondExterior > .empty {
//                relatedToResult.firstInteriorTouchesSecondExterior = pointRelatedToResult.firstInteriorTouchesSecondExterior
//            }
//
//            if pointRelatedToResult.firstBoundaryTouchesSecondExterior > .empty {
//                relatedToResult.firstBoundaryTouchesSecondExterior = pointRelatedToResult.firstBoundaryTouchesSecondExterior
//            }
//
//        }
//
//        /// Return
//
//        return relatedToResult
//    }
//
//    /// Assume here that the polygon is a simple polygon with no holes, just a single simple boundary.
//    /// The leftCoordinateBoundaryPoint and rightCoordinateBoundaryPoint flags apply to the segment.
//    fileprivate static func relatedTo(_ segment: Segment, _ simplePolygon: Polygon, leftCoordinateBoundaryPoint: Bool = false, rightCoordinateBoundaryPoint: Bool = false) -> RelatedTo {
//
//        var relatedToResult = RelatedTo()
//
//        guard let polygonBoundary = simplePolygon.boundary() as? GeometryCollection,
//            polygonBoundary.count > 0,
//            let mainPolygon = polygonBoundary[0] as? LinearRing,
//            mainPolygon.count > 0 else {
//                return relatedToResult
//        }
//
//        /// For each line segment in the line string, check the following:
//        /// - Is all the line segment in the boundary of the polygon?  If so, set the firstTouchesSecondBoundary to .one.
//        /// - Is a > 0 length proper subset of the line segment in the boundary of the polygon?  If so, set the firstTouchesSecondBoundary to .one.
//        ///   Also, generate an ordered array of points at which the line segment touches the boundary.  (The line segment could touch the polygon boundary at
//        ///   more than one sub line segment.)  This array will include the end points of sub line segments.  From this array generate a second array of the
//        ///   midpoints.  Check whether each point in that array is inside or outside of the polygon.  If inside, set the firstTouchesSecondInterior to .one.
//        ///   If outside, set firstTouchesSecondExterior to .one.
//        /// - Does the line segment touch the polygon boundary at one or more points?  If so, set the firstTouchesSecondBoundary to .zero.
//        /// - Does either line segment endpoint touch inside the polygon?  If so, set the firstTouchesSecondInterior to .one.
//        /// - Does either line segment endpoint touch outside the polygon?  If so, set the firstTouchesSecondExterior to .one.
//        /// - If at any point firstTouchesSecondBoundary, firstTouchesSecondInterior, and firstTouchesSecondExterior are all .one, then stop and return.
//        ///
//        /// Also, add functions to RelatedTo like isInside, isOutside, isInBoundary.
//
//        /// Array of geometries at which the segment intersects the polygon boundary
//        var intersectionGeometries = [Geometry]()
//
//        /// Do a first pass to get the intersections of the line segment and the polygon.
//        /// The point here is to get the boundary relationships.
//        /// TODO: This code may be a little rough. Refine later as needed.
//        for firstCoordIndex in 0..<mainPolygon.count - 1 {
//            let firstCoord  = mainPolygon[firstCoordIndex]
//            let secondCoord = mainPolygon[firstCoordIndex + 1]
//            let segment2 = Segment(left: firstCoord, right: secondCoord)
//
//            /// Get the relationship between two segments
//            let lineSegmentIntersection = intersection(segment: segment, other: segment2)
//
//            /// If the two segments intersect, set boundary properties
//            if let intersectionGeometry = lineSegmentIntersection.geometry {
//                /// Append the new geometry to the geometry array, only if the geometry does not currently exist in the array
//                let matchingGeometries = intersectionGeometries.filter{
//                    if ($0 as? Point) == (intersectionGeometry as? Point) {
//                        return true
//                    }
//                    return false
//                }
//                if matchingGeometries.count == 0 {
//                    intersectionGeometries.append(intersectionGeometry)
//                }
//
//                if intersectionGeometry.dimension == .one {
//                    relatedToResult.firstInteriorTouchesSecondBoundary = .one
//                } else if intersectionGeometry.dimension == .zero {
//                    if lineSegmentIntersection.firstSegmentFirstBoundaryLocation == .onInterior || lineSegmentIntersection.firstSegmentFirstBoundaryLocation == .onBoundary {
//                        if leftCoordinateBoundaryPoint {
//                            relatedToResult.firstBoundaryTouchesSecondBoundary = .zero
//                        } else {
//                            if relatedToResult.firstInteriorTouchesSecondBoundary == .empty { relatedToResult.firstInteriorTouchesSecondBoundary = .zero }
//                        }
//                    } else if lineSegmentIntersection.firstSegmentSecondBoundaryLocation == .onInterior || lineSegmentIntersection.firstSegmentSecondBoundaryLocation == .onBoundary {
//                        if rightCoordinateBoundaryPoint {
//                            relatedToResult.firstBoundaryTouchesSecondBoundary = .zero
//                        } else {
//                            if relatedToResult.firstInteriorTouchesSecondBoundary == .empty { relatedToResult.firstInteriorTouchesSecondBoundary = .zero }
//                        }
//                    } else if lineSegmentIntersection.secondSegmentFirstBoundaryLocation == .onInterior || lineSegmentIntersection.secondSegmentSecondBoundaryLocation == .onInterior || lineSegmentIntersection.interiorsTouchAtPoint {
//                        if relatedToResult.firstInteriorTouchesSecondBoundary == .empty { relatedToResult.firstInteriorTouchesSecondBoundary = .zero }
//                    }
//                }
//            }
//        }
//
//        /// Get the relationship of the first coordinate of the line segment to the polygon.
//        /// Note that the left coordinate has no boundary.
//        let relatedToResultCoordinate1 = relatedTo(segment.leftCoordinate, simplePolygon)
//
//        if relatedToResultCoordinate1.firstInteriorTouchesSecondInterior > .empty {
//            relatedToResult.firstInteriorTouchesSecondInterior = .one
//            relatedToResult.firstBoundaryTouchesSecondInterior = .zero
//        }
//
//        if relatedToResultCoordinate1.firstInteriorTouchesSecondExterior > .empty {
//            relatedToResult.firstInteriorTouchesSecondExterior = .one
//            relatedToResult.firstBoundaryTouchesSecondExterior = .zero
//        }
//
//        /// Get the relationship of the second coordinate of the line segment to the polygon.
//        /// Note that the right coordinate has no boundary.
//        let relatedToResultCoordinate2 = relatedTo(segment.rightCoordinate, simplePolygon)
//
//        if relatedToResultCoordinate2.firstInteriorTouchesSecondInterior > .empty {
//            relatedToResult.firstInteriorTouchesSecondInterior = .one
//            relatedToResult.firstBoundaryTouchesSecondInterior = .zero
//        }
//
//        if relatedToResultCoordinate2.firstInteriorTouchesSecondExterior > .empty {
//            relatedToResult.firstInteriorTouchesSecondExterior = .one
//            relatedToResult.firstBoundaryTouchesSecondExterior = .zero
//        }
//
//        /// Check the cases where no further work is needed.
//        if (relatedToResult.firstTouchesSecondBoundary == .one && relatedToResult.firstTouchesSecondInterior == .one && relatedToResult.firstTouchesSecondExterior == .one) ||
//            (relatedToResult.firstTouchesSecondBoundary == .empty) ||
//            (intersectionGeometries.count <= 1) {
//            return relatedToResult
//        }
//
//        /// TODO: This section needs more work.  It catches more of the edge cases where the line segment intersects the polygon multiple times.
//        /// Check the case where the line segment interior lies on the interior or exterior of the polygon.  This is why we have been collecting the geometries.
//        /// Do the following:
//        /// - Generate an array of the midpoints of the consecutive geometries.
//        /// - Check whether each point in that array is inside or outside of the polygon.
//        ///   If inside, set the firstTouchesSecondInterior to .one.
//        ///   If outside, set firstTouchesSecondExterior to .one.
//        ///
//        /// Note that this algorithm can likely be made better in the cases where two midpoints are created rather than just one.
//
//        guard intersectionGeometries.count >= 2 else { return relatedToResult }
//
//        var midpointCoordinates = [Coordinate]()
//
//        for firstGeometryIndex in 0..<intersectionGeometries.count - 1 {
//            let intersectionGeometry1 = intersectionGeometries[firstGeometryIndex]
//            let intersectionGeometry2 = intersectionGeometries[firstGeometryIndex + 1]
//
//            var midpointCoord1: Coordinate?
//            var midpointCoord2: Coordinate?
//            if let point1 = intersectionGeometry1 as? Point, let point2 = intersectionGeometry2 as? Point {
//
//                midpointCoord1 = midpoint(point1.coordinate, point2.coordinate)
//
//            } else if let point = intersectionGeometry1 as? Point, let segment = intersectionGeometry2 as? Segment {
//
//                /// Since we don't know which end of the segment is sequentially next to the point, we add both midpoints
//                midpointCoord1 = midpoint(point.coordinate, segment.leftCoordinate)
//                midpointCoord2 = midpoint(point.coordinate, segment.rightCoordinate)
//
//            } else if let point = intersectionGeometry2 as? Point, let segment = intersectionGeometry1 as? Segment {
//
//                /// Since we don't know which end of the segment is sequentially next to the point, we add both midpoints
//                midpointCoord1 = midpoint(point.coordinate, segment.leftCoordinate)
//                midpointCoord2 = midpoint(point.coordinate, segment.rightCoordinate)
//
//            } else if let segment1 = intersectionGeometry1 as? Segment, let segment2 = intersectionGeometry2 as? Segment {
//
//                /// Both line segments lie on a straight line.
//                /// The midpoint of interest lies either (1) between the leftCoordinate of the first and the rightCoordinate of the second or
//                /// (2) the rightCoordinate of the first and the leftCoordinate of the second.  We add both midpoints.
//                midpointCoord1 = midpoint(segment1.leftCoordinate, segment2.rightCoordinate)
//                midpointCoord2 = midpoint(segment1.rightCoordinate, segment2.leftCoordinate)
//
//            }
//
//            if let midpointCoord1 = midpointCoord1 { midpointCoordinates.append(midpointCoord1) }
//            if let midpointCoord2 = midpointCoord2 { midpointCoordinates.append(midpointCoord2) }
//        }
//
//        /// The midpoints have all been generated.  Check whether each is inside or outside of the polygon.
//
//        for coord in midpointCoordinates {
//
//            let pointRelatedToResult = relatedTo(coord, simplePolygon)
//
//            if pointRelatedToResult.firstInteriorTouchesSecondInterior > .empty {
//                relatedToResult.firstInteriorTouchesSecondInterior = pointRelatedToResult.firstInteriorTouchesSecondInterior
//            }
//
//            if pointRelatedToResult.firstBoundaryTouchesSecondInterior > .empty {
//                relatedToResult.firstBoundaryTouchesSecondInterior = pointRelatedToResult.firstBoundaryTouchesSecondInterior
//            }
//
//            if pointRelatedToResult.firstInteriorTouchesSecondExterior > .empty {
//                relatedToResult.firstInteriorTouchesSecondExterior = pointRelatedToResult.firstInteriorTouchesSecondExterior
//            }
//
//            if pointRelatedToResult.firstBoundaryTouchesSecondExterior > .empty {
//                relatedToResult.firstBoundaryTouchesSecondExterior = pointRelatedToResult.firstBoundaryTouchesSecondExterior
//            }
//
//        }
//
//        /// Return
//
//        return relatedToResult
//    }
//
//    /// This is very similar to the simple polygon case below.
//    fileprivate static func relatedTo(_ lineString: LineString, _ linearRing: LinearRing) -> RelatedTo {
//
//        let polygon = Polygon(linearRing)
//
//        return relatedTo(lineString, polygon)
//    }
//
//    /// Assume here that the polygon is a simple polygon with no holes, just a single simple boundary.
//    fileprivate static func relatedTo(_ lineString: LineString, _ simplePolygon: Polygon) -> RelatedTo {
//
//        var relatedToResult = RelatedTo()
//
//        guard let polygonBoundary = simplePolygon.boundary() as? GeometryCollection,
//            polygonBoundary.count > 0,
//            let outerLinearRing = polygonBoundary[0] as? LinearRing,
//            outerLinearRing.count > 0 else {
//                return relatedToResult
//        }
//
//        /// Check the relationships between each line segment of the line string and the simple polygon
//
//        for firstCoordIndex in 0..<lineString.count - 1 {
//
//            let firstCoord  = lineString[firstCoordIndex]
//            let secondCoord = lineString[firstCoordIndex + 1]
//            let segment = Segment(left: firstCoord, right: secondCoord)
//            var leftCoordinateBoundaryPoint = false
//            var rightCoordinateBoundaryPoint = false
//            if firstCoordIndex == 0 {
//                leftCoordinateBoundaryPoint = true
//            } else if firstCoordIndex == lineString.count - 2 {
//                rightCoordinateBoundaryPoint = true
//            }
//
//            let segmentRelatedToResult = relatedTo(segment, simplePolygon, leftCoordinateBoundaryPoint: leftCoordinateBoundaryPoint, rightCoordinateBoundaryPoint: rightCoordinateBoundaryPoint)
//
//            if segmentRelatedToResult.firstInteriorTouchesSecondInterior > relatedToResult.firstInteriorTouchesSecondInterior {
//                relatedToResult.firstInteriorTouchesSecondInterior = segmentRelatedToResult.firstInteriorTouchesSecondInterior
//            }
//
//            if segmentRelatedToResult.firstBoundaryTouchesSecondInterior > relatedToResult.firstBoundaryTouchesSecondInterior {
//                relatedToResult.firstBoundaryTouchesSecondInterior = segmentRelatedToResult.firstBoundaryTouchesSecondInterior
//            }
//
//            if segmentRelatedToResult.firstInteriorTouchesSecondBoundary > relatedToResult.firstInteriorTouchesSecondBoundary {
//                relatedToResult.firstInteriorTouchesSecondBoundary = segmentRelatedToResult.firstInteriorTouchesSecondBoundary
//            }
//
//            if segmentRelatedToResult.firstBoundaryTouchesSecondBoundary > relatedToResult.firstBoundaryTouchesSecondBoundary {
//                relatedToResult.firstBoundaryTouchesSecondBoundary = segmentRelatedToResult.firstBoundaryTouchesSecondBoundary
//            }
//
//            if segmentRelatedToResult.firstInteriorTouchesSecondExterior > relatedToResult.firstInteriorTouchesSecondExterior {
//                relatedToResult.firstInteriorTouchesSecondExterior = segmentRelatedToResult.firstInteriorTouchesSecondExterior
//            }
//
//            if segmentRelatedToResult.firstBoundaryTouchesSecondExterior > relatedToResult.firstBoundaryTouchesSecondExterior {
//                relatedToResult.firstBoundaryTouchesSecondExterior = segmentRelatedToResult.firstBoundaryTouchesSecondExterior
//            }
//
//        }
//
//        return relatedToResult
//    }
//
//    /// These relationships will most often be used when relating parts of a polygon to one another.
//    fileprivate static func relatedTo(_ linearRing1: LinearRing, _ linearRing2: LinearRing) -> RelatedTo {
//
//        var relatedToResult = RelatedTo()
//
//        /// Check the relationships between each line segment of the linear rings
//
//        for firstCoordIndex in 0..<linearRing1.count - 1 {
//
//            let firstCoord  = linearRing1[firstCoordIndex]
//            let secondCoord = linearRing1[firstCoordIndex + 1]
//            let segment = Segment(left: firstCoord, right: secondCoord)
//
//            let segmentRelatedToResult = relatedTo(segment, linearRing2)
//
//            if segmentRelatedToResult.firstInteriorTouchesSecondInterior > relatedToResult.firstInteriorTouchesSecondInterior {
//                relatedToResult.firstInteriorTouchesSecondInterior = segmentRelatedToResult.firstInteriorTouchesSecondInterior
//            }
//
//            if segmentRelatedToResult.firstInteriorTouchesSecondExterior > relatedToResult.firstInteriorTouchesSecondExterior {
//                relatedToResult.firstInteriorTouchesSecondExterior = segmentRelatedToResult.firstInteriorTouchesSecondExterior
//            }
//
//            if segmentRelatedToResult.firstExteriorTouchesSecondInterior > relatedToResult.firstExteriorTouchesSecondInterior {
//                relatedToResult.firstExteriorTouchesSecondInterior = segmentRelatedToResult.firstExteriorTouchesSecondInterior
//            }
//
//        }
//
//        return relatedToResult
//    }
//
//    /// Assume here that the polygon is a simple polygon with no holes, just a single simple boundary.
//    fileprivate static func relatedTo(_ linearRing: LinearRing, _ simplePolygon: Polygon) -> RelatedTo {
//
//        var relatedToResult = RelatedTo()
//
//        /// Get the polygon boundary
//        guard let polygonBoundary = simplePolygon.boundary() as? GeometryCollection,
//            polygonBoundary.count > 0,
//            let outerLinearRing = polygonBoundary[0] as? LinearRing,
//            outerLinearRing.count > 0 else {
//                return relatedToResult
//        }
//
//        /// Check the relationships between each line segment of the linear ring and the simple polygon
//
//        for firstCoordIndex in 0..<linearRing.count - 1 {
//
//            let firstCoord  = linearRing[firstCoordIndex]
//            let secondCoord = linearRing[firstCoordIndex + 1]
//            let segment = Segment(left: firstCoord, right: secondCoord)
//
//            let segmentRelatedToResult = relatedTo(segment, simplePolygon)
//
//            if segmentRelatedToResult.firstInteriorTouchesSecondInterior > relatedToResult.firstInteriorTouchesSecondInterior {
//                relatedToResult.firstInteriorTouchesSecondInterior = segmentRelatedToResult.firstInteriorTouchesSecondInterior
//            }
//
//            if segmentRelatedToResult.firstInteriorTouchesSecondBoundary > relatedToResult.firstInteriorTouchesSecondBoundary {
//                relatedToResult.firstInteriorTouchesSecondBoundary = segmentRelatedToResult.firstInteriorTouchesSecondBoundary
//            }
//
//            if segmentRelatedToResult.firstInteriorTouchesSecondExterior > relatedToResult.firstInteriorTouchesSecondExterior {
//                relatedToResult.firstInteriorTouchesSecondExterior = segmentRelatedToResult.firstInteriorTouchesSecondExterior
//            }
//
//            if segmentRelatedToResult.firstExteriorTouchesSecondInterior > relatedToResult.firstExteriorTouchesSecondInterior {
//                relatedToResult.firstExteriorTouchesSecondInterior = segmentRelatedToResult.firstExteriorTouchesSecondInterior
//            }
//
//            if segmentRelatedToResult.firstExteriorTouchesSecondBoundary > relatedToResult.firstExteriorTouchesSecondBoundary {
//                relatedToResult.firstExteriorTouchesSecondBoundary = segmentRelatedToResult.firstExteriorTouchesSecondBoundary
//            }
//
//        }
//
//        return relatedToResult
//    }
//
//    /// These relationships will most often be used when relating parts of a polygon to one another.
//    fileprivate static func relatedTo(_ linearRing1: LinearRing, _ linearRingArray: [LinearRing]) -> RelatedTo {
//
//        var relatedToResult = RelatedTo()
//
//        /// Check the relationships between the linear ring and each linear ring of the array
//
//        for linearRing2 in linearRingArray {
//
//            let relatedToRings = relatedTo(linearRing1, linearRing2)
//
//            if relatedToRings.firstInteriorTouchesSecondInterior > relatedToResult.firstInteriorTouchesSecondInterior {
//                relatedToResult.firstInteriorTouchesSecondInterior = relatedToRings.firstInteriorTouchesSecondInterior
//            }
//
//            if relatedToRings.firstInteriorTouchesSecondBoundary > relatedToResult.firstInteriorTouchesSecondBoundary {
//                relatedToResult.firstInteriorTouchesSecondBoundary = relatedToRings.firstInteriorTouchesSecondBoundary
//            }
//
//            if relatedToRings.firstExteriorTouchesSecondInterior > relatedToResult.firstExteriorTouchesSecondInterior {
//                relatedToResult.firstExteriorTouchesSecondInterior = relatedToRings.firstExteriorTouchesSecondInterior
//            }
//
//            if relatedToRings.firstExteriorTouchesSecondBoundary > relatedToResult.firstExteriorTouchesSecondBoundary {
//                relatedToResult.firstExteriorTouchesSecondBoundary = relatedToRings.firstExteriorTouchesSecondBoundary
//            }
//
//        }
//
//        return relatedToResult
//    }
//
//    /// These relationships will most often be used when relating parts of a polygon to one another.
//    fileprivate static func relatedTo(_ linearRingArray1: [LinearRing], _ linearRingArray2: [LinearRing]) -> RelatedTo {
//
//        var relatedToResult = RelatedTo()
//
//        /// Check the relationships between the linear ring and each linear ring of the array
//
//        for linearRing1 in linearRingArray1 {
//
//            let relatedToRings = relatedTo(linearRing1, linearRingArray2)
//
//            if relatedToRings.firstInteriorTouchesSecondInterior > relatedToResult.firstInteriorTouchesSecondInterior {
//                relatedToResult.firstInteriorTouchesSecondInterior = relatedToRings.firstInteriorTouchesSecondInterior
//            }
//
//            if relatedToRings.firstInteriorTouchesSecondBoundary > relatedToResult.firstInteriorTouchesSecondBoundary {
//                relatedToResult.firstInteriorTouchesSecondBoundary = relatedToRings.firstInteriorTouchesSecondBoundary
//            }
//
//            if relatedToRings.firstExteriorTouchesSecondInterior > relatedToResult.firstExteriorTouchesSecondInterior {
//                relatedToResult.firstExteriorTouchesSecondInterior = relatedToRings.firstExteriorTouchesSecondInterior
//            }
//
//            if relatedToRings.firstExteriorTouchesSecondBoundary > relatedToResult.firstExteriorTouchesSecondBoundary {
//                relatedToResult.firstExteriorTouchesSecondBoundary = relatedToRings.firstExteriorTouchesSecondBoundary
//            }
//
//        }
//
//        return relatedToResult
//    }
//
//    /// Assume here that both polygons are simple polygons with no holes, just a single simple boundary.
//    fileprivate static func relatedTo(_ simplePolygon1: Polygon, _ simplePolygon2: Polygon) -> RelatedTo {
//
//        var relatedToResult = RelatedTo()
//
//        guard let polygonBoundary1 = simplePolygon1.boundary() as? MultiLineString,
//            polygonBoundary1.count > 0,
//            let mainPolygon1 = polygonBoundary1.first,
//            mainPolygon1.count > 0 else {
//                return relatedToResult
//        }
//
//        guard let polygonBoundary2 = simplePolygon2.boundary() as? MultiLineString,
//            polygonBoundary2.count > 0,
//            let mainPolygon2 = polygonBoundary2.first,
//            mainPolygon2.count > 0 else {
//                return relatedToResult
//        }
//
//        /// Check whether the first polygon boundary is completely contained in the second polygon boundary
//        let reducedPB1 = reduce(polygonBoundary1)
//        let reducedPB2 = reduce(polygonBoundary2)
//        if subset(reducedPB1, reducedPB2) {
//            relatedToResult.firstBoundaryTouchesSecondBoundary = .one
//            return relatedToResult
//        }
//
//        /// Check the relationships between each line segment of the first polygon boundary and the second polygon
//
//        for lineString in polygonBoundary1 {
//            for firstCoordIndex in 0..<lineString.count - 1 {
//
//                let firstCoord  = lineString[firstCoordIndex]
//                let secondCoord = lineString[firstCoordIndex + 1]
//                let segment = Segment(left: firstCoord, right: secondCoord)
//
//                let segmentRelatedToResult = relatedTo(segment, simplePolygon2)
//
//                if segmentRelatedToResult.firstInteriorTouchesSecondInterior > relatedToResult.firstInteriorTouchesSecondInterior {
//                    relatedToResult.firstInteriorTouchesSecondInterior = segmentRelatedToResult.firstInteriorTouchesSecondInterior
//                }
//
//                if segmentRelatedToResult.firstBoundaryTouchesSecondInterior > relatedToResult.firstBoundaryTouchesSecondInterior {
//                    relatedToResult.firstBoundaryTouchesSecondInterior = segmentRelatedToResult.firstBoundaryTouchesSecondInterior
//                }
//
//                if segmentRelatedToResult.firstInteriorTouchesSecondBoundary > relatedToResult.firstInteriorTouchesSecondBoundary {
//                    relatedToResult.firstInteriorTouchesSecondBoundary = segmentRelatedToResult.firstInteriorTouchesSecondBoundary
//                }
//
//                if segmentRelatedToResult.firstBoundaryTouchesSecondBoundary > relatedToResult.firstBoundaryTouchesSecondBoundary {
//                    relatedToResult.firstBoundaryTouchesSecondBoundary = segmentRelatedToResult.firstBoundaryTouchesSecondBoundary
//                }
//
//                if segmentRelatedToResult.firstInteriorTouchesSecondExterior > relatedToResult.firstInteriorTouchesSecondExterior {
//                    relatedToResult.firstInteriorTouchesSecondExterior = segmentRelatedToResult.firstInteriorTouchesSecondExterior
//                }
//
//                if segmentRelatedToResult.firstBoundaryTouchesSecondExterior > relatedToResult.firstBoundaryTouchesSecondExterior {
//                    relatedToResult.firstBoundaryTouchesSecondExterior = segmentRelatedToResult.firstBoundaryTouchesSecondExterior
//                }
//            }
//        }
//
//        return relatedToResult
//    }
//
//    fileprivate static func disjoint(_ polygon1: Polygon, _ polygon2: Polygon) -> Bool {
//
//        /// Get the relationship of the outer ring of the first polygon to the second polygon.
//        let outerRing1ToSecondPolygonMatrix = generateIntersection(polygon1.outerRing, polygon2)
//
//        /// Check whether there is any overlap between the first outer ring and the second polygon.
//        if outerRing1ToSecondPolygonMatrix[.interior, .interior] > .empty || outerRing1ToSecondPolygonMatrix[.interior, .boundary] > .empty ||
//            outerRing1ToSecondPolygonMatrix[.boundary, .interior] > .empty || outerRing1ToSecondPolygonMatrix[.boundary, .boundary] > .empty {
//            return false
//        }
//
//        /// Get the relationship of the outer ring of the second polygon to the first polygon.
//        let outerRing2ToFirstPolygonMatrix = generateIntersection(polygon2.outerRing, polygon1)
//
//        /// Check whether there is any overlap between the second outer ring and the first polygon.
//        if outerRing2ToFirstPolygonMatrix[.interior, .interior] > .empty || outerRing2ToFirstPolygonMatrix[.interior, .boundary] > .empty ||
//            outerRing2ToFirstPolygonMatrix[.boundary, .interior] > .empty || outerRing2ToFirstPolygonMatrix[.boundary, .boundary] > .empty {
//            return false
//        }
//
//        /// No overlaps
//        return true
//    }
//
//    /// Assume here that both polygons are full polygons with holes
//    fileprivate static func relatedToFull(_ polygon1: Polygon, _ polygon2: Polygon) -> RelatedTo {
//
//        var relatedToResult = RelatedTo()
//
//        let outerRing1 = polygon1.outerRing
//        let innerRings1 = polygon1.innerRings
//        let outerRing2 = polygon2.outerRing
//        let innerRings2 = polygon2.innerRings
//
//        /// Check if the two polygons are disjoint.
//        if disjoint(polygon1, polygon2) {
//            relatedToResult.firstInteriorTouchesSecondExterior = .two
//            relatedToResult.firstBoundaryTouchesSecondExterior = .one
//            relatedToResult.firstExteriorTouchesSecondInterior = .two
//            relatedToResult.firstExteriorTouchesSecondBoundary = .one
//            return relatedToResult
//        }
//
//        /// Get the relationship between the two outer linear rings and determine if they are the same.
//        /// If the two outer linear rings are the same, then the holes need to be examined for equality.
//        let relatedToOuterRings = relatedTo(outerRing1, outerRing2)
//
//        if areLinearRingsIdentical(relatedToOuterRings) {
//
//            relatedToResult.firstInteriorTouchesSecondInterior = .two
//            relatedToResult.firstBoundaryTouchesSecondBoundary = .one
//
//            if innerRings1.count == 0 && innerRings2.count == 0 {
//                /// No inner rings.  Do nothing.
//                return relatedToResult
//            } else if innerRings1.count == 0 && innerRings2.count > 0 {
//                relatedToResult.firstInteriorTouchesSecondBoundary = .one
//                relatedToResult.firstInteriorTouchesSecondExterior = .two
//                return relatedToResult
//            } else if innerRings1.count > 0 && innerRings2.count == 0 {
//                relatedToResult.firstBoundaryTouchesSecondInterior = .one
//                return relatedToResult
//            }
//
//            /// To reach this point, innerRings1.count > 0 && innerRings2.count > 0
//
//            let relatedToInnerRings = relatedTo(innerRings1, innerRings2)
//
//            if matchesSubset(innerRings1, innerRings2) {
//
//                if countIdentical(innerRings1, innerRings2) {
//                    /// The two sets of inner rings are identical.  Do nothing.
//                } else {
//                    /// innerRings1.count < innerRings2.count
//                    relatedToResult.firstInteriorTouchesSecondBoundary = .one
//                    relatedToResult.firstInteriorTouchesSecondExterior = .two
//                }
//            } else if matchesSubset(innerRings2, innerRings1) {
//                /// innerRings2.count < innerRings1.count
//                relatedToResult.firstBoundaryTouchesSecondInterior = .one
//                relatedToResult.firstExteriorTouchesSecondInterior = .two
//            } else {
//                /// Two different sets of inner rings that are both not empty
//                relatedToResult.firstInteriorTouchesSecondBoundary = relatedToInnerRings.firstExteriorTouchesSecondBoundary
//                relatedToResult.firstInteriorTouchesSecondExterior = relatedToInnerRings.firstExteriorTouchesSecondInterior
//                relatedToResult.firstBoundaryTouchesSecondInterior = relatedToInnerRings.firstBoundaryTouchesSecondExterior
//                relatedToResult.firstBoundaryTouchesSecondExterior = relatedToInnerRings.firstBoundaryTouchesSecondInterior
//                relatedToResult.firstExteriorTouchesSecondInterior = relatedToInnerRings.firstInteriorTouchesSecondExterior
//                relatedToResult.firstExteriorTouchesSecondBoundary = relatedToInnerRings.firstInteriorTouchesSecondBoundary
//            }
//
//            return relatedToResult
//        }
//
//        /// The two outer rings are different.
//        /// TODO: This might be a general solution, so the specialized case above where the outer rings
//        /// are the same may not be needed.  Check that.
//
//        /// Get the relationship of the outer ring of the first polygon to the second polygon.
//        let outerRing1ToSecondPolygonMatrix = generateIntersection(polygon1.outerRing, polygon2)
//
//        /// Get the relationship of the outer ring of the second polygon to the first polygon.
//        let outerRing2ToFirstPolygonMatrix = generateIntersection(polygon2.outerRing, polygon1)
//
//        if outerRing1ToSecondPolygonMatrix[.interior, .interior] > .empty {
//            relatedToResult.firstInteriorTouchesSecondInterior = .two
//            relatedToResult.firstBoundaryTouchesSecondInterior = .one
//            if outerRing1ToSecondPolygonMatrix[.interior, .exterior] > .empty {
//                relatedToResult.firstInteriorTouchesSecondBoundary = .one
//            }
//        }
//
//        if outerRing2ToFirstPolygonMatrix[.interior, .interior] > .empty {
//            relatedToResult.firstInteriorTouchesSecondInterior = .two
//            relatedToResult.firstInteriorTouchesSecondBoundary = .one
//            if outerRing2ToFirstPolygonMatrix[.interior, .exterior] > .empty {
//                relatedToResult.firstBoundaryTouchesSecondInterior = .one
//            }
//        }
//
//        if outerRing1ToSecondPolygonMatrix[.interior, .boundary] > .empty || outerRing2ToFirstPolygonMatrix[.interior, .boundary] > .empty {
//            relatedToResult.firstBoundaryTouchesSecondBoundary = Swift.max(outerRing1ToSecondPolygonMatrix[.interior, .boundary], outerRing2ToFirstPolygonMatrix[.interior, .boundary])
//        }
//
//        if outerRing1ToSecondPolygonMatrix[.interior, .exterior] > .empty {
//            relatedToResult.firstInteriorTouchesSecondExterior = .two
//        }
//
//        if outerRing1ToSecondPolygonMatrix[.interior, .exterior] > .empty {
//            relatedToResult.firstBoundaryTouchesSecondExterior = .one
//        }
//
//        if outerRing2ToFirstPolygonMatrix[.interior, .exterior] > .empty {
//            relatedToResult.firstExteriorTouchesSecondInterior = .two
//            relatedToResult.firstExteriorTouchesSecondBoundary = .one
//        }
//
//        return relatedToResult
//    }
//
//    /// Get the holes for a polygon.  This will be an array of linear rings.
//    fileprivate static func holes(_ polygon: Polygon) -> [LinearRing] {
//
//        guard let polygonBoundary = polygon.boundary() as? GeometryCollection,
//            polygonBoundary.count > 1 else {
//                return []
//        }
//
//        var innerLinearRings = [LinearRing]()
//        for index in 1..<polygonBoundary.count {
//            guard let linearRing = polygonBoundary[index] as? LinearRing else { return [] }
//            innerLinearRings.append(linearRing)
//        }
//
//        return innerLinearRings
//    }
//
//    /// It is assumed that a RelatedTo structure has been generated for two linear rings,
//    /// and now we want to know if the two match.
//    fileprivate static func areLinearRingsIdentical(_ relatedToLinearRings: RelatedTo) -> Bool {
//        return relatedToLinearRings.firstTouchesSecondInterior == .one && relatedToLinearRings.firstTouchesSecondExterior == .empty
//    }
//
//    /// It is assumed that a RelatedTo structure has been generated for two polgyons,
//    /// and now we want to know if the main boundaries of the polygons are match.
//    fileprivate static func areMainPolygonBoundariesIdentical(_ relatedToPolygons: RelatedTo) -> Bool {
//        return relatedToPolygons.firstTouchesSecondInterior == .empty && relatedToPolygons.firstTouchesSecondExterior == .empty
//    }
//
//    fileprivate static func areSimplePolygonsIdentical(_ simplePolygon1: Polygon, _ simplePolygon2: Polygon) -> Bool {
//        let relatedToPolygons = relatedTo(simplePolygon1, simplePolygon2)
//        return areMainPolygonBoundariesIdentical(relatedToPolygons)
//    }
//
//    fileprivate static func countIdentical(_ linearRingArray1: [LinearRing], _ linearRingArray2: [LinearRing]) -> Bool {
//
//        return linearRingArray1.count == linearRingArray2.count
//    }
//
//    /// Does the linear ring match any of the linear rings in the array?
//    fileprivate static func matchesOne(_ linearRing1: LinearRing, _ linearRingArray: [LinearRing]) -> Bool {
//
//        for linearRing2 in linearRingArray {
//
//            let relatedToRings = relatedTo(linearRing1, linearRing2)
//
//            if areLinearRingsIdentical(relatedToRings) {
//                return true
//            }
//        }
//
//        return false
//    }
//
//    /// Does the first array of linear rings match a subset of the linear rings in the second array?
//    fileprivate static func matchesSubset(_ linearRingArray1: [LinearRing], _ linearRingArray2: [LinearRing]) -> Bool {
//
//        for linearRing1 in linearRingArray1 {
//
//            if matchesOne(linearRing1, linearRingArray2) {
//                continue
//            } else {
//                return false
//            }
//        }
//
//        return true
//    }
//
//    /// Does the simple polygon match any of the simple polygons in the array?
//    fileprivate static func matchesOne(_ simplePolygon1: Polygon, _ simplePolygonArray: [Polygon]) -> Bool {
//
//        for simplePolygon2 in simplePolygonArray {
//
//            if areSimplePolygonsIdentical(simplePolygon1, simplePolygon2) {
//                return true
//            }
//        }
//
//        return false
//    }
//
//    /// Does the first array of simple polygons match a subset of the simple polygons in the second array?
//    fileprivate static func matchesSubset(_ simplePolygonArray1: [Polygon], _ simplePolygonArray2: [Polygon]) -> Bool {
//
//        for simplePolygon1 in simplePolygonArray1 {
//
//            if matchesOne(simplePolygon1, simplePolygonArray2) {
//                continue
//            } else {
//                return false
//            }
//        }
//
//        return true
//    }

///
/// - Returns: a MultiPoint object that is the unique set of points that intersect the line string
///
fileprivate func generateIntersection(_ points: MultiPoint, _ lineString: LineString) -> Geometry {

    /// Simplify each geometry first
    let simplifiedMultiPoint = points.simplify(tolerance: 1.0)
    let simplifiedLineString = lineString.simplify(tolerance: 1.0)

    /// Check the intersection of each point with the line string.
    /// The returned value will be a MultiPoint, which may be empty.

    var multiPointGeometry = MultiPoint(precision: Floating(), coordinateSystem: Cartesian())

    for tempPoint in simplifiedMultiPoint {

        guard let point = generateIntersection(tempPoint, simplifiedLineString) as? Point else {
            continue
        }

        multiPointGeometry.append(point)
    }

    return multiPointGeometry
}

///
/// - Returns: a MultiPoint object that is the unique set of points that intersect the linear ring
///
fileprivate func generateIntersection(_ points: MultiPoint, _ linearRing: LinearRing) -> Geometry {

    /// Simplify each geometry first
    let simplifiedMultiPoint = points.simplify(tolerance: 1.0)
    let simplifiedLinearRing = linearRing.simplify(tolerance: 1.0)

    /// Check the intersection of each point with the linear ring.
    /// The returned value will be a MultiPoint, which may be empty.

    var multiPointGeometry = MultiPoint(precision: Floating(), coordinateSystem: Cartesian())

    for tempPoint in simplifiedMultiPoint {

        guard let point = generateIntersection(tempPoint, simplifiedLinearRing) as? Point else {
            continue
        }

        multiPointGeometry.append(point)
    }

    return multiPointGeometry
}

///
/// - Returns: a MultiPoint object that is the unique set of points that intersect the multi line string
///
fileprivate func generateIntersection(_ points: MultiPoint, _ multiLineString: MultiLineString) -> Geometry {

    /// Simplify each geometry first
    let simplifiedMultiPoint = points.simplify(tolerance: 1.0)
    let simplifiedMultiLineString = multiLineString.simplify(tolerance: 1.0)

    /// Check the intersection of each point with the multi line string.
    /// The returned value will be a MultiPoint, which may be empty.

    var multiPointGeometry = MultiPoint(precision: Floating(), coordinateSystem: Cartesian())

    for tempPoint in simplifiedMultiPoint {

        guard let point = generateIntersection(tempPoint, simplifiedMultiLineString) as? Point else {
            continue
        }

        multiPointGeometry.append(point)
    }

    return multiPointGeometry
}

//    ///
//    /// Dimension .zero and dimension .two
//    ///
//
//    fileprivate static func intersectionMatrix(from relatedTo: RelatedTo) -> IntersectionMatrix {
//
//        /// Default intersection matrix
//        var matrixIntersects = IntersectionMatrix()
//
//        matrixIntersects[.interior, .interior] = relatedTo.firstInteriorTouchesSecondInterior
//        matrixIntersects[.interior, .boundary] = relatedTo.firstInteriorTouchesSecondBoundary
//        matrixIntersects[.interior, .exterior] = relatedTo.firstInteriorTouchesSecondExterior
//
//        matrixIntersects[.boundary, .interior] = relatedTo.firstBoundaryTouchesSecondInterior
//        matrixIntersects[.boundary, .boundary] = relatedTo.firstBoundaryTouchesSecondBoundary
//        matrixIntersects[.boundary, .exterior] = relatedTo.firstBoundaryTouchesSecondExterior
//
//        matrixIntersects[.exterior, .interior] = relatedTo.firstExteriorTouchesSecondInterior
//        matrixIntersects[.exterior, .boundary] = relatedTo.firstExteriorTouchesSecondBoundary
//        matrixIntersects[.exterior, .exterior] = relatedTo.firstExteriorTouchesSecondExterior
//
//        return matrixIntersects
//    }
//
    fileprivate func generateIntersection(_ point: Point, _ polygon: Polygon) -> Geometry {

        var coordinates = [(Coordinate, Bool)]()
        coordinates.append((point.coordinate, false))

        let tempRelatedToResult = relatedTo(coordinates, polygon)

        if tempRelatedToResult.firstTouchesSecondExterior == .empty {
            return point
        }

        return GeometryCollection()
    }

    fileprivate func generateIntersection(_ point: Point, _ multipolygon: MultiPolygon) -> Geometry {

        let relatedToCoordinateMP = relatedTo((point.coordinate, false), multipolygon)

        if relatedToCoordinateMP.firstTouchesSecondExterior == .empty {
            return point
        }

        return GeometryCollection()
    }

    fileprivate func multiPointToCoordinateTupleArray(_ points: MultiPoint, _ allBoundaryPoints: Bool = false) -> [(Coordinate, Bool)] {

        var tupleArray = [(Coordinate, Bool)]()
        for point in points {
            tupleArray.append((point.coordinate, allBoundaryPoints))
        }
        return tupleArray
    }

//    fileprivate static func multiPointToCoordinateArray(_ points: MultiPoint) -> [Coordinate] {
//
//        var coordinateArray = [Coordinate]()
//        for point in points {
//            coordinateArray.append(point.coordinate)
//        }
//        return coordinateArray
//    }
//
//    fileprivate static func coordinateArrayToMultiPoint(_ coordinates: [Coordinate]) -> MultiPoint {
//
//        var multiPoint = MultiPoint(precision: Floating(), coordinateSystem: Cartesian())
//        for coordinate in coordinates {
//            let point = Point(coordinate)
//            multiPoint.append(point)
//        }
//        return multiPoint
//    }

    fileprivate func generateIntersection(_ points: MultiPoint, _ polygon: Polygon) -> Geometry {

        /// Simplify each geometry first
        let simplifiedMultiPoint = points.simplify(tolerance: 1.0)
        let simplifiedPolygon = polygon.simplify(tolerance: 1.0)

        /// Check the intersection of each point with the polygon.
        /// The returned value will be a MultiPoint, which may be empty.

        var multiPointGeometry = MultiPoint(precision: Floating(), coordinateSystem: Cartesian())

        for tempPoint in simplifiedMultiPoint {

            guard let point = generateIntersection(tempPoint, simplifiedPolygon) as? Point else {
                continue
            }

            multiPointGeometry.append(point)
        }

        return multiPointGeometry
    }

    fileprivate func generateIntersection(_ points: MultiPoint, _ multipolygon: MultiPolygon) -> Geometry {

        /// Simplify each geometry first
        let simplifiedMultiPoint = points.simplify(tolerance: 1.0)
        let simplifiedMultiPolygon = multipolygon.simplify(tolerance: 1.0)

        /// Check the intersection of each point with each polygon in the multi polygon.
        /// The returned value will be a MultiPoint, which may be empty.

        var multiPointGeometry = MultiPoint(precision: Floating(), coordinateSystem: Cartesian())

        for tempPoint in simplifiedMultiPoint {

            for polygon in simplifiedMultiPolygon {

                guard let point = generateIntersection(tempPoint, polygon) as? Point else {
                    continue
                }

                multiPointGeometry.append(point)
                break
            }
        }

        return multiPointGeometry
    }

//    ///
//    /// Dimension .one and dimesion .one
//    ///
//
//    struct LineSegmentIntersection {
//
//        var firstSegmentFirstBoundaryLocation: LocationType     // The location of the first boundary point of the first segment relative to the second segment
//        var firstSegmentSecondBoundaryLocation: LocationType    // The location of the second boundary point of the first segment relative to the second segment
//        var secondSegmentFirstBoundaryLocation: LocationType    // The location of the first boundary point of the second segment relative to the first segment
//        var secondSegmentSecondBoundaryLocation: LocationType   // The location of the second boundary point of the second segment relative to the first segment
//        var interiorsTouchAtPoint: Bool
//
//        var segmentsIntersect: Bool {
//            return  firstSegmentFirstBoundaryLocation   != .onExterior ||
//                firstSegmentSecondBoundaryLocation  != .onExterior ||
//                secondSegmentFirstBoundaryLocation  != .onExterior ||
//                secondSegmentSecondBoundaryLocation != .onExterior ||
//            interiorsTouchAtPoint
//        }
//
//        var firstSubsetOfSecond: Bool {
//            return firstSegmentFirstBoundaryLocation  != .onExterior &&
//                firstSegmentSecondBoundaryLocation != .onExterior
//        }
//
//        var geometry: Geometry?
//
//        init(sb11: LocationType = .onExterior, sb12: LocationType = .onExterior, sb21: LocationType = .onExterior, sb22: LocationType = .onExterior, interiors: Bool = false, theGeometry: Geometry? = nil) {
//            firstSegmentFirstBoundaryLocation   = sb11          /// Position of first boundary point of first segment relative to the second segment
//            firstSegmentSecondBoundaryLocation  = sb12          /// Position of second boundary point of first segment relative to the second segment
//            secondSegmentFirstBoundaryLocation  = sb21          /// Position of first boundary point of second segment relative to the first segment
//            secondSegmentSecondBoundaryLocation = sb22          /// Position of second boundary point of first segment relative to the first segment
//            interiorsTouchAtPoint               = interiors
//            geometry                            = theGeometry
//        }
//    }

    ///
    /// Check if the bounding boxes overlap for two one dimensional line ranges.
    /// The first value for each range is the minimum value and the second is the maximum value.
    ///
    fileprivate func boundingBoxesOverlap1D(range1: (Double, Double), range2: (Double, Double)) -> Bool {
        return range1.1 >= range2.0 && range2.1 >= range1.0
    }

    ///
    /// Check if the bounding boxes overlap for two line segments
    ///
    fileprivate func boundingBoxesOverlap2D(segment: Segment, other: Segment) -> Bool {
        let range1x = (Swift.min(segment.leftCoordinate.x, segment.rightCoordinate.x), Swift.max(segment.leftCoordinate.x, segment.rightCoordinate.x))
        let range1y = (Swift.min(segment.leftCoordinate.y, segment.rightCoordinate.y), Swift.max(segment.leftCoordinate.y, segment.rightCoordinate.y))
        let range2x = (Swift.min(other.leftCoordinate.x, other.rightCoordinate.x), Swift.max(other.leftCoordinate.x, other.rightCoordinate.x))
        let range2y = (Swift.min(other.leftCoordinate.y, other.rightCoordinate.y), Swift.max(other.leftCoordinate.y, other.rightCoordinate.y))
        let box1 = (range1x, range1y)
        let box2 = (range2x, range2y)

        return boundingBoxesOverlap1D(range1: box1.0, range2: box2.0) && boundingBoxesOverlap1D(range1: box1.1, range2: box2.1)
    }

    ///
    /// 2x2 Determinant
    ///
    /// | a b |
    /// | c d |
    ///
    /// Returns a value of ad - bc
    ///
    fileprivate func det2d(a: Double, b: Double, c: Double, d: Double) -> Double {
        return a*d - b*c
    }

    ///
    /// Returns a numeric value indicating where point p2 is relative to the line determined by p0 and p1.
    /// value > 0 implies p2 is on the left
    /// value = 0 implies p2 is on the line
    /// value < 0 implies p2 is to the right
    ///
    fileprivate func isLeft(p0: Coordinate, p1: Coordinate, p2: Coordinate) -> Double {
        return (p1.x - p0.x)*(p2.y - p0.y) - (p2.x - p0.x)*(p1.y -  p0.y)
    }

    ///
    /// Two line segments are passed in.
    /// If the first coordinate of the first segment, "segment", is a boundary point, firstCoordinateFirstSegmentBoundary should be true.
    /// If the second coordinate of the first segment, "segment", is a boundary point, secondCoordinateFirstSegmentBoundary should be true.
    /// If the first coordinate of the second segment, "other", is a boundary point, firstCoordinateSecondSegmentBoundary should be true.
    /// If the second coordinate of the second segment, "other", is a boundary point, secondCoordinateSecondSegmentBoundary should be true.
    ///
    fileprivate func intersection(segment: Segment, other: Segment, firstCoordinateFirstSegmentBoundary: Bool = false, secondCoordinateFirstSegmentBoundary: Bool = false, firstCoordinateSecondSegmentBoundary: Bool = false, secondCoordinateSecondSegmentBoundary: Bool = false) -> LineSegmentIntersection {

        let precision = Floating()
        let csystem   = Cartesian()

        ///
        /// Check the bounding boxes.  They must overlap if there is an intersection.
        ///
        guard boundingBoxesOverlap2D(segment: segment, other: other) else {
            return LineSegmentIntersection()
        }

        ///
        /// Get location of endpoints
        ///
        let segment1Boundary1Location = coordinateIsOnLineSegment(segment.leftCoordinate, segment: other)
        let segment1Boundary2Location = coordinateIsOnLineSegment(segment.rightCoordinate, segment: other)
        let segment2Boundary1Location = coordinateIsOnLineSegment(other.leftCoordinate, segment: segment)
        let segment2Boundary2Location = coordinateIsOnLineSegment(other.rightCoordinate, segment: segment)

        ///
        /// Check cases where at least one boundary point of one segment touches the other line segment
        ///
        let leftSign   = isLeft(p0: segment.leftCoordinate, p1: segment.rightCoordinate, p2: other.leftCoordinate)
        let rightSign  = isLeft(p0: segment.leftCoordinate, p1: segment.rightCoordinate, p2: other.rightCoordinate)
        let leftSign2  = isLeft(p0: other.leftCoordinate, p1: other.rightCoordinate, p2: segment.leftCoordinate)
        let rightSign2 = isLeft(p0: other.leftCoordinate, p1: other.rightCoordinate, p2: segment.rightCoordinate)
        let oneLine    = leftSign == 0 && rightSign == 0 /// Both line segments lie on one line
        if  (segment1Boundary1Location != .onExterior) ||  (segment1Boundary2Location != .onExterior) ||
            (segment2Boundary1Location != .onExterior) ||  (segment2Boundary2Location != .onExterior) {

            var lineSegmentIntersection = LineSegmentIntersection(sb11: segment1Boundary1Location, sb12: segment1Boundary2Location, sb21: segment2Boundary1Location, sb22: segment2Boundary2Location)

            if (segment1Boundary1Location != .onExterior) && (segment1Boundary2Location != .onExterior) {
                /// Segment is completely contained in other
                lineSegmentIntersection.geometry = LineString([segment.leftCoordinate, segment.rightCoordinate], precision: precision, coordinateSystem: csystem)
            } else if (segment2Boundary1Location != .onExterior) &&  (segment2Boundary2Location != .onExterior) {
                /// Other is completely contained in segment
                lineSegmentIntersection.geometry = LineString([other.leftCoordinate, other.rightCoordinate], precision: precision, coordinateSystem: csystem)
            } else if (segment1Boundary1Location == .onBoundary) && (segment2Boundary1Location == .onBoundary) {
                /// Two segments meet at a single boundary point
                lineSegmentIntersection.geometry = Point(segment.leftCoordinate, precision: precision, coordinateSystem: csystem)
                if !firstCoordinateFirstSegmentBoundary && !firstCoordinateSecondSegmentBoundary {
                    lineSegmentIntersection.interiorsTouchAtPoint = true
                }
            } else if (segment1Boundary1Location == .onBoundary) && (segment2Boundary2Location == .onBoundary) {
                /// Two segments meet at a single boundary point
                lineSegmentIntersection.geometry = Point(segment.leftCoordinate, precision: precision, coordinateSystem: csystem)
                if !firstCoordinateFirstSegmentBoundary && !secondCoordinateSecondSegmentBoundary {
                    lineSegmentIntersection.interiorsTouchAtPoint = true
                }
            } else if (segment1Boundary2Location == .onBoundary) && (segment2Boundary1Location == .onBoundary) {
                /// Two segments meet at a single boundary point
                lineSegmentIntersection.geometry = Point(segment.rightCoordinate, precision: precision, coordinateSystem: csystem)
                if !secondCoordinateFirstSegmentBoundary && !firstCoordinateSecondSegmentBoundary {
                    lineSegmentIntersection.interiorsTouchAtPoint = true
                }
            } else if (segment1Boundary2Location == .onBoundary) && (segment2Boundary2Location == .onBoundary) {
                /// Two segments meet at a single boundary point
                lineSegmentIntersection.geometry = Point(segment.rightCoordinate, precision: precision, coordinateSystem: csystem)
                if !secondCoordinateFirstSegmentBoundary && !secondCoordinateSecondSegmentBoundary {
                    lineSegmentIntersection.interiorsTouchAtPoint = true
                }
            } else if (segment1Boundary2Location == .onBoundary) && (segment2Boundary1Location == .onBoundary) ||
                (segment1Boundary2Location == .onBoundary) && (segment2Boundary2Location == .onBoundary) {
                /// Two segments meet at a single boundary point
                lineSegmentIntersection.geometry = Point(segment.rightCoordinate, precision: precision, coordinateSystem: csystem)
            } else if oneLine {
                /// If you reach here, the two line segments overlap by an amount > 0, but neither line segment is contained in the other.
                if (segment1Boundary1Location != .onExterior) &&  (segment2Boundary1Location != .onExterior) {
                    /// Line segments overlap from segment left to other left
                    lineSegmentIntersection.geometry = LineString([segment.leftCoordinate, other.leftCoordinate], precision: precision, coordinateSystem: csystem)
                } else if (segment1Boundary1Location != .onExterior) &&  (segment2Boundary2Location != .onExterior) {
                    /// Line segments overlap from segment left to other right
                    lineSegmentIntersection.geometry = LineString([segment.leftCoordinate, other.rightCoordinate], precision: precision, coordinateSystem: csystem)
                } else if (segment1Boundary2Location != .onExterior) &&  (segment2Boundary1Location != .onExterior) {
                    /// Line segments overlap from segment left to other left
                    lineSegmentIntersection.geometry = LineString([segment.rightCoordinate, other.leftCoordinate], precision: precision, coordinateSystem: csystem)
                } else if (segment1Boundary2Location != .onExterior) &&  (segment2Boundary2Location != .onExterior) {
                    /// Line segments overlap from segment left to other right
                    lineSegmentIntersection.geometry = LineString([segment.rightCoordinate, other.rightCoordinate], precision: precision, coordinateSystem: csystem)
                }
            } else {
                /// If you reach here, the two line segments touch at a single point that is on the boundary of one segment and the interior of the other.
                if segment1Boundary1Location == .onInterior {
                    /// Segment boundary point 1 is on the interior of other
                    lineSegmentIntersection.geometry = Point(segment.leftCoordinate, precision: precision, coordinateSystem: csystem)
                    if !firstCoordinateFirstSegmentBoundary {
                        lineSegmentIntersection.interiorsTouchAtPoint = true
                    }
                } else if segment1Boundary2Location == .onInterior {
                    /// Segment boundary point 1 is on the interior of other
                    lineSegmentIntersection.geometry = Point(segment.rightCoordinate, precision: precision, coordinateSystem: csystem)
                } else if segment2Boundary1Location == .onInterior {
                    /// Segment boundary point 1 is on the interior of other
                    lineSegmentIntersection.geometry = Point(other.leftCoordinate, precision: precision, coordinateSystem: csystem)
                } else if segment2Boundary2Location == .onInterior {
                    /// Segment boundary point 1 is on the interior of other
                    lineSegmentIntersection.geometry = Point(other.rightCoordinate, precision: precision, coordinateSystem: csystem)
                    if !secondCoordinateSecondSegmentBoundary {
                        lineSegmentIntersection.interiorsTouchAtPoint = true
                    }
                }
            }
            return lineSegmentIntersection
        }

        ///
        /// Check whether the two segments intersect at an interior point of each.
        /// Since the cases where the segments touch at a boundary point have all been handled, intersecting here is guaranteed to be in segments' interior.
        ///
        /// The two segments will intersect if and only if the signs of the isLeft function are non-zero and are different for both segments.
        /// This means one segment cannot be completely on one side of the other.
        ///
        /// TODO: We will need to separate out the = 0 cases below because these imply the segments fall on the same line.
        ///
        /// The line segments must intersect at a single point.  Calculate and return the point of intersection.
        ///
        let x1 = segment.leftCoordinate.x
        let y1 = segment.leftCoordinate.y
        let x2 = segment.rightCoordinate.x
        let y2 = segment.rightCoordinate.y
        let x3 = other.leftCoordinate.x
        let y3 = other.leftCoordinate.y
        let x4 = other.rightCoordinate.x
        let y4 = other.rightCoordinate.y

        let det1 = det2d(a: x1, b: y1, c: x2, d: y2)
        let det2 = det2d(a: x3, b: y3, c: x4, d: y4)
        let det3 = det2d(a: x1, b: 1, c: x2, d: 1)
        let det4 = det2d(a: x3, b: 1, c: x4, d: 1)
        let det5 = det2d(a: y1, b: 1, c: y2, d: 1)
        let det6 = det2d(a: y3, b: 1, c: y4, d: 1)

        let numx = det2d(a: det1, b: det3, c: det2, d: det4)
        let numy = det2d(a: det1, b: det5, c: det2, d: det6)
        let den  = det2d(a: det3, b: det5, c: det4, d: det6) // The denominator

        ///
        /// TODO: Add check for den = 0.
        /// The den is 0 when (x1 - x2)*(y3 - y4) - (y1 - y2)*(x3 - x4) = 0
        /// For now we will add guard statement to make sure the den is not zero.
        /// Note that if den is zero, it implies the two line segments are either parallel or
        /// fall on the same line and may or may not overlap.
        /// These cases must be addressed separately.
        ///
        guard den != 0 else {
            /// TODO: Might also have to check for near zero.
            return LineSegmentIntersection()
        }

        let x = numx / den
        let y = numy / den

        var interiorsIntersect = false
        var geometry: Geometry?
        if ((leftSign < 0 && rightSign > 0) || (leftSign > 0 && rightSign < 0)) && ((leftSign2 < 0 && rightSign2 > 0) || (leftSign2 > 0 && rightSign2 < 0)) {
            interiorsIntersect = true
            geometry = Point(Coordinate(x:x, y: y))
        }

        return LineSegmentIntersection(sb11: segment1Boundary1Location, sb12: segment1Boundary2Location, sb21: segment2Boundary1Location, sb22: segment2Boundary2Location, interiors: interiorsIntersect, theGeometry: geometry)
    }

//    fileprivate static func intersects(_ points1: MultiPoint, _ points2: MultiPoint) -> Bool {
//
//        let coordinates1 = multiPointToCoordinateArray(points1)
//        let coordinates2 = multiPointToCoordinateArray(points2)
//        return intersects(coordinates1, coordinates2)
//    }
//
//    fileprivate static func intersects(_ coordinates1: [Coordinate], _ coordinates2: [Coordinate]) -> Bool {
//
//        for tempCoordinate in coordinates1 {
//            if subset(tempCoordinate, coordinates2) {
//                return true
//            }
//        }
//        return false
//    }
//
//    /// Calculate the slope as a tuple.
//    /// The first value is the slope, if the line is not vertical.
//    /// The second value is a boolean flag indicating whether the line is vertical.  If it is, the first value is irrelevant and will typically be zero.
//    fileprivate static func slope(_ coordinate1: Coordinate, _ coordinate2: Coordinate) -> (Double, Bool) {
//
//        /// Check for the vertical case
//        guard coordinate1.x != coordinate2.x else {
//            return (0, true)
//        }
//
//        /// Normal case
//        return ((coordinate2.y - coordinate1.y) / (coordinate2.x - coordinate1.x), false)
//    }
//
//    fileprivate static func slope(_ segment: Segment) -> (Double, Bool) {
//
//        return slope(segment.leftCoordinate, segment.rightCoordinate)
//    }
//
//    /// Reduces a line string to a sequence of points such that each consecutive line segment will have a different slope
//    fileprivate static func reduce(_ lineString: LineString) -> LineString {
//
//        /// Must have at least 3 points or two lines segments for this algorithm to apply
//        guard lineString.count >= 3 else {
//            return lineString
//        }
//
//        var firstSlope: (Double, Bool)      /// The second value, if true, indicates a vertical line
//        var secondSlope: (Double, Bool)
//        var newLineString = LineString()
//        newLineString.append(lineString[0])
//        for lsFirstCoordIndex in 0..<lineString.count - 2 {
//            let lsFirstCoord  = lineString[lsFirstCoordIndex]
//            let lsSecondCoord = lineString[lsFirstCoordIndex + 1]
//            let lsThirdCoord  = lineString[lsFirstCoordIndex + 2]
//            firstSlope = slope(lsFirstCoord, lsSecondCoord)
//            secondSlope = slope(lsSecondCoord, lsThirdCoord)
//
//            if firstSlope != secondSlope {
//                newLineString.append(lineString[lsFirstCoordIndex + 1])
//            }
//        }
//
//        /// Add the last coordinate
//        newLineString.append(lineString[lineString.count - 1])
//
//        return newLineString
//    }
//
//    /// Creates a new linear ring from an original linear ring that starts and ends at the second to last point of the original
//    fileprivate static func moveStartBackOne(_ linearRing: LinearRing) -> LinearRing {
//
//        var newLinearRing = LinearRing(precision: Floating(), coordinateSystem: Cartesian())
//
//        guard linearRing.count >= 2 else {
//            return linearRing
//        }
//
//        let lrFirstCoord  = linearRing[linearRing.count - 2]
//        newLinearRing.append(lrFirstCoord)
//
//        for lrCoordIndex in 0..<linearRing.count - 1 {
//            let coord  = linearRing[lrCoordIndex]
//            newLinearRing.append(coord)
//        }
//
//        return newLinearRing
//    }
//
//    /// Reduces a linear ring to a sequence of points such that each consecutive line segment will have a different slope
//    fileprivate static func reduce(_ linearRing: LinearRing) -> LinearRing {
//
//        /// Must have at least 3 points or two lines segments for this algorithm to apply.
//        /// Could insist on 4 so you ignore the case where the segments overlap.
//        guard linearRing.count >= 3 else {
//            return linearRing
//        }
//
//        var firstSlope: (Double, Bool)      /// The second value, if true, indicates a vertical line
//        var secondSlope: (Double, Bool)
//        var newLinearRing = LinearRing()
//        newLinearRing.append(linearRing[0])
//        for lrFirstCoordIndex in 0..<linearRing.count - 2 {
//            let lrFirstCoord  = linearRing[lrFirstCoordIndex]
//            let lrSecondCoord = linearRing[lrFirstCoordIndex + 1]
//            let lrThirdCoord  = linearRing[lrFirstCoordIndex + 2]
//            firstSlope = slope(lrFirstCoord, lrSecondCoord)
//            secondSlope = slope(lrSecondCoord, lrThirdCoord)
//
//            if firstSlope != secondSlope {
//                newLinearRing.append(linearRing[lrFirstCoordIndex + 1])
//            }
//        }
//
//        /// Add the last coordinate, which should be the same as the first
//        newLinearRing.append(linearRing[linearRing.count - 1])
//
//        /// Now check whether the first and last segments of the new linear ring are on a straight line.
//        /// If they are, change the first point of the linear ring to be the second to last point of the new linear ring.
//        let lrFirstCoord  = newLinearRing[0]
//        let lrSecondCoord = newLinearRing[1]
//        let lrThirdCoord  = newLinearRing[newLinearRing.count - 2]
//        let lrFourthCoord = newLinearRing[newLinearRing.count - 1]
//        firstSlope = slope(lrFirstCoord, lrSecondCoord)
//        secondSlope = slope(lrThirdCoord, lrFourthCoord)
//
//        if firstSlope == secondSlope {
//            newLinearRing = moveStartBackOne(newLinearRing)
//        }
//
//        return newLinearRing
//    }
//
//    /// This currently assumes a GeometryCollection where all of the elements are LinearRings.
//    /// Specifically the LinearRings which represent the boundary of a Polygon.
//    /// This function can be extended to handle other geometry collections.
//    fileprivate static func reduce(_ geometryCollection: GeometryCollection) -> GeometryCollection {
//
//        var reducedLinearRings = GeometryCollection(precision: Floating(), coordinateSystem: Cartesian())
//
//        for index in 0..<geometryCollection.count {
//
//            guard let linearRing = geometryCollection[index] as? LinearRing else {
//                return reducedLinearRings
//            }
//
//            let reducedLinearRing = reduce(linearRing)
//            reducedLinearRings.append(reducedLinearRing)
//        }
//
//        return reducedLinearRings
//    }
//
//    /// Reduces a multi line string to a sequence of points on each line string such that each consecutive line segment will have a different slope.
//    /// Note that for this first pass, we will handle each line string separately.
//    /// TODO: Reduce connections between possibly connected line strings.
//    fileprivate static func reduce(_ multiLineString: MultiLineString) -> MultiLineString {
//
//        /// Define the MultiLineString geometry that might be returned
//        var resultMultiLineString = MultiLineString(precision: Floating(), coordinateSystem: Cartesian())
//
//        /// Reduce each of the multi line string
//        for lineString in multiLineString {
//
//            /// Must have at least 3 points or two lines segments for this algorithm to apply
//            guard lineString.count >= 3 else {
//                resultMultiLineString.append(lineString)
//                continue
//            }
//
//            var firstSlope: (Double, Bool)      /// The second value, if true, indicates a vertical line
//            var secondSlope: (Double, Bool)
//            var newLineString = LineString()
//            newLineString.append(lineString[0])
//            for lsFirstCoordIndex in 0..<lineString.count - 2 {
//                let lsFirstCoord  = lineString[lsFirstCoordIndex]
//                let lsSecondCoord = lineString[lsFirstCoordIndex + 1]
//                let lsThirdCoord  = lineString[lsFirstCoordIndex + 2]
//                firstSlope = slope(lsFirstCoord, lsSecondCoord)
//                secondSlope = slope(lsSecondCoord, lsThirdCoord)
//
//                if firstSlope != secondSlope {
//                    newLineString.append(lineString[lsFirstCoordIndex + 1])
//                }
//            }
//
//            /// Add the last coordinate
//            newLineString.append(lineString[lineString.count - 1])
//
//            /// Add the new line string to the resulting multi line string
//            resultMultiLineString.append(lineString)
//        }
//
//        return resultMultiLineString
//    }
//
//    /// Reduces an array of linear rings to another array of linear rings such that each consecutive
//    /// line segment of each linear ring will have a different slope.
//    fileprivate static func reduce(_ linearRingArray: [LinearRing]) -> [LinearRing] {
//
//        /// Define the inear ring array that might be returned
//        var resultLinearRingArray = [LinearRing(precision: Floating(), coordinateSystem: Cartesian())]
//
//        /// Reduce each of the linear rings
//        for linearRing in linearRingArray {
//
//            /// Must have at least 3 points or two line segments for this algorithm to apply
//            guard linearRing.count >= 3 else {
//                resultLinearRingArray.append(linearRing)
//                continue
//            }
//
//            var firstSlope: (Double, Bool)      /// The second value, if true, indicates a vertical line
//            var secondSlope: (Double, Bool)
//            var newLinearRing = LinearRing()
//            newLinearRing.append(linearRing[0])
//            for lsFirstCoordIndex in 0..<linearRing.count - 2 {
//                let lsFirstCoord  = linearRing[lsFirstCoordIndex]
//                let lsSecondCoord = linearRing[lsFirstCoordIndex + 1]
//                let lsThirdCoord  = linearRing[lsFirstCoordIndex + 2]
//                firstSlope = slope(lsFirstCoord, lsSecondCoord)
//                secondSlope = slope(lsSecondCoord, lsThirdCoord)
//
//                if firstSlope != secondSlope {
//                    newLinearRing.append(linearRing[lsFirstCoordIndex + 1])
//                }
//            }
//
//            /// Add the last coordinate
//            newLinearRing.append(linearRing[linearRing.count - 1])
//
//            /// Add the new linear ring to the resulting linear ring collection
//            resultLinearRingArray.append(newLinearRing)
//        }
//
//        return resultLinearRingArray
//    }
//
//    /// Reduces the linear rings of a polygon to another polygon whose linear rings are such that each consecutive
//    /// line segment of each linear ring will have a different slope.
//    fileprivate static func reduce(_ polygon: Polygon) -> Polygon {
//
//        /// Check there is a valid outer ring, else return the original polygon.
//        guard let polygonBoundary = polygon.boundary() as? GeometryCollection,
//            polygonBoundary.count > 0,
//            let outerLinearRing = polygonBoundary[0] as? LinearRing,
//            outerLinearRing.count > 0 else {
//                return polygon
//        }
//
//        /// Reduce the main boundary
//        let reducedMainLinearRing = reduce(outerLinearRing)
//
//        /// Reduce the holes
//        let holesArray = holes(polygon)
//        let reducedHoles = reduce(holesArray)
//
//        /// Construct the new polygon from the reduced pieces
//        return Polygon(reducedMainLinearRing, innerRings: reducedHoles, precision: Floating(), coordinateSystem: Cartesian())
//    }
//
//    /// Is segment1 contained in or a subset of segment2?
//    fileprivate static func subset(_ segment1: Segment, _ segment2: Segment) -> Bool {
//
//        /// If the slopes are not the same one segment being contained in another is not possible
//        let slope1 = slope(segment1)
//        let slope2 = slope(segment2)
//        guard slope1 == slope2 else {
//            return false
//        }
//
//        /// Slopes are the same.  Check if both coordinates of the first segment lie on the second
//        let location1 = coordinateIsOnLineSegment(segment1.leftCoordinate, segment: segment2)
//        let location2 = coordinateIsOnLineSegment(segment1.rightCoordinate, segment: segment2)
//        if location1 != .onExterior && location2 != .onExterior {
//            return true
//        } else {
//            return false
//        }
//    }
//
//    /// Is line string 1 contained in or a subset of line string 2?
//    /// The algorithm here assumes that both line strings have been reduced, so that no two consecutive segments have the same slope.
//    fileprivate static func subset(_ lineString1: LineString, _ lineString2: LineString) -> Bool {
//
//        for ls1FirstCoordIndex in 0..<lineString1.count - 1 {
//            let ls1FirstCoord  = lineString1[ls1FirstCoordIndex]
//            let ls1SecondCoord = lineString1[ls1FirstCoordIndex + 1]
//            let segment1 = Segment(left: ls1FirstCoord, right: ls1SecondCoord)
//
//            var segment1IsSubsetOfOtherSegment = false
//            for ls2FirstCoordIndex in 0..<lineString2.count - 1 {
//                let ls2FirstCoord  = lineString2[ls2FirstCoordIndex]
//                let ls2SecondCoord = lineString2[ls2FirstCoordIndex + 1]
//                let segment2 = Segment(left: ls2FirstCoord, right: ls2SecondCoord)
//
//                if subset(segment1, segment2) {
//                    segment1IsSubsetOfOtherSegment = true
//                    break
//                }
//            }
//
//            if !segment1IsSubsetOfOtherSegment {
//                return false
//            }
//        }
//
//        return true
//    }
//
//    /// Is the line string contained in or a subset of the linear ring?
//    /// The algorithm here assumes that both line strings have been reduced, so that no two consecutive segments have the same slope.
//    fileprivate static func subset(_ lineString: LineString, _ linearRing: LinearRing) -> Bool {
//
//        for lsFirstCoordIndex in 0..<lineString.count - 1 {
//            let lsFirstCoord  = lineString[lsFirstCoordIndex]
//            let lsSecondCoord = lineString[lsFirstCoordIndex + 1]
//            let segment1 = Segment(left: lsFirstCoord, right: lsSecondCoord)
//
//            var segment1IsSubsetOfOtherSegment = false
//            for lrFirstCoordIndex in 0..<linearRing.count - 1 {
//                let lrFirstCoord  = linearRing[lrFirstCoordIndex]
//                let lrSecondCoord = linearRing[lrFirstCoordIndex + 1]
//                let segment2 = Segment(left: lrFirstCoord, right: lrSecondCoord)
//
//                if subset(segment1, segment2) {
//                    segment1IsSubsetOfOtherSegment = true
//                    break
//                }
//            }
//
//            if !segment1IsSubsetOfOtherSegment {
//                return false
//            }
//        }
//
//        return true
//    }
//
//    /// Is the first linear ring contained in or a subset of the second linear ring?
//    /// The algorithm here assumes that both linear rings have been reduced, so that no two consecutive segments have the same slope.
//    fileprivate static func subset(_ linearRing1: LinearRing, _ linearRing2: LinearRing) -> Bool {
//
//        for lr1FirstCoordIndex in 0..<linearRing1.count - 1 {
//            let lr1FirstCoord  = linearRing1[lr1FirstCoordIndex]
//            let lr1SecondCoord = linearRing1[lr1FirstCoordIndex + 1]
//            let segment1 = Segment(left: lr1FirstCoord, right: lr1SecondCoord)
//
//            var segment1IsSubsetOfOtherSegment = false
//            for lr2FirstCoordIndex in 0..<linearRing2.count - 1 {
//                let lr2FirstCoord  = linearRing2[lr2FirstCoordIndex]
//                let lr2SecondCoord = linearRing2[lr2FirstCoordIndex + 1]
//                let segment2 = Segment(left: lr2FirstCoord, right: lr2SecondCoord)
//
//                if subset(segment1, segment2) {
//                    segment1IsSubsetOfOtherSegment = true
//                    break
//                }
//            }
//
//            if !segment1IsSubsetOfOtherSegment {
//                return false
//            }
//        }
//
//        return true
//    }
//
//    /// Is the line string contained in or a subset of the multi line string?
//    /// The algorithm here assumes that both geometries have been reduced, so that no two consecutive segments have the same slope.
//    /// TODO:
//    fileprivate static func subset(_ lineString1: LineString, _ multiLineString: MultiLineString) -> Bool {
//
//        for ls1FirstCoordIndex in 0..<lineString1.count - 1 {
//            let ls1FirstCoord  = lineString1[ls1FirstCoordIndex]
//            let ls1SecondCoord = lineString1[ls1FirstCoordIndex + 1]
//            let segment1 = Segment(left: ls1FirstCoord, right: ls1SecondCoord)
//
//            var segment1IsSubsetOfOtherSegment = false
//
//            for lineString2 in multiLineString {
//                for ls2FirstCoordIndex in 0..<lineString2.count - 1 {
//                    let ls2FirstCoord  = lineString2[ls2FirstCoordIndex]
//                    let ls2SecondCoord = lineString2[ls2FirstCoordIndex + 1]
//                    let segment2 = Segment(left: ls2FirstCoord, right: ls2SecondCoord)
//
//                    if subset(segment1, segment2) {
//                        segment1IsSubsetOfOtherSegment = true
//                        break
//                    }
//                }
//
//                if segment1IsSubsetOfOtherSegment {
//                    break
//                }
//            }
//
//            if !segment1IsSubsetOfOtherSegment {
//                return false
//            }
//        }
//
//        return true
//    }
//
//    /// Is the line string contained in or a subset of the polygon?
//    /// If the line string is a subset of the polygon, it must be included in the main polygon and not inside any of the polygon holes.
//    /// Note that being on the boundary of a polygon hole is acceptable.
//    /// The algorithm here assumes that both geometries have been reduced, so that no two consecutive segments have the same slope.
//    fileprivate static func subset(_ lineString: LineString, _ polygon: Polygon) -> Bool {
//
//        /// Get the polygon boundary
//        guard let polygonBoundary = polygon.boundary() as? GeometryCollection,
//            polygonBoundary.count > 0,
//            let outerLinearRing = polygonBoundary[0] as? LinearRing,
//            outerLinearRing.count > 0 else {
//                return false
//        }
//
//        /// Check if the line string is inside the main linear ring
//        guard subset(lineString, outerLinearRing) else { return false }
//
//        /// At this point, the line string is inside the main boundary.
//        /// If there are no holes, we are done.
//        let holesArray = holes(polygon)
//        guard holesArray.count > 1 else { return true }
//
//        /// There are holes.  Check each one to see if the line string is in the interior of any.
//        /// Being on the boundary of a hole is okay.
//        for linearRing in holesArray {
//
//            guard linearRing.count > 0 else { continue }
//
//            /// Get the relationship between the point and the hole
//            let relatedToResult = relatedTo(lineString, linearRing)
//
//            /// Check if the line string is on the interior of the hole
//            if relatedToResult.firstTouchesSecondInterior > .empty {
//                return false
//            }
//        }
//
//        /// The line string is not in the interior of any hole.
//        return true
//    }
//
//    /// Is the linear ring contained in or a subset of the multi line string?
//    /// The algorithm here assumes that both geometries have been reduced, so that no two consecutive segments have the same slope.
//    /// TODO:
//    fileprivate static func subset(_ linearRing: LinearRing, _ multiLineString: MultiLineString) -> Bool {
//
//        for lrFirstCoordIndex in 0..<linearRing.count - 1 {
//            let lrFirstCoord  = linearRing[lrFirstCoordIndex]
//            let lrSecondCoord = linearRing[lrFirstCoordIndex + 1]
//            let segment1 = Segment(left: lrFirstCoord, right: lrSecondCoord)
//
//            var segment1IsSubsetOfOtherSegment = false
//
//            for lineString in multiLineString {
//                for lsFirstCoordIndex in 0..<lineString.count - 1 {
//                    let lsFirstCoord  = lineString[lsFirstCoordIndex]
//                    let lsSecondCoord = lineString[lsFirstCoordIndex + 1]
//                    let segment2 = Segment(left: lsFirstCoord, right: lsSecondCoord)
//
//                    if subset(segment1, segment2) {
//                        segment1IsSubsetOfOtherSegment = true
//                        break
//                    }
//                }
//
//                if segment1IsSubsetOfOtherSegment {
//                    break
//                }
//            }
//
//            if !segment1IsSubsetOfOtherSegment {
//                return false
//            }
//        }
//
//        return true
//    }
//
//    /// Is the linear ring contained in or a subset of the collection of linear rings?
//    /// If the linear ring is a subset of the collection, it must match one of linear rings, although the sequence of points need not match.
//    /// The algorithm here assumes that both geometries have been reduced, so that no two consecutive segments have the same slope.
//    fileprivate static func subset(_ linearRing: LinearRing, _ geometryCollection: GeometryCollection) -> Bool {
//
//        for index in 0..<geometryCollection.count {
//
//            guard let linearRing2 = geometryCollection[index] as? LinearRing else {
//                return false
//            }
//
//            /// Check if the linear ring is inside the currently selected linear ring from the collection.
//            if subset(linearRing, linearRing2) { return true }
//        }
//
//        /// The linear ring does not match any linear ring in the collection.
//        return false
//    }
//
//    /// Is the multi line string contained in or a subset of the linear ring?
//    /// The algorithm here assumes that both geometries have been reduced, so that no two consecutive segments have the same slope.
//    fileprivate static func subset(_ multiLineString: MultiLineString, _ linearRing: LinearRing) -> Bool {
//
//        for lineString in multiLineString {
//            if !subset(lineString, linearRing) {
//                return false
//            }
//        }
//
//        return true
//    }
//
//    /// Is the first multi line string contained in or a subset of the second multi line string?
//    /// The algorithm here assumes that both geometries have been reduced, so that no two consecutive segments have the same slope.
//    /// TODO:
//    fileprivate static func subset(_ multiLineString1: MultiLineString, _ multiLineString2: MultiLineString) -> Bool {
//
//        for lineString1 in multiLineString1 {
//            for ls1FirstCoordIndex in 0..<lineString1.count - 1 {
//                let ls1FirstCoord  = lineString1[ls1FirstCoordIndex]
//                let ls1SecondCoord = lineString1[ls1FirstCoordIndex + 1]
//                let segment1 = Segment(left: ls1FirstCoord, right: ls1SecondCoord)
//
//                var segment1IsSubsetOfOtherSegment = false
//
//                for lineString2 in multiLineString2 {
//                    for ls2FirstCoordIndex in 0..<lineString2.count - 1 {
//                        let ls2FirstCoord  = lineString2[ls2FirstCoordIndex]
//                        let ls2SecondCoord = lineString2[ls2FirstCoordIndex + 1]
//                        let segment2 = Segment(left: ls2FirstCoord, right: ls2SecondCoord)
//
//                        if subset(segment1, segment2) {
//                            segment1IsSubsetOfOtherSegment = true
//                            break
//                        }
//                    }
//
//                    if segment1IsSubsetOfOtherSegment {
//                        break
//                    }
//                }
//
//                if !segment1IsSubsetOfOtherSegment {
//                    return false
//                }
//            }
//        }
//
//        return true
//    }
//
//    /// Is the multi line string contained in or a subset of the collection of linear rings?
//    /// If the multi line string is a subset of the collection, each line string of the multi line string must be a subset of just one linear ring.
//    /// The algorithm here assumes that both geometries have been reduced, so that no two consecutive segments have the same slope.
//    fileprivate static func subset(_ multiLineString: MultiLineString, _ geometryCollection: GeometryCollection) -> Bool {
//
//        for lineString in multiLineString {
//            var lineStringInsideLinearRing = false
//            for index in 0..<geometryCollection.count {
//
//                guard let linearRing = geometryCollection[index] as? LinearRing else {
//                    return false
//                }
//
//                /// Check if the line string is inside the currently selected linear ring from the collection.
//                if subset(lineString, linearRing) {
//                    lineStringInsideLinearRing = true
//                    break
//                }
//            }
//
//            if !lineStringInsideLinearRing { return false }
//        }
//
//        /// Each line string of the multi line string is inside a linear ring in the collection.
//        return true
//    }

    fileprivate func generateIntersection(_ lineString1: LineString, _ lineString2: LineString) -> Geometry {

        /// Simplify each geometry first
        let simplifiedLineString1 = lineString1.simplify(tolerance: 1.0)
        let simplifiedLineString2 = lineString2.simplify(tolerance: 1.0)

        /// Check the intersection of each line segment of each line string.
        /// The returned value will be a GeometryCollection, which may be empty.
        /// The GeometryCollection may contain two values, a MultiPoint and a MultiLineString.
        /// The MultiPoint will contain all the Points, and the MultiLineString will contain all the LineStrings.
        /// The MultiPoint and a MultiLineString will only be in the GeometryCollection if they are non-empty.

        var multiPointGeometry = MultiPoint(precision: Floating(), coordinateSystem: Cartesian())
        var multiLineStringGeometry = MultiLineString(precision: Floating(), coordinateSystem: Cartesian())

        /// Collect all intersections that will consist of LineStrings or Points.
        /// Note the LineStrings will really be Segments that potentially overlap each other.
        /// The Points can be duplicated, and they could be contained in one or more LineStrings.
        for ls1FirstCoordIndex in 0..<simplifiedLineString1.count - 1 {
            let ls1FirstCoord  = simplifiedLineString1[ls1FirstCoordIndex]
            let ls1SecondCoord = simplifiedLineString1[ls1FirstCoordIndex + 1]
            let segment1 = Segment(left: ls1FirstCoord, right: ls1SecondCoord)
            let firstBoundary = (ls1FirstCoordIndex == 0)

            for ls2FirstCoordIndex in 0..<simplifiedLineString2.count - 1 {
                let ls2FirstCoord  = simplifiedLineString2[ls2FirstCoordIndex]
                let ls2SecondCoord = simplifiedLineString2[ls2FirstCoordIndex + 1]
                let segment2 = Segment(left: ls2FirstCoord, right: ls2SecondCoord)
                let secondBoundary = (ls2FirstCoordIndex == simplifiedLineString2.count - 2)
                let lineSegmentIntersection = intersection(segment: segment1, other: segment2, firstCoordinateFirstSegmentBoundary: firstBoundary, secondCoordinateSecondSegmentBoundary: secondBoundary)

                /// Check for a LineString or Point intersection.
                if let lineString = lineSegmentIntersection.geometry as? LineString {
                    multiLineStringGeometry.append(lineString)
                } else if let point = lineSegmentIntersection.geometry as? Point {
                    multiPointGeometry.append(point)
                }
            }
        }

        /// Remove all Points that are duplicated or are contained in one of the LineStrings.
        let simplifiedMultiPoint = multiPointGeometry.simplify(tolerance: 1.0)
        var finalMultiPointGeometry = MultiPoint(precision: Floating(), coordinateSystem: Cartesian())

        for tempPoint in simplifiedMultiPoint {

            if let _ = intersection(tempPoint, multiLineStringGeometry) as? GeometryCollection {
                finalMultiPointGeometry.append(tempPoint)
            }
        }

        /// Simplify the LineStrings in the MultiLineString to minimize the total number of LineStrings.
        let finalMultiLineString = multiLineStringGeometry.simplify(tolerance: 1.0)

        /// Build the final GeometryCollection that will be returned.
        var geometryCollection = GeometryCollection(precision: Floating(), coordinateSystem: Cartesian())
        if finalMultiPointGeometry.count > 0 {
            geometryCollection.append(finalMultiPointGeometry)
        }
        if finalMultiLineString.count > 0 {
            geometryCollection.append(finalMultiLineString)
        }

        /// Return
        return geometryCollection
    }

    /// There is an assumption here that the line string is not a linear ring
    fileprivate func generateIntersection(_ lineString: LineString, _ linearRing: LinearRing) -> Geometry {

        /// Simplify each geometry first
        let simplifiedLineString = lineString.simplify(tolerance: 1.0)
        let simplifiedLinearRing = linearRing.simplify(tolerance: 1.0)

        /// Check the intersection of each line segment of both the line string and the linear ring.
        /// The returned value will be a GeometryCollection, which may be empty.
        /// The GeometryCollection may contain two values, a MultiPoint and a MultiLineString.
        /// The MultiPoint will contain all the Points, and the MultiLineString will contain all the LineStrings.
        /// The MultiPoint and a MultiLineString will only be in the GeometryCollection if they are non-empty.

        var multiPointGeometry = MultiPoint(precision: Floating(), coordinateSystem: Cartesian())
        var multiLineStringGeometry = MultiLineString(precision: Floating(), coordinateSystem: Cartesian())

        /// Collect all intersections that will consist of LineStrings or Points.
        /// Note the LineStrings will really be Segments that potentially overlap each other.
        /// The Points can be duplicated, and they could be contained in one or more LineStrings.
        for ls1FirstCoordIndex in 0..<simplifiedLineString.count - 1 {
            let ls1FirstCoord  = simplifiedLineString[ls1FirstCoordIndex]
            let ls1SecondCoord = simplifiedLineString[ls1FirstCoordIndex + 1]
            let segment1 = Segment(left: ls1FirstCoord, right: ls1SecondCoord)
            let firstBoundary = (ls1FirstCoordIndex == 0)

            for ls2FirstCoordIndex in 0..<simplifiedLinearRing.count - 1 {
                let ls2FirstCoord  = simplifiedLinearRing[ls2FirstCoordIndex]
                let ls2SecondCoord = simplifiedLinearRing[ls2FirstCoordIndex + 1]
                let segment2 = Segment(left: ls2FirstCoord, right: ls2SecondCoord)
                let secondBoundary = (ls2FirstCoordIndex == simplifiedLinearRing.count - 2)
                let lineSegmentIntersection = intersection(segment: segment1, other: segment2, firstCoordinateFirstSegmentBoundary: firstBoundary, secondCoordinateSecondSegmentBoundary: secondBoundary)

                /// Check for a LineString or Point intersection.
                if let lineString = lineSegmentIntersection.geometry as? LineString {
                    multiLineStringGeometry.append(lineString)
                } else if let point = lineSegmentIntersection.geometry as? Point {
                    multiPointGeometry.append(point)
                }
            }
        }

        /// Remove all Points that are duplicated or are contained in one of the LineStrings.
        let simplifiedMultiPoint = multiPointGeometry.simplify(tolerance: 1.0)
        var finalMultiPointGeometry = MultiPoint(precision: Floating(), coordinateSystem: Cartesian())

        for tempPoint in simplifiedMultiPoint {

            if let _ = intersection(tempPoint, multiLineStringGeometry) as? GeometryCollection {
                finalMultiPointGeometry.append(tempPoint)
            }
        }

        /// Simplify the LineStrings in the MultiLineString to minimize the total number of LineStrings.
        let finalMultiLineString = multiLineStringGeometry.simplify(tolerance: 1.0)

        /// Build the final GeometryCollection that will be returned.
        var geometryCollection = GeometryCollection(precision: Floating(), coordinateSystem: Cartesian())
        if finalMultiPointGeometry.count > 0 {
            geometryCollection.append(finalMultiPointGeometry)
        }
        if finalMultiLineString.count > 0 {
            geometryCollection.append(finalMultiLineString)
        }

        /// Return
        return geometryCollection
    }

    fileprivate func generateIntersection(_ lineString: LineString, _ multiLineString: MultiLineString) -> Geometry {

        /// Simplify each geometry first
        let simplifiedLineString1 = lineString.simplify(tolerance: 1.0)
        let simplifiedMultiLineString = multiLineString.simplify(tolerance: 1.0)

        /// Check the intersection of each line segment of each line string.
        /// The returned value will be a GeometryCollection, which may be empty.
        /// The GeometryCollection may contain two values, a MultiPoint and a MultiLineString.
        /// The MultiPoint will contain all the Points, and the MultiLineString will contain all the LineStrings.
        /// The MultiPoint and a MultiLineString will only be in the GeometryCollection if they are non-empty.

        var multiPointGeometry = MultiPoint(precision: Floating(), coordinateSystem: Cartesian())
        var multiLineStringGeometry = MultiLineString(precision: Floating(), coordinateSystem: Cartesian())

        /// Collect all intersections that will consist of LineStrings or Points.
        /// Note the LineStrings will really be Segments that potentially overlap each other.
        /// The Points can be duplicated, and they could be contained in one or more LineStrings.
        for ls1FirstCoordIndex in 0..<simplifiedLineString1.count - 1 {
            let ls1FirstCoord  = simplifiedLineString1[ls1FirstCoordIndex]
            let ls1SecondCoord = simplifiedLineString1[ls1FirstCoordIndex + 1]
            let segment1 = Segment(left: ls1FirstCoord, right: ls1SecondCoord)
            let firstBoundary = (ls1FirstCoordIndex == 0)

            for lineString in simplifiedMultiLineString {
                let simplifiedLineString2 = lineString.simplify(tolerance: 1.0)
                for ls2FirstCoordIndex in 0..<simplifiedLineString2.count - 1 {
                    let ls2FirstCoord  = simplifiedLineString2[ls2FirstCoordIndex]
                    let ls2SecondCoord = simplifiedLineString2[ls2FirstCoordIndex + 1]
                    let segment2 = Segment(left: ls2FirstCoord, right: ls2SecondCoord)
                    let secondBoundary = (ls2FirstCoordIndex == simplifiedLineString2.count - 2)
                    let lineSegmentIntersection = intersection(segment: segment1, other: segment2, firstCoordinateFirstSegmentBoundary: firstBoundary, secondCoordinateSecondSegmentBoundary: secondBoundary)

                    /// Check for a LineString or Point intersection.
                    if let lineStringGeometry = lineSegmentIntersection.geometry as? LineString {
                        multiLineStringGeometry.append(lineStringGeometry)
                    } else if let point = lineSegmentIntersection.geometry as? Point {
                        multiPointGeometry.append(point)
                    }
                }
            }
        }

        /// Remove all Points that are duplicated or are contained in one of the LineStrings.
        let simplifiedMultiPoint = multiPointGeometry.simplify(tolerance: 1.0)
        var finalMultiPointGeometry = MultiPoint(precision: Floating(), coordinateSystem: Cartesian())

        for tempPoint in simplifiedMultiPoint {

            if let _ = intersection(tempPoint, multiLineStringGeometry) as? GeometryCollection {
                finalMultiPointGeometry.append(tempPoint)
            }
        }

        /// Simplify the LineStrings in the MultiLineString to minimize the total number of LineStrings.
        let finalMultiLineString = multiLineStringGeometry.simplify(tolerance: 1.0)

        /// Build the final GeometryCollection that will be returned.
        var geometryCollection = GeometryCollection(precision: Floating(), coordinateSystem: Cartesian())
        if finalMultiPointGeometry.count > 0 {
            geometryCollection.append(finalMultiPointGeometry)
        }
        if finalMultiLineString.count > 0 {
            geometryCollection.append(finalMultiLineString)
        }

        /// Return
        return geometryCollection
    }

    fileprivate func generateIntersection(_ linearRing1: LinearRing, _ linearRing2: LinearRing) -> Geometry {

        /// Simplify each geometry first
        let simplifiedLinearRing1 = linearRing1.simplify(tolerance: 1.0)
        let simplifiedLinearRing2 = linearRing2.simplify(tolerance: 1.0)

        /// Check the intersection of each line segment of both linear rings.
        /// The returned value will be a GeometryCollection, which may be empty.
        /// The GeometryCollection may contain two values, a MultiPoint and a MultiLineString.
        /// The MultiPoint will contain all the Points, and the MultiLineString will contain all the LineStrings.
        /// The MultiPoint and a MultiLineString will only be in the GeometryCollection if they are non-empty.

        var multiPointGeometry = MultiPoint(precision: Floating(), coordinateSystem: Cartesian())
        var multiLineStringGeometry = MultiLineString(precision: Floating(), coordinateSystem: Cartesian())

        /// Collect all intersections that will consist of LineStrings or Points.
        /// Note the LineStrings will really be Segments that potentially overlap each other.
        /// The Points can be duplicated, and they could be contained in one or more LineStrings.
        for ls1FirstCoordIndex in 0..<simplifiedLinearRing1.count - 1 {
            let ls1FirstCoord  = simplifiedLinearRing1[ls1FirstCoordIndex]
            let ls1SecondCoord = simplifiedLinearRing1[ls1FirstCoordIndex + 1]
            let segment1 = Segment(left: ls1FirstCoord, right: ls1SecondCoord)
            let firstBoundary = (ls1FirstCoordIndex == 0)

            for ls2FirstCoordIndex in 0..<simplifiedLinearRing2.count - 1 {
                let ls2FirstCoord  = simplifiedLinearRing2[ls2FirstCoordIndex]
                let ls2SecondCoord = simplifiedLinearRing2[ls2FirstCoordIndex + 1]
                let segment2 = Segment(left: ls2FirstCoord, right: ls2SecondCoord)
                let secondBoundary = (ls2FirstCoordIndex == simplifiedLinearRing2.count - 2)
                let lineSegmentIntersection = intersection(segment: segment1, other: segment2, firstCoordinateFirstSegmentBoundary: firstBoundary, secondCoordinateSecondSegmentBoundary: secondBoundary)

                /// Check for a LineString or Point intersection.
                if let lineString = lineSegmentIntersection.geometry as? LineString {
                    multiLineStringGeometry.append(lineString)
                } else if let point = lineSegmentIntersection.geometry as? Point {
                    multiPointGeometry.append(point)
                }
            }
        }

        /// Remove all Points that are duplicated or are contained in one of the LineStrings.
        let simplifiedMultiPoint = multiPointGeometry.simplify(tolerance: 1.0)
        var finalMultiPointGeometry = MultiPoint(precision: Floating(), coordinateSystem: Cartesian())

        for tempPoint in simplifiedMultiPoint {

            if let _ = intersection(tempPoint, multiLineStringGeometry) as? GeometryCollection {
                finalMultiPointGeometry.append(tempPoint)
            }
        }

        /// Simplify the LineStrings in the MultiLineString to minimize the total number of LineStrings.
        let finalMultiLineString = multiLineStringGeometry.simplify(tolerance: 1.0)

        /// Build the final GeometryCollection that will be returned.
        var geometryCollection = GeometryCollection(precision: Floating(), coordinateSystem: Cartesian())
        if finalMultiPointGeometry.count > 0 {
            geometryCollection.append(finalMultiPointGeometry)
        }
        if finalMultiLineString.count > 0 {
            geometryCollection.append(finalMultiLineString)
        }

        /// Return
        return geometryCollection
    }

    fileprivate func generateIntersection(_ linearRing: LinearRing, _ multiLineString: MultiLineString) -> Geometry {

        /// Simplify each geometry first
        let simplifiedLinearRing = linearRing.simplify(tolerance: 1.0)
        let simplifiedMultiLineString = multiLineString.simplify(tolerance: 1.0)

        /// Check the intersection of each line segment of the linear ring and each line string of the multi line string.
        /// The returned value will be a GeometryCollection, which may be empty.
        /// The GeometryCollection may contain two values, a MultiPoint and a MultiLineString.
        /// The MultiPoint will contain all the Points, and the MultiLineString will contain all the LineStrings.
        /// The MultiPoint and a MultiLineString will only be in the GeometryCollection if they are non-empty.

        var multiPointGeometry = MultiPoint(precision: Floating(), coordinateSystem: Cartesian())
        var multiLineStringGeometry = MultiLineString(precision: Floating(), coordinateSystem: Cartesian())

        /// Collect all intersections that will consist of LineStrings or Points.
        /// Note the LineStrings will really be Segments that potentially overlap each other.
        /// The Points can be duplicated, and they could be contained in one or more LineStrings.
        for ls1FirstCoordIndex in 0..<simplifiedLinearRing.count - 1 {
            let ls1FirstCoord  = simplifiedLinearRing[ls1FirstCoordIndex]
            let ls1SecondCoord = simplifiedLinearRing[ls1FirstCoordIndex + 1]
            let segment1 = Segment(left: ls1FirstCoord, right: ls1SecondCoord)
            let firstBoundary = (ls1FirstCoordIndex == 0)

            for lineString in simplifiedMultiLineString {
                let simplifiedLineString = lineString.simplify(tolerance: 1.0)
                for ls2FirstCoordIndex in 0..<simplifiedLineString.count - 1 {
                    let ls2FirstCoord  = simplifiedLineString[ls2FirstCoordIndex]
                    let ls2SecondCoord = simplifiedLineString[ls2FirstCoordIndex + 1]
                    let segment2 = Segment(left: ls2FirstCoord, right: ls2SecondCoord)
                    let secondBoundary = (ls2FirstCoordIndex == simplifiedLineString.count - 2)
                    let lineSegmentIntersection = intersection(segment: segment1, other: segment2, firstCoordinateFirstSegmentBoundary: firstBoundary, secondCoordinateSecondSegmentBoundary: secondBoundary)

                    /// Check for a LineString or Point intersection.
                    if let lineStringGeometry = lineSegmentIntersection.geometry as? LineString {
                        multiLineStringGeometry.append(lineStringGeometry)
                    } else if let point = lineSegmentIntersection.geometry as? Point {
                        multiPointGeometry.append(point)
                    }
                }
            }
        }

        /// Remove all Points that are duplicated or are contained in one of the LineStrings.
        let simplifiedMultiPoint = multiPointGeometry.simplify(tolerance: 1.0)
        var finalMultiPointGeometry = MultiPoint(precision: Floating(), coordinateSystem: Cartesian())

        for tempPoint in simplifiedMultiPoint {

            if let _ = intersection(tempPoint, multiLineStringGeometry) as? GeometryCollection {
                finalMultiPointGeometry.append(tempPoint)
            }
        }

        /// Simplify the LineStrings in the MultiLineString to minimize the total number of LineStrings.
        let finalMultiLineString = multiLineStringGeometry.simplify(tolerance: 1.0)

        /// Build the final GeometryCollection that will be returned.
        var geometryCollection = GeometryCollection(precision: Floating(), coordinateSystem: Cartesian())
        if finalMultiPointGeometry.count > 0 {
            geometryCollection.append(finalMultiPointGeometry)
        }
        if finalMultiLineString.count > 0 {
            geometryCollection.append(finalMultiLineString)
        }

        /// Return
        return geometryCollection
    }

    fileprivate func generateIntersection(_ multiLineString1: MultiLineString, _ multiLineString2: MultiLineString) -> Geometry {

        /// Simplify each geometry first
        let simplifiedMultiLineString1 = multiLineString1.simplify(tolerance: 1.0)
        let simplifiedMultiLineString2 = multiLineString2.simplify(tolerance: 1.0)

        /// Check the intersection of each line segment of each line string.
        /// The returned value will be a GeometryCollection, which may be empty.
        /// The GeometryCollection may contain two values, a MultiPoint and a MultiLineString.
        /// The MultiPoint will contain all the Points, and the MultiLineString will contain all the LineStrings.
        /// The MultiPoint and a MultiLineString will only be in the GeometryCollection if they are non-empty.

        var multiPointGeometry = MultiPoint(precision: Floating(), coordinateSystem: Cartesian())
        var multiLineStringGeometry = MultiLineString(precision: Floating(), coordinateSystem: Cartesian())

        /// Collect all intersections that will consist of LineStrings or Points.
        /// Note the LineStrings will really be Segments that potentially overlap each other.
        /// The Points can be duplicated, and they could be contained in one or more LineStrings.
        for lineString1 in simplifiedMultiLineString1 {
            let simplifiedLineString1 = lineString1.simplify(tolerance: 1.0)
            for ls1FirstCoordIndex in 0..<simplifiedLineString1.count - 1 {
                let ls1FirstCoord  = simplifiedLineString1[ls1FirstCoordIndex]
                let ls1SecondCoord = simplifiedLineString1[ls1FirstCoordIndex + 1]
                let segment1 = Segment(left: ls1FirstCoord, right: ls1SecondCoord)
                let firstBoundary = (ls1FirstCoordIndex == 0)

                for lineString2 in simplifiedMultiLineString2 {
                    let simplifiedLineString2 = lineString2.simplify(tolerance: 1.0)
                    for ls2FirstCoordIndex in 0..<simplifiedLineString2.count - 1 {
                        let ls2FirstCoord  = simplifiedLineString2[ls2FirstCoordIndex]
                        let ls2SecondCoord = simplifiedLineString2[ls2FirstCoordIndex + 1]
                        let segment2 = Segment(left: ls2FirstCoord, right: ls2SecondCoord)
                        let secondBoundary = (ls2FirstCoordIndex == simplifiedLineString2.count - 2)
                        let lineSegmentIntersection = intersection(segment: segment1, other: segment2, firstCoordinateFirstSegmentBoundary: firstBoundary, secondCoordinateSecondSegmentBoundary: secondBoundary)

                        /// Check for a LineString or Point intersection.
                        if let lineStringGeometry = lineSegmentIntersection.geometry as? LineString {
                            multiLineStringGeometry.append(lineStringGeometry)
                        } else if let point = lineSegmentIntersection.geometry as? Point {
                            multiPointGeometry.append(point)
                        }
                    }
                }
            }
        }

        /// Remove all Points that are duplicated or are contained in one of the LineStrings.
        let simplifiedMultiPoint = multiPointGeometry.simplify(tolerance: 1.0)
        var finalMultiPointGeometry = MultiPoint(precision: Floating(), coordinateSystem: Cartesian())

        for tempPoint in simplifiedMultiPoint {

            if let _ = intersection(tempPoint, multiLineStringGeometry) as? GeometryCollection {
                finalMultiPointGeometry.append(tempPoint)
            }
        }

        /// Simplify the LineStrings in the MultiLineString to minimize the total number of LineStrings.
        let finalMultiLineString = multiLineStringGeometry.simplify(tolerance: 1.0)

        /// Build the final GeometryCollection that will be returned.
        var geometryCollection = GeometryCollection(precision: Floating(), coordinateSystem: Cartesian())
        if finalMultiPointGeometry.count > 0 {
            geometryCollection.append(finalMultiPointGeometry)
        }
        if finalMultiLineString.count > 0 {
            geometryCollection.append(finalMultiLineString)
        }

        /// Return
        return geometryCollection
    }

    ///
    /// Dimension .one and dimension .two
    ///

    /// Find the intersection of a segment, and a simple polygon, which is a regular polygon minus any holes, given that
    /// you have the locations where the segment and the linear ring, which is the boundary of the polygon, overlap.
    /// Note this is used in finding the intersection of a line string and a polygon.
    fileprivate func generateSimplePolygonIntersection(_ segment: Segment, _ polygon: Polygon, _ overlaps: [SegmentOverlap]) -> Geometry {

        /// Determine whether the first and last endpoints of the segment are inside or outside of the polygon.
        /// Being inside the polygon does include the boundary.
        let firstEndPointInPolygon = !relatedToGeneral((segment.leftCoordinate, true), polygon).firstTouchesSecondExteriorOnly
        let lastEndPointInPolygon = !relatedToGeneral((segment.rightCoordinate, true), polygon).firstTouchesSecondExteriorOnly

        /// Loop over the places where the segment overlaps the outer ring and build the intersection.
        /// The returned value will be a GeometryCollection, which may be empty.
        /// The GeometryCollection may contain two values, a MultiPoint and a MultiLineString.
        /// The MultiPoint will contain all the Points, and the MultiLineString will contain all the LineStrings.
        /// The MultiPoint and a MultiLineString will only be in the GeometryCollection if they are non-empty.

        var multiPointGeometry = MultiPoint(precision: Floating(), coordinateSystem: Cartesian())
        var multiLineStringGeometry = MultiLineString(precision: Floating(), coordinateSystem: Cartesian())

        /// Collect all intersections that will consist of Segments or Points.
        /// The Points can be duplicated, and they could be contained in one or more Segments.
        var startCoordinateOfPossibleInternalSegment: Coordinate?
        if firstEndPointInPolygon {
            startCoordinateOfPossibleInternalSegment = segment.leftCoordinate
        }
        for segmentOverlap in overlaps {
            if let newCoordinate = segmentOverlap.point?.coordinate {
                /// Handle the case where the segment and the segment of the linear ring touch at a point
                if let startCoordinate = startCoordinateOfPossibleInternalSegment {
                    if startCoordinate == newCoordinate {
                        continue
                    } else {
                        /// The start and end points differ.  This creates a segment.
                        /// This segment can lie inside or outside the linear ring.
                        /// Check the midpoint of the two endpoints to see if it is inside or outside of the polygon.
                        let midCoordinate = midpoint(startCoordinate, newCoordinate)
                        let midCoordinateInPolygon = !relatedToGeneral((midCoordinate, true), polygon).firstTouchesSecondExteriorOnly
                        if midCoordinateInPolygon {
                            multiLineStringGeometry.append(LineString([startCoordinate, newCoordinate]))
                        } else {
                            multiPointGeometry.append(Point(startCoordinate))
                        }
                        startCoordinateOfPossibleInternalSegment = newCoordinate
                    }
                } else {
                    startCoordinateOfPossibleInternalSegment = newCoordinate
                }
            } else if let newSegment = segmentOverlap.segment {
                /// Handle the case where the segment and the segment of the linear ring touch at a segment
                if let startCoordinate = startCoordinateOfPossibleInternalSegment {
                    if startCoordinate == newSegment.leftCoordinate {
                        multiLineStringGeometry.append(LineString([startCoordinate, newSegment.rightCoordinate]))
                        startCoordinateOfPossibleInternalSegment = newSegment.rightCoordinate
                    } else if startCoordinate == newSegment.rightCoordinate {
                        /// This else statement may not be needed
                        multiLineStringGeometry.append(LineString([startCoordinate, newSegment.leftCoordinate]))
                        startCoordinateOfPossibleInternalSegment = newSegment.leftCoordinate
                    }
                } else {
                    multiLineStringGeometry.append(LineString([newSegment.leftCoordinate, newSegment.rightCoordinate]))
                    startCoordinateOfPossibleInternalSegment = newSegment.rightCoordinate
                }
            }
        }

        /// We have looped over all the overlaps.  Check for a final point or segment.
        if let startCoordinate = startCoordinateOfPossibleInternalSegment {
            if startCoordinate != segment.rightCoordinate {
                /// The start coordinate and right coordinate of the segment differ and the start coordinate touches the linear ring.
                /// The creates a segment.  This segment can lie inside or outside the linear ring.
                /// Check the last endpoint of the segment to see if it is inside or outside of the polygon.
                if lastEndPointInPolygon {
                    multiLineStringGeometry.append(LineString([startCoordinate, segment.rightCoordinate]))
                } else {
                    multiPointGeometry.append(Point(startCoordinate))
                }
            } else {
                multiPointGeometry.append(Point(startCoordinate))
            }
        }

        /// Remove all Points that are duplicated or are contained in one of the LineStrings.
        let simplifiedMultiPoint = multiPointGeometry.simplify(tolerance: 1.0)
        var finalMultiPointGeometry = MultiPoint(precision: Floating(), coordinateSystem: Cartesian())

        for tempPoint in simplifiedMultiPoint {

            if let _ = intersection(tempPoint, multiLineStringGeometry) as? GeometryCollection {
                finalMultiPointGeometry.append(tempPoint)
            }
        }

        /// Simplify the LineStrings in the MultiLineString to minimize the total number of LineStrings.
        let finalMultiLineString = multiLineStringGeometry.simplify(tolerance: 1.0)

        /// Build the final GeometryCollection that will be returned.
        var geometryCollection = GeometryCollection(precision: Floating(), coordinateSystem: Cartesian())
        if finalMultiPointGeometry.count > 0 {
            geometryCollection.append(finalMultiPointGeometry)
        }
        if finalMultiLineString.count > 0 {
            geometryCollection.append(finalMultiLineString)
        }

        /// Return
        return geometryCollection
    }

    /// Given a segment, and a simple polygon, which is a hole in a polygon, and given that
    /// you have the locations where the segment and the linear ring, which is the boundary of the polygon, overlap,
    /// remove portions of the segment that are inside the hole.
    /// The result is an array of segments.
    /// Note this is used in finding the intersection of a line string and a polygon.
    fileprivate func removeSectionsInsideHole(_ segment: Segment, _ polygon: Polygon, _ overlaps: [SegmentOverlap]) -> [Segment] {

        /// Check that the two endpoints of the segment are not the same.
        guard segment.leftCoordinate != segment.rightCoordinate else {
            return [segment]
        }

        /// Collect all the coordinates at which the segment touches the hole.
        /// Note this collection will include the segment endpoints,
        /// and the first coordinate of the segment will be the first element.
        let segmentTouchesAtCoordinates = segmentCoordinates(segment, overlaps)

        /// Sort the coordinates of the points on the segment starting with the first coordinate
        /// and ending with the last coordinate of the segment.
        /// Note there should be at least two, since this will include the segment endpoints.
        let sortedSegmentCoordinates = sortSegmentCoordinates(segmentTouchesAtCoordinates)

        /// Determine if each pair of consecutive coordinates represents a segment that is inside or outside of the hole.
        /// Being inside the polygon does NOT include the boundary.
        /// This is because the polygon is a hole, and being on the boundary implies being part of the main polygon.
        /// If outside the hole, create and return a new line string.
        var segmentsArray = [Segment]()
        for index in 0..<sortedSegmentCoordinates.count - 1 {
            let coordinate1 = sortedSegmentCoordinates[index]
            let coordinate2 = sortedSegmentCoordinates[index + 1]
            let midCoordinate = midpoint(coordinate1, coordinate2)
            let midCoordinateInPolygon = relatedToGeneral((midCoordinate, true), polygon).firstTouchesSecondInteriorOnly
            if !midCoordinateInPolygon {
                segmentsArray.append(Segment(left: coordinate1, right: coordinate2))
            }
        }

        /// See if we can simplify the array of segments.
        var finalSegmentsArray = [Segment]()
        if segmentsArray.count > 0 {
            var currentSegment = segmentsArray[0]
            for index in 1..<segmentsArray.count {
                let newSegment = segmentsArray[index]
                if currentSegment.rightCoordinate == newSegment.leftCoordinate {
                    currentSegment = Segment(left: currentSegment.leftCoordinate, right: newSegment.rightCoordinate)
                } else {
                    finalSegmentsArray.append(currentSegment)
                    currentSegment = newSegment
                }
            }
            
            finalSegmentsArray.append(currentSegment)
        }

        /// Return
        return finalSegmentsArray
    }

    /// The polygon here is a full polygon with holes
    fileprivate func generateIntersection(_ lineString: LineString, _ polygon: Polygon) -> Geometry {

        /// Simplify each geometry first
        let simplifiedLineString = lineString.simplify(tolerance: 1.0)
        let simplifiedPolygon = polygon.simplify(tolerance: 1.0)

        /// Check the intersection of each line segment of both the line string and the linear ring.
        /// Determine whether each intersection of two points is either inside or outside the main linear ring,
        /// and whether the intersection passes through any holes.
        /// The returned value will be a GeometryCollection, which may be empty.
        /// The GeometryCollection may contain two values, a MultiPoint and a MultiLineString.
        /// The MultiPoint will contain all the Points, and the MultiLineString will contain all the LineStrings.
        /// The MultiPoint and a MultiLineString will only be in the GeometryCollection if they are non-empty.

        var multiPointGeometry = MultiPoint(precision: Floating(), coordinateSystem: Cartesian())
        var multiLineStringGeometry = MultiLineString(precision: Floating(), coordinateSystem: Cartesian())

        /// Loop over all the segments of the line string.
        /// Get all the place where each segment crosses over the outer linear ring.
        /// Determine which subsegments intersect the inside or outside of the outer linear ring.
        /// Points will always be included since they must touch on the boundary of any linear ring.
        /// Collect all intersections that will consist of LineStrings or Points.
        /// Note the LineStrings will really be Segments that potentially overlap each other.
        /// The Points can be duplicated, and they could be contained in one or more LineStrings.
        var outerMultiLineStringGeometry = MultiLineString(precision: Floating(), coordinateSystem: Cartesian())
        let outerLinearRing = simplifiedPolygon[0]
        let outerPolygon = Polygon(outerLinearRing)
        for ls1FirstCoordIndex in 0..<simplifiedLineString.count - 1 {
            let ls1FirstCoord  = simplifiedLineString[ls1FirstCoordIndex]
            let ls1SecondCoord = simplifiedLineString[ls1FirstCoordIndex + 1]
            let segment1 = Segment(left: ls1FirstCoord, right: ls1SecondCoord)

            /// Get the places where the segment intersects the outer linear ring.
            let segmentOverlaps = crosses(segment1, outerLinearRing, false)

            /// Get the intersection of the segment with a polygon made from just the outer linear ring.
            let outerIntersection = generateSimplePolygonIntersection(segment1, outerPolygon, segmentOverlaps)

            /// Append the intersections for this particular segment to the final collection of intersections
            if let geometryCollection = outerIntersection as? GeometryCollection {
                if geometryCollection.count > 0 {
                    if let segmentMultiPointGeometry = geometryCollection[0] as? MultiPoint {
                        multiPointGeometry += segmentMultiPointGeometry
                    } else if let segmentMultiLineStringGeometry = geometryCollection[0] as? MultiLineString {
                        outerMultiLineStringGeometry += segmentMultiLineStringGeometry
                    }
                }
                if geometryCollection.count > 1 {
                    if let segmentMultiLineStringGeometry = geometryCollection[1] as? MultiLineString {
                        outerMultiLineStringGeometry += segmentMultiLineStringGeometry
                    }
                }
            }
        }

        /// If there are holes in the polygon, loop over all the segments of each line string in the multi line string
        /// that resulted from the intersection of the initial line string and the main polygon minus the holes,
        /// and loop over all the holes in the polygon.  Remove those line segments that are inside the holes.
        /// The resulting set of line strings will be appended to the final set of line strings.
        ///
        /// If there are no holes, simply use the outer set of line strings as the final set of line strings.
        if simplifiedPolygon.count > 1 {
            /// There are holes
            for outerLineString in outerMultiLineStringGeometry {
                for ls1FirstCoordIndex in 0..<outerLineString.count - 1 {
                    let ls1FirstCoord  = outerLineString[ls1FirstCoordIndex]
                    let ls1SecondCoord = outerLineString[ls1FirstCoordIndex + 1]
                    let segment1 = Segment(left: ls1FirstCoord, right: ls1SecondCoord)

                    var segments = [segment1]
                    for linearRingIndex in 1..<simplifiedPolygon.count {
                        let innerLinearRing = simplifiedPolygon[linearRingIndex]
                        let innerPolygon = Polygon(innerLinearRing)
                        var tempSegmentsArray = [Segment]()
                        for currentSegment in segments {
                            /// Get the places where the segment intersects the hole.
                            let segmentOverlaps = crosses(currentSegment, innerLinearRing, false)

                            /// Collect all the points at which the segment touches the hole
                            let segmentTouchesAtPoints = points(segmentOverlaps)
                            if segmentTouchesAtPoints.count > 0 {
                                multiPointGeometry += segmentTouchesAtPoints
                            }

                            /// Remove the intersection of the segment with the hole and return the resulting segments array.
                            let segmentsAfterHolesRemoved = removeSectionsInsideHole(currentSegment, innerPolygon, segmentOverlaps)

                            /// Append the new segments to the temporary array of segments
                            tempSegmentsArray += segmentsAfterHolesRemoved
                        }

                        /// Update the segments array before seeing whether any of the segments overlaps the next hole.
                        segments = tempSegmentsArray
                    }

                    /// Append the intersections for this particular segment to the final collection of intersections.
                    /// Note a segment could be completely inside a hole, so an empty geometry collection will be returned.
                    for currentSegment in segments {
                        multiLineStringGeometry.append(LineString([currentSegment.leftCoordinate, currentSegment.rightCoordinate]))
                    }
                }
            }
        } else {
            /// There are no holes
            multiLineStringGeometry += outerMultiLineStringGeometry
        }

        /// Remove all Points that are duplicated or are contained in one of the LineStrings.
        let simplifiedMultiPoint = multiPointGeometry.simplify(tolerance: 1.0)
        var finalMultiPointGeometry = MultiPoint(precision: Floating(), coordinateSystem: Cartesian())

        for tempPoint in simplifiedMultiPoint {

            if let _ = intersection(tempPoint, multiLineStringGeometry) as? GeometryCollection {
                finalMultiPointGeometry.append(tempPoint)
            }
        }

        /// Simplify the LineStrings in the MultiLineString to minimize the total number of LineStrings.
        let finalMultiLineString = multiLineStringGeometry.simplify(tolerance: 1.0)

        /// Build the final GeometryCollection that will be returned.
        var geometryCollection = GeometryCollection(precision: Floating(), coordinateSystem: Cartesian())
        if finalMultiPointGeometry.count > 0 {
            geometryCollection.append(finalMultiPointGeometry)
        }
        if finalMultiLineString.count > 0 {
            geometryCollection.append(finalMultiLineString)
        }

        /// Return
        return geometryCollection
    }

    fileprivate func generateIntersection(_ lineString: LineString, _ multipolygon: MultiPolygon) -> Geometry {

        /// Simplify each geometry first
        let simplifiedLineString = lineString.simplify(tolerance: 1.0)
        let simplifiedMultiPolygon = multipolygon.simplify(tolerance: 1.0)

        /// Perform the intersection calculation.
        /// The returned value will be a GeometryCollection, which may be empty.
        /// The GeometryCollection may contain two values, a MultiPoint and a MultiLineString.
        /// The MultiPoint will contain all the Points, and the MultiLineString will contain all the LineStrings.
        /// The MultiPoint and a MultiLineString will only be in the GeometryCollection if they are non-empty.

        var multiPointGeometry = MultiPoint(precision: Floating(), coordinateSystem: Cartesian())
        var multiLineStringGeometry = MultiLineString(precision: Floating(), coordinateSystem: Cartesian())

        /// Collect all intersections that will consist of LineStrings or Points.
        /// Note the LineStrings will really be Segments that potentially overlap each other.
        /// The Points can be duplicated, and they could be contained in one or more LineStrings.
        for polygon in simplifiedMultiPolygon {
            /// We assume each polygon has been simplified because the MultiPolgyon was simplified.
            let resultGeometry = generateIntersection(simplifiedLineString, polygon)
            guard let resultGeometryCollection = resultGeometry as? GeometryCollection else {
                continue
            }

            for tempGeometry in resultGeometryCollection {
                if let tempMultiPoint = tempGeometry as? MultiPoint {
                    multiPointGeometry += tempMultiPoint
                } else if let tempMultiLineString = tempGeometry as? MultiLineString {
                    multiLineStringGeometry += tempMultiLineString
                }
            }
        }

        /// Remove all Points that are duplicated or are contained in one of the LineStrings.
        let simplifiedMultiPoint = multiPointGeometry.simplify(tolerance: 1.0)
        var finalMultiPointGeometry = MultiPoint(precision: Floating(), coordinateSystem: Cartesian())

        for tempPoint in simplifiedMultiPoint {

            if let _ = intersection(tempPoint, multiLineStringGeometry) as? GeometryCollection {
                finalMultiPointGeometry.append(tempPoint)
            }
        }

        /// Simplify the LineStrings in the MultiLineString to minimize the total number of LineStrings.
        let finalMultiLineString = multiLineStringGeometry.simplify(tolerance: 1.0)

        /// Build the final GeometryCollection that will be returned.
        var geometryCollection = GeometryCollection(precision: Floating(), coordinateSystem: Cartesian())
        if finalMultiPointGeometry.count > 0 {
            geometryCollection.append(finalMultiPointGeometry)
        }
        if finalMultiLineString.count > 0 {
            geometryCollection.append(finalMultiLineString)
        }

        /// Return
        return geometryCollection
    }

    fileprivate func generateIntersection(_ linearRing: LinearRing, _ polygon: Polygon) -> Geometry {

        /// Convert the linear ring to a line string, and calculate the intersection from that.
        let lineString = linearRing.convertToLineString()
        return generateIntersection(lineString, polygon)
    }

    fileprivate func generateIntersection(_ linearRing: LinearRing, _ multipolygon: MultiPolygon) -> Geometry {

        /// Convert the linear ring to a line string, and calculate the intersection from that.
        let lineString = linearRing.convertToLineString()
        return generateIntersection(lineString, multipolygon)
    }

    fileprivate func generateIntersection(_ multiLineString: MultiLineString, _ polygon: Polygon) -> Geometry {

        /// Simplify each geometry first
        let simplifiedMultiLineString = multiLineString.simplify(tolerance: 1.0)
        let simplifiedPolygon = polygon.simplify(tolerance: 1.0)

        /// Calculate the intersection of each line string with the polygon and add those intersections together.
        /// The returned value will be a GeometryCollection, which may be empty.
        /// The GeometryCollection may contain two values, a MultiPoint and a MultiLineString.
        /// The MultiPoint will contain all the Points, and the MultiLineString will contain all the LineStrings.
        /// The MultiPoint and a MultiLineString will only be in the GeometryCollection if they are non-empty.

        var multiPointGeometry = MultiPoint(precision: Floating(), coordinateSystem: Cartesian())
        var multiLineStringGeometry = MultiLineString(precision: Floating(), coordinateSystem: Cartesian())

        /// Loop over all the line strings of the multi line string.
        /// Combine the results of each intersection.
        for simplifiedLineString in simplifiedMultiLineString {
            let resultGeometry = generateIntersection(simplifiedLineString, simplifiedPolygon)
            guard let resultGeometryCollection = resultGeometry as? GeometryCollection else {
                continue
            }

            for tempGeometry in resultGeometryCollection {
                if let tempMultiPoint = tempGeometry as? MultiPoint {
                    multiPointGeometry += tempMultiPoint
                } else if let tempMultiLineString = tempGeometry as? MultiLineString {
                    multiLineStringGeometry += tempMultiLineString
                }
            }
        }

        /// Remove all Points that are duplicated or are contained in one of the LineStrings.
        let simplifiedMultiPoint = multiPointGeometry.simplify(tolerance: 1.0)
        var finalMultiPointGeometry = MultiPoint(precision: Floating(), coordinateSystem: Cartesian())

        for tempPoint in simplifiedMultiPoint {

            if let _ = intersection(tempPoint, multiLineStringGeometry) as? GeometryCollection {
                finalMultiPointGeometry.append(tempPoint)
            }
        }

        /// Simplify the LineStrings in the MultiLineString to minimize the total number of LineStrings.
        let finalMultiLineString = multiLineStringGeometry.simplify(tolerance: 1.0)

        /// Build the final GeometryCollection that will be returned.
        var geometryCollection = GeometryCollection(precision: Floating(), coordinateSystem: Cartesian())
        if finalMultiPointGeometry.count > 0 {
            geometryCollection.append(finalMultiPointGeometry)
        }
        if finalMultiLineString.count > 0 {
            geometryCollection.append(finalMultiLineString)
        }

        /// Return
        return geometryCollection
    }

    fileprivate func generateIntersection(_ multiLineString: MultiLineString, _ multipolygon: MultiPolygon) -> Geometry {

        /// Simplify each geometry first
        let simplifiedMultiLineString = multiLineString.simplify(tolerance: 1.0)
        let simplifiedMultiPolygon = multipolygon.simplify(tolerance: 1.0)

        /// Calculate the intersection of each line string with the polygon and add those intersections together.
        /// The returned value will be a GeometryCollection, which may be empty.
        /// The GeometryCollection may contain two values, a MultiPoint and a MultiLineString.
        /// The MultiPoint will contain all the Points, and the MultiLineString will contain all the LineStrings.
        /// The MultiPoint and a MultiLineString will only be in the GeometryCollection if they are non-empty.

        var multiPointGeometry = MultiPoint(precision: Floating(), coordinateSystem: Cartesian())
        var multiLineStringGeometry = MultiLineString(precision: Floating(), coordinateSystem: Cartesian())

        /// Loop over all the line strings of the multi line string.
        /// Loop over all the polygons of the multi polygon.
        /// Combine the results of each intersection.
        for lineString in simplifiedMultiLineString {
            for polygon in simplifiedMultiPolygon {
                let resultGeometry = generateIntersection(lineString, polygon)
                guard let resultGeometryCollection = resultGeometry as? GeometryCollection else {
                    continue
                }

                for tempGeometry in resultGeometryCollection {
                    if let tempMultiPoint = tempGeometry as? MultiPoint {
                        multiPointGeometry += tempMultiPoint
                    } else if let tempMultiLineString = tempGeometry as? MultiLineString {
                        multiLineStringGeometry += tempMultiLineString
                    }
                }
            }
        }

        /// Remove all Points that are duplicated or are contained in one of the LineStrings.
        let simplifiedMultiPoint = multiPointGeometry.simplify(tolerance: 1.0)
        var finalMultiPointGeometry = MultiPoint(precision: Floating(), coordinateSystem: Cartesian())

        for tempPoint in simplifiedMultiPoint {

            if let _ = intersection(tempPoint, multiLineStringGeometry) as? GeometryCollection {
                finalMultiPointGeometry.append(tempPoint)
            }
        }

        /// Simplify the LineStrings in the MultiLineString to minimize the total number of LineStrings.
        let finalMultiLineString = multiLineStringGeometry.simplify(tolerance: 1.0)

        /// Build the final GeometryCollection that will be returned.
        var geometryCollection = GeometryCollection(precision: Floating(), coordinateSystem: Cartesian())
        if finalMultiPointGeometry.count > 0 {
            geometryCollection.append(finalMultiPointGeometry)
        }
        if finalMultiLineString.count > 0 {
            geometryCollection.append(finalMultiLineString)
        }

        /// Return
        return geometryCollection
    }

//    ///
//    /// Dimension .two and dimension .two
//    ///
//
//    fileprivate static func generateIntersection(_ polygon1: Polygon, _ polygon2: Polygon) -> IntersectionMatrix {
//
//        /// Default intersection matrix
//        var matrixIntersects = IntersectionMatrix()
//
//        let relatedTo = relatedToFull(polygon1, polygon2)
//
//        matrixIntersects[.interior, .interior] = relatedTo.firstInteriorTouchesSecondInterior
//        matrixIntersects[.interior, .boundary] = relatedTo.firstInteriorTouchesSecondBoundary
//        matrixIntersects[.interior, .exterior] = relatedTo.firstInteriorTouchesSecondExterior
//
//        matrixIntersects[.boundary, .interior] = relatedTo.firstBoundaryTouchesSecondInterior
//        matrixIntersects[.boundary, .boundary] = relatedTo.firstBoundaryTouchesSecondBoundary
//        matrixIntersects[.boundary, .exterior] = relatedTo.firstBoundaryTouchesSecondExterior
//
//        matrixIntersects[.exterior, .interior] = relatedTo.firstExteriorTouchesSecondInterior
//        matrixIntersects[.exterior, .boundary] = relatedTo.firstExteriorTouchesSecondBoundary
//        matrixIntersects[.exterior, .exterior] = relatedTo.firstExteriorTouchesSecondExterior
//
//        /// No intersection
//        return matrixIntersects
//    }
//
//    fileprivate static func generateIntersection(_ polygon: Polygon, _ multipolygon: MultiPolygon) -> IntersectionMatrix {
//
//        var matrixIntersects = IntersectionMatrix()
//
//        /// Loop over the polygons and update the matrixIntersects struct as needed on each pass.
//
//        for polygonFromMP in multipolygon {
//
//            /// Get the relationship between the point and the polygon
//            let intersectionMatrixResult = generateIntersection(polygon, polygonFromMP)
//
//            /// Update the intersection matrix as needed
//            update(intersectionMatrixBase: &matrixIntersects, intersectionMatrixNew: intersectionMatrixResult)
//
//        }
//
//        return matrixIntersects
//    }
//
//    fileprivate static func generateIntersection(_ multipolygon1: MultiPolygon, _ multipolygon2: MultiPolygon) -> IntersectionMatrix {
//
//        var matrixIntersects = IntersectionMatrix()
//
//        /// Loop over the polygons and update the matrixIntersects struct as needed on each pass.
//
//        for polygonFromMP in multipolygon1 {
//
//            /// Get the relationship between the point and the polygon
//            let intersectionMatrixResult = generateIntersection(polygonFromMP, multipolygon2)
//
//            /// Update the intersection matrix as needed
//            update(intersectionMatrixBase: &matrixIntersects, intersectionMatrixNew: intersectionMatrixResult)
//
//        }
//
//        return matrixIntersects
//    }
//}
