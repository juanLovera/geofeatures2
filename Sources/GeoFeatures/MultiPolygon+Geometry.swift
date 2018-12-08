///
///  MultiPolygon+Geometry.swift
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
///  Created by Tony Stone on 2/15/2016.
///
import Swift

///
/// `Geometry` protocol implementation.
///
extension MultiPolygon {

    ///
    /// The spatial dimension of `self`.
    ///
    /// - Returns: .two if non-empty, or .empty otherwise.
    ///
    /// - SeeAlso: Dimension
    ///
    public var dimension: Dimension {
        return self.isEmpty() ? .empty : .two
    }

    ///
    /// - Returns: the closure of the combinatorial boundary of this Geometry instance.
    ///
    /// - Note: The boundary of a MultiPolygon is a set of closed Curves (LineStrings) corresponding to the boundaries of its element Polygons. Each Curve in the boundary of the MultiPolygon is in the boundary of exactly 1 element Polygon, and every Curve in the boundary of an element Polygon is in the boundary of the MultiPolygon.
    ///
    public func boundary() -> Geometry {
        var boundary = MultiLineString(precision: self.precision, coordinateSystem: self.coordinateSystem)

        for i in 0..<self.count {
            if let elementBoundary = self[i].boundary() as? MultiLineString {
                for lineString in elementBoundary {
                    boundary.append(lineString)
                }
            }
        }
        return boundary
    }

    ///
    /// - Returns: true if `self` is equal to the `other`.
    ///
    public func equals(_ other: Geometry) -> Bool {
        if let other = other as? MultiPolygon{
            return self.elementsEqual(other, by: { (lhs: Polygon, rhs: Polygon) -> Bool in
                return lhs.equals(rhs)
            })
        }
        return false
    }

    ///
    /// Reduces the geometry to its simplest form, the simplest sequence of points or coordinates,
    /// that is topologically equivalent to the original geometry.  In essence, this function removes
    /// duplication and intermediate coordinates that do not contribute to the overall definition.
    ///
    /// Reducing a MultiPolygon means reducing each Polygon.  Note that no combining of the Polygons
    /// is needed because we assume this is a valid MultiPolygon.
    ///
    /// - Returns: the simplified geometry of the same type as the original
    ///
    public func simplify(tolerance: Double) -> MultiPolygon {

        /// Part 1 - simplify each polygon
        var resultMultiPolygon1 = MultiPolygon()
        for polygon in self {
            let resultPolygon = polygon.simplify(tolerance: 1.0)
            resultMultiPolygon1.append(resultPolygon)
        }

        return resultMultiPolygon1
    }
}
