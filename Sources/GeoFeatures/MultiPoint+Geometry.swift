///
///  MultiPoint+Geometry.swift
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

extension MultiPoint: Geometry {

    public var dimension: Dimension { return .zero }

    public func isEmpty() -> Bool {
        return self.count == 0
    }

    ///
    /// - Returns: the closure of the combinatorial boundary of this Geometry instance.
    ///
    /// - Note: The boundary of a MultiPoint is the empty set.
    ///
    public func boundary() -> Geometry {
        return MultiPoint(precision: self.precision, coordinateSystem: self.coordinateSystem)
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
        if let other = other as? MultiPoint {
            return self.elementsEqual(other)
        }
        return false
    }
}
