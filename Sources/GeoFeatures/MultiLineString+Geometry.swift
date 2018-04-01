///
///  MultiLineString+Geometry.swift
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

extension MultiLineString: Geometry {

    public var dimension: Dimension { return .one }

    public func isEmpty() -> Bool {
        return self.count == 0
    }

    ///
    /// - Returns: the closure of the combinatorial boundary of this Geometry instance.
    ///
    /// - Note: The boundary of a MultiCurve is obtained by applying the “mod 2” union rule: A Point is in the boundary of a
    ///         MultiCurve if it is in the boundaries of an odd number of elements of the MultiCurve (Reference [1], section
    ///         3.12.3.2).
    ///
    public func boundary() -> Geometry {

        var endCoordinates = [Coordinate: Int]()

        for i in 0 ..< elements.count {
            let lineString = elements[i]

            if lineString.count >= 2 && !lineString.isClosed() {
                var i = 0

                /// Start point
                if var count = endCoordinates[lineString[i]] {
                    count += 1

                    endCoordinates[lineString[i]] = count

                } else {
                    endCoordinates[lineString[i]] = 1
                }

                i = lineString.count - 1

                /// End point
                if var count = endCoordinates[lineString[i]] {
                    count += 1

                    endCoordinates[lineString[i]] = count

                } else {
                    endCoordinates[lineString[i]] = 1
                }
            }
        }

        var boundary = MultiPoint(precision: self.precision, coordinateSystem: self.coordinateSystem)

        for (coordinate, count) in endCoordinates {
            if count % 2 == 1 {
                boundary.append(Point(coordinate: coordinate, precision: self.precision, coordinateSystem: self.coordinateSystem))
            }
        }
        return boundary
    }

    ///
    /// The min and max X Y values that make up the bounding coordinates of `self`.
    ///
    /// - Returns: `Bounds` instance containing the minX, minY, maxX, maxY values bounding `self` or nil if the `self` is empty.
    ///
    public func bounds() -> Bounds? {

        let bounds = self.elements.flatMap { $0.bounds() }

        guard bounds.count > 0
            else { return nil }

        return bounds.reduce(bounds[0], { $0.expand(other: $1) })
    }

    public func equals(_ other: Geometry) -> Bool {
        if let other = other as? MultiLineString {
            return self.elementsEqual(other)
        }
        return false
    }
}
