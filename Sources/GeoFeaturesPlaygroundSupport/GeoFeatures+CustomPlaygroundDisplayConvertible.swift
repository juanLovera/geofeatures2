///
///  GeoFeatures+CustomPlaygroundDisplayConvertible.swift
///
/// Copyright (c) Tony Stone, All rights reserved.
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
/// Created by Tony Stone on 3/16/18.
///

#if os(OSX) || os(iOS)

import GeoFeatures
import GeoFeaturesQuartz

#if swift(>=4.1) || swift(>=3.3) && !swift(>=4.0)

    // With Swift 4.1 and later (including Swift 3.3 and later), implement CustomPlaygroundDisplayConvertible.
    // extension MyType: CustomPlaygroundDisplayConvertible { /…/ }

    ///
    /// Point CustomPlaygroundDisplayConvertible implementation
    ///
    extension GeoFeatures.Point: CustomPlaygroundDisplayConvertible {

        public var playgroundDescription: Any {
            switch self.coordinateSystem {
            case is Cartesian:  return CartesianGeometryVisualizationView(geometry: self)
            case is Geographic: return "Map goes here"
            default:
                return String(describing: self)  /// Defaults to the default description should the coordinate system not be supported.
            }
        }
    }

    ///
    /// LineString CustomPlaygroundDisplayConvertible implementation
    ///
    extension GeoFeatures.LineString: CustomPlaygroundDisplayConvertible {

        public var playgroundDescription: Any {
            switch self.coordinateSystem {
            case is Cartesian:  return CartesianGeometryVisualizationView(geometry: self)
            case is Geographic: return "Map goes here"
            default:
                return String(describing: self)  /// Defaults to the default description should the coordinate system not be supported.
            }
        }
    }

    ///
    /// LinearRing CustomPlaygroundDisplayConvertible implementation
    ///
    extension GeoFeatures.LinearRing: CustomPlaygroundDisplayConvertible {

        public var playgroundDescription: Any {
            switch self.coordinateSystem {
            case is Cartesian:  return CartesianGeometryVisualizationView(geometry: self)
            case is Geographic: return "Map goes here"
            default:
                return String(describing: self)  /// Defaults to the default description should the coordinate system not be supported.
            }
        }
    }

    ///
    /// Polygon CustomPlaygroundDisplayConvertible implementation
    ///
    extension GeoFeatures.Polygon: CustomPlaygroundDisplayConvertible {

        public var playgroundDescription: Any {
            switch self.coordinateSystem {
            case is Cartesian:  return CartesianGeometryVisualizationView(geometry: self)
            case is Geographic: return "Map goes here"
            default:
                return String(describing: self)  /// Defaults to the default description should the coordinate system not be supported.
            }
        }
    }

    ///
    /// MultiPoint CustomPlaygroundDisplayConvertible implementation
    ///
    extension GeoFeatures.MultiPoint: CustomPlaygroundDisplayConvertible {

        public var playgroundDescription: Any {
            switch self.coordinateSystem {
            case is Cartesian:  return CartesianGeometryVisualizationView(geometry: self)
            case is Geographic: return "Map goes here"
            default:
                return String(describing: self)  /// Defaults to the default description should the coordinate system not be supported.
            }
        }
    }

    ///
    /// MultiLineString CustomPlaygroundDisplayConvertible implementation
    ///
    extension GeoFeatures.MultiLineString: CustomPlaygroundDisplayConvertible {

        public var playgroundDescription: Any {
            switch self.coordinateSystem {
            case is Cartesian:  return CartesianGeometryVisualizationView(geometry: self)
            case is Geographic: return "Map goes here"
            default:
                return String(describing: self)  /// Defaults to the default description should the coordinate system not be supported.
            }
        }
    }

    ///
    /// MultiPolygon CustomPlaygroundDisplayConvertible implementation
    ///
    extension GeoFeatures.MultiPolygon: CustomPlaygroundDisplayConvertible {

        public var playgroundDescription: Any {
            switch self.coordinateSystem {
            case is Cartesian:  return CartesianGeometryVisualizationView(geometry: self)
            case is Geographic: return "Map goes here"
            default:
                return String(describing: self)  /// Defaults to the default description should the coordinate system not be supported.
            }
        }
    }

    ///
    /// GeometryCollection CustomPlaygroundDisplayConvertible implementation
    ///
    extension GeoFeatures.GeometryCollection: CustomPlaygroundDisplayConvertible {

        public var playgroundDescription: Any {
            switch self.coordinateSystem {
            case is Cartesian:  return CartesianGeometryVisualizationView(geometry: self)
            case is Geographic: return "Map goes here"
            default:
                return String(describing: self)  /// Defaults to the default description should the coordinate system not be supported.
            }
        }
    }


#else
    // Otherwise, on Swift 4.0 and Swift 3.2 and earlier, implement CustomPlaygroundQuickLookable.
    // extension MyType: CustomPlaygroundQuickLookable { /…/ }

    ///
    /// Point CustomPlaygroundQuickLookable implementation
    ///
    extension GeoFeatures.Point: CustomPlaygroundQuickLookable {

        public var customPlaygroundQuickLook: PlaygroundQuickLook  {
            switch self.coordinateSystem {
            case is Cartesian:  return .view( GeometryVisualizationView(geometry: self))
            case is Geographic: return .text("Map goes here")
            default:
                return .text(String(describing: self))  /// Defaults to the default description should the coordinate system not be supported.
            }
        }
    }
    ///
    /// LineString CustomPlaygroundQuickLookable implementation
    ///
    extension GeoFeatures.LineString: CustomPlaygroundQuickLookable {

        public var customPlaygroundQuickLook: PlaygroundQuickLook  {
            switch self.coordinateSystem {
            case is Cartesian:  return .view( GeometryVisualizationView(geometry: self))
            case is Geographic: return .text("Map goes here")
            default:
                return .text(String(describing: self))  /// Defaults to the default description should the coordinate system not be supported.
            }
        }
    }
    ///
    /// LinearRing CustomPlaygroundQuickLookable implementation
    ///
    extension GeoFeatures.LinearRing: CustomPlaygroundQuickLookable {

        public var customPlaygroundQuickLook: PlaygroundQuickLook  {
            switch self.coordinateSystem {
            case is Cartesian:  return .view( GeometryVisualizationView(geometry: self))
            case is Geographic: return .text("Map goes here")
            default:
                return .text(String(describing: self))  /// Defaults to the default description should the coordinate system not be supported.
            }
        }
    }
    ///
    /// Polygon CustomPlaygroundQuickLookable implementation
    ///
    extension GeoFeatures.Polygon: CustomPlaygroundQuickLookable {

        public var customPlaygroundQuickLook: PlaygroundQuickLook  {
            switch self.coordinateSystem {
            case is Cartesian:  return .view( GeometryVisualizationView(geometry: self))
            case is Geographic: return .text("Map goes here")
            default:
                return .text(String(describing: self))  /// Defaults to the default description should the coordinate system not be supported.
            }
        }
    }
    ///
    /// MultiPoint CustomPlaygroundQuickLookable implementation
    ///
    extension GeoFeatures.MultiPoint: CustomPlaygroundQuickLookable {

        public var customPlaygroundQuickLook: PlaygroundQuickLook  {
            switch self.coordinateSystem {
            case is Cartesian:  return .view( GeometryVisualizationView(geometry: self))
            case is Geographic: return .text("Map goes here")
            default:
                return .text(String(describing: self))  /// Defaults to the default description should the coordinate system not be supported.
            }
        }
    }
    ///
    /// MultiLineString CustomPlaygroundQuickLookable implementation
    ///
    extension GeoFeatures.MultiLineString: CustomPlaygroundQuickLookable {

        public var customPlaygroundQuickLook: PlaygroundQuickLook  {
            switch self.coordinateSystem {
            case is Cartesian:  return .view( GeometryVisualizationView(geometry: self))
            case is Geographic: return .text("Map goes here")
            default:
                return .text(String(describing: self))  /// Defaults to the default description should the coordinate system not be supported.
            }
        }
    }
    ///
    /// MultiPolygon CustomPlaygroundQuickLookable implementation
    ///
    extension GeoFeatures.MultiPolygon: CustomPlaygroundQuickLookable {

        public var customPlaygroundQuickLook: PlaygroundQuickLook  {
            switch self.coordinateSystem {
            case is Cartesian:  return .view( GeometryVisualizationView(geometry: self))
            case is Geographic: return .text("Map goes here")
            default:
                return .text(String(describing: self))  /// Defaults to the default description should the coordinate system not be supported.
            }
        }
    }
    ///
    /// GeometryCollection CustomPlaygroundQuickLookable implementation
    ///
    extension GeoFeatures.GeometryCollection: CustomPlaygroundQuickLookable {

        public var customPlaygroundQuickLook: PlaygroundQuickLook  {
            switch self.coordinateSystem {
            case is Cartesian:  return .view( GeometryVisualizationView(geometry: self))
            case is Geographic: return .text("Map goes here")
            default:
                return .text(String(describing: self))  /// Defaults to the default description should the coordinate system not be supported.
            }
        }
    }

#endif

#endif

