///
/// IntersectionMatrix+HelpersTests+XCTest.swift
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

extension IntersectionMatrixHelperTests {

   static var allTests: [(String, (IntersectionMatrixHelperTests) -> () throws -> Void)] {
      return [
                ("testPoint_Point_noIntersection", testPoint_Point_noIntersection),
                ("testPoint_Point_identicalPoints", testPoint_Point_identicalPoints),
                ("testPoint_MultiPoint_noIntersection", testPoint_MultiPoint_noIntersection),
                ("testPoint_MultiPoint_firstProperSubsetOfSecond", testPoint_MultiPoint_firstProperSubsetOfSecond),
                ("testPoint_MultiPoint_firstImproperSubsetOfSecond", testPoint_MultiPoint_firstImproperSubsetOfSecond),
                ("testMultiPoint_Point_noIntersection", testMultiPoint_Point_noIntersection),
                ("testMultiPoint_Point_secondProperSubsetOfFirst", testMultiPoint_Point_secondProperSubsetOfFirst),
                ("testMultiPoint_Point_secondImproperSubsetOfFirst", testMultiPoint_Point_secondImproperSubsetOfFirst),
                ("testMultiPoint_MultiPoint_noIntersection", testMultiPoint_MultiPoint_noIntersection),
                ("testMultiPoint_MultiPoint_firstIntersectsSecondButNotSubset", testMultiPoint_MultiPoint_firstIntersectsSecondButNotSubset),
                ("testMultiPoint_MultiPoint_firstProperSubsetOfSecond", testMultiPoint_MultiPoint_firstProperSubsetOfSecond),
                ("testMultiPoint_MultiPoint_secondProperSubsetOfFirst", testMultiPoint_MultiPoint_secondProperSubsetOfFirst),
                ("testMultiPoint_MultiPoint_firstImproperSubsetOfSecond", testMultiPoint_MultiPoint_firstImproperSubsetOfSecond),
                ("testPoint_LineString_noIntersection", testPoint_LineString_noIntersection),
                ("testPoint_LineString_firstSubsetOfSecondInterior", testPoint_LineString_firstSubsetOfSecondInterior),
                ("testPoint_LineString_firstSubsetOfSecondBoundary", testPoint_LineString_firstSubsetOfSecondBoundary),
                ("testPoint_LinearRing_noIntersection", testPoint_LinearRing_noIntersection),
                ("testPoint_LinearRing_firstSubsetOfSecondInterior", testPoint_LinearRing_firstSubsetOfSecondInterior),
                ("testPoint_MultiLineString_noIntersection", testPoint_MultiLineString_noIntersection),
                ("testPoint_MultiLineString_firstSubsetOfSecondInterior", testPoint_MultiLineString_firstSubsetOfSecondInterior),
                ("testPoint_MultiLineString_firstSubsetOfSecondBoundary", testPoint_MultiLineString_firstSubsetOfSecondBoundary),
                ("testMultiPoint_LineString_noIntersection", testMultiPoint_LineString_noIntersection),
                ("testMultiPoint_LineString_firstSubsetOfSecondInterior", testMultiPoint_LineString_firstSubsetOfSecondInterior),
                ("testMultiPoint_LineString_firstProperSubsetOfSecondBoundary", testMultiPoint_LineString_firstProperSubsetOfSecondBoundary),
                ("testMultiPoint_LineString_firstImproperSubsetOfSecondBoundary", testMultiPoint_LineString_firstImproperSubsetOfSecondBoundary),
                ("testMultiPoint_LineString_firstTouchesSecondInteriorAndBoundary", testMultiPoint_LineString_firstTouchesSecondInteriorAndBoundary),
                ("testMultiPoint_LineString_firstTouchesSecondInteriorAndCoversBoundary", testMultiPoint_LineString_firstTouchesSecondInteriorAndCoversBoundary),
                ("testMultiPoint_LineString_firstTouchesSecondInteriorAndExterior", testMultiPoint_LineString_firstTouchesSecondInteriorAndExterior),
                ("testMultiPoint_LineString_firstTouchesSecondBoundaryAndExterior", testMultiPoint_LineString_firstTouchesSecondBoundaryAndExterior),
                ("testMultiPoint_LineString_firstCoversSecondBoundaryAndTouchesExterior", testMultiPoint_LineString_firstCoversSecondBoundaryAndTouchesExterior),
                ("testMultiPoint_LineString_firstTouchesSecondInteriorAndBoundaryAndExterior", testMultiPoint_LineString_firstTouchesSecondInteriorAndBoundaryAndExterior),
                ("testMultiPoint_LineString_firstTouchesSecondInteriorAndExteriorAndCoversBoundary", testMultiPoint_LineString_firstTouchesSecondInteriorAndExteriorAndCoversBoundary),
                ("testMultiPoint_LinearRing_noIntersection", testMultiPoint_LinearRing_noIntersection),
                ("testMultiPoint_LinearRing_firstSubsetOfSecondInterior", testMultiPoint_LinearRing_firstSubsetOfSecondInterior),
                ("testMultiPoint_LinearRing_firstTouchesSecondInteriorAndExterior", testMultiPoint_LinearRing_firstTouchesSecondInteriorAndExterior),
                ("testMultiPoint_MultiLineString_noIntersection", testMultiPoint_MultiLineString_noIntersection),
                ("testMultiPoint_MultiLineString_firstSubsetOfSecondInterior", testMultiPoint_MultiLineString_firstSubsetOfSecondInterior),
                ("testMultiPoint_MultiLineString_firstProperSubsetOfSecondBoundary", testMultiPoint_MultiLineString_firstProperSubsetOfSecondBoundary),
                ("testMultiPoint_MultiLineString_firstImproperSubsetOfSecondBoundary", testMultiPoint_MultiLineString_firstImproperSubsetOfSecondBoundary),
                ("testMultiPoint_MultiLineString_firstTouchesSecondInteriorAndBoundary", testMultiPoint_MultiLineString_firstTouchesSecondInteriorAndBoundary),
                ("testMultiPoint_MultiLineString_firstTouchesSecondInteriorAndCoversBoundary", testMultiPoint_MultiLineString_firstTouchesSecondInteriorAndCoversBoundary),
                ("testMultiPoint_MultiLineString_firstTouchesSecondInteriorAndExterior", testMultiPoint_MultiLineString_firstTouchesSecondInteriorAndExterior),
                ("testMultiPoint_MultiLineString_firstTouchesSecondBoundaryAndExterior", testMultiPoint_MultiLineString_firstTouchesSecondBoundaryAndExterior),
                ("testMultiPoint_MultiLineString_firstCoversSecondBoundaryAndTouchesExterior", testMultiPoint_MultiLineString_firstCoversSecondBoundaryAndTouchesExterior),
                ("testMultiPoint_MultiLineString_firstTouchesSecondInteriorAndBoundaryAndExterior", testMultiPoint_MultiLineString_firstTouchesSecondInteriorAndBoundaryAndExterior),
                ("testMultiPoint_MultiLineString_firstTouchesSecondInteriorAndExteriorAndCoversBoundary", testMultiPoint_MultiLineString_firstTouchesSecondInteriorAndExteriorAndCoversBoundary),
                ("testPoint_Polygon_outerRingOnly_noIntersection", testPoint_Polygon_outerRingOnly_noIntersection),
                ("testPoint_Polygon_outerRingAndInnerRing_outsideMainRing_noIntersection", testPoint_Polygon_outerRingAndInnerRing_outsideMainRing_noIntersection),
                ("testPoint_Polygon_outerRingAndInnerRing_insideInnerRing_noIntersection", testPoint_Polygon_outerRingAndInnerRing_insideInnerRing_noIntersection),
                ("testPoint_Polygon_outerRingOnly_intersectsBoundary", testPoint_Polygon_outerRingOnly_intersectsBoundary),
                ("testPoint_Polygon_outerRingAndInnerRing_intersectsOuterBoundary", testPoint_Polygon_outerRingAndInnerRing_intersectsOuterBoundary),
                ("testPoint_Polygon_outerRingAndInnerRing_intersectsInnerBoundary", testPoint_Polygon_outerRingAndInnerRing_intersectsInnerBoundary),
                ("testPoint_Polygon_outerRingOnly_intersectsInterior", testPoint_Polygon_outerRingOnly_intersectsInterior),
                ("testPoint_Polygon_outerRingAndInnerRing_intersectsInterior", testPoint_Polygon_outerRingAndInnerRing_intersectsInterior),
                ("testMultiPoint_Polygon_outerRingOnly_noIntersection", testMultiPoint_Polygon_outerRingOnly_noIntersection),
                ("testMultiPoint_Polygon_outerRingAndInnerRing_outsideMainRing_noIntersection", testMultiPoint_Polygon_outerRingAndInnerRing_outsideMainRing_noIntersection),
                ("testMultiPoint_Polygon_outerRingAndInnerRing_insideInnerRing_noIntersection", testMultiPoint_Polygon_outerRingAndInnerRing_insideInnerRing_noIntersection),
                ("testMultiPoint_Polygon_outerRingAndMultipleInnerRings_outsideMainRingAndInsideInnerRings_noIntersection", testMultiPoint_Polygon_outerRingAndMultipleInnerRings_outsideMainRingAndInsideInnerRings_noIntersection),
                ("testMultiPoint_Polygon_outerRingOnly_intersectsBoundaryOnly", testMultiPoint_Polygon_outerRingOnly_intersectsBoundaryOnly),
                ("testMultiPoint_Polygon_outerRingAndInnerRing_intersectsOuterBoundaryOnly", testMultiPoint_Polygon_outerRingAndInnerRing_intersectsOuterBoundaryOnly),
                ("testMultiPoint_Polygon_outerRingAndInnerRing_intersectsInnerBoundaryOnly", testMultiPoint_Polygon_outerRingAndInnerRing_intersectsInnerBoundaryOnly),
                ("testMultiPoint_Polygon_outerRingAndInnerRing_intersectsOuterAndInnerBoundaries", testMultiPoint_Polygon_outerRingAndInnerRing_intersectsOuterAndInnerBoundaries),
                ("testMultiPoint_Polygon_outerRingAndMultipleInnerRings_intersectsOuterAndInnerBoundaries", testMultiPoint_Polygon_outerRingAndMultipleInnerRings_intersectsOuterAndInnerBoundaries),
                ("testMultiPoint_Polygon_outerRingOnly_intersectsInteriorOnly", testMultiPoint_Polygon_outerRingOnly_intersectsInteriorOnly),
                ("testMultiPoint_Polygon_outerRingAndInnerRing_intersectsInteriorOnly", testMultiPoint_Polygon_outerRingAndInnerRing_intersectsInteriorOnly),
                ("testMultiPoint_Polygon_outerRingAndMultipleInnerRings_intersectsInteriorOnly", testMultiPoint_Polygon_outerRingAndMultipleInnerRings_intersectsInteriorOnly)
           ]
   }
}
