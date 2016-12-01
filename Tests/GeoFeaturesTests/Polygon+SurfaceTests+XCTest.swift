///
/// Polygon+SurfaceTests+XCTest.swift
///
/// Copyright 2016 Tony Stone
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
///  Created by Tony Stone on 5/4/16.
///
import XCTest

///
/// NOTE: This file was auto generated by file process_test_files.rb.
///
/// Do NOT edit this file directly as it will be regenerated automatically when needed.
///

extension Polygon_Surface_Coordinate2D_FixedPrecision_Cartesian_Tests {

   static var allTests: [(String, (Polygon_Surface_Coordinate2D_FixedPrecision_Cartesian_Tests) -> () throws -> Void)] {
      return [
                ("testArea_Empty", testArea_Empty),
                ("testArea_Triangle", testArea_Triangle),
                ("testArea_RegularQuadrilateral", testArea_RegularQuadrilateral),
                ("testArea_SimplePolygon1", testArea_SimplePolygon1),
                ("testArea_SimplePolygon2", testArea_SimplePolygon2),
                ("testArea_SimplePolygon3", testArea_SimplePolygon3),
                ("testArea_SimplePolygon_WithHole", testArea_SimplePolygon_WithHole),
                ("testArea_Pentagon", testArea_Pentagon),
                ("testArea_RegularPentagon", testArea_RegularPentagon),
                ("testArea_RegularDecagon", testArea_RegularDecagon),
                ("testArea_Tetrakaidecagon", testArea_Tetrakaidecagon),
                ("testArea_RegularQuadrilateral_CrossingOrigin", testArea_RegularQuadrilateral_CrossingOrigin),
                ("testPerformanceArea_Quadrilateral", testPerformanceArea_Quadrilateral)
           ]
   }
}
