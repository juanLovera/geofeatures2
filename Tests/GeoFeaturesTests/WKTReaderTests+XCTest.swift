///
/// WKTReaderTests+XCTest.swift
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

extension WKTReader_Coordinate2D_FloatingPrecision_Cartesian_Tests {

   static var allTests: [(String, (WKTReader_Coordinate2D_FloatingPrecision_Cartesian_Tests) -> () throws -> Void)] {
      return [
                ("testRead_Point_Float_Valid", testRead_Point_Float_Valid),
                ("testRead_UsingUTF8Data", testRead_UsingUTF8Data),
                ("testRead_UsingUnicodeData", testRead_UsingUnicodeData),
                ("testRead_DataNotConvertableUsingUTF8", testRead_DataNotConvertableUsingUTF8),
                ("testRead_InvalidNumberOfCoordinates", testRead_InvalidNumberOfCoordinates),
                ("testRead_Invalid_Geometry", testRead_Invalid_Geometry),
                ("testRead_Point_Int_Valid", testRead_Point_Int_Valid),
                ("testRead_Point_Valid_Exponent_UpperCase", testRead_Point_Valid_Exponent_UpperCase),
                ("testRead_Point_Valid_Exponent_LowerCase", testRead_Point_Valid_Exponent_LowerCase),
                ("testRead_Point_Invalid_Coordinate_NoSpace", testRead_Point_Invalid_Coordinate_NoSpace),
                ("testRead_Point_Invalid_Coordinate_X", testRead_Point_Invalid_Coordinate_X),
                ("testRead_Point_Invalid_Coordinate_Y", testRead_Point_Invalid_Coordinate_Y),
                ("testRead_Point_Invalid_WhiteSpace", testRead_Point_Invalid_WhiteSpace),
                ("testRead_Point_Invalid_MissingLeftParen", testRead_Point_Invalid_MissingLeftParen),
                ("testRead_Point_Invalid_MissingRightParen", testRead_Point_Invalid_MissingRightParen),
                ("testRead_LineString_Valid", testRead_LineString_Valid),
                ("testRead_LineString_Valid_Empty", testRead_LineString_Valid_Empty),
                ("testRead_LineString_Invalid_WhiteSpace", testRead_LineString_Invalid_WhiteSpace),
                ("testRead_LineString_Invalid_DoubleSapceAfterComma", testRead_LineString_Invalid_DoubleSapceAfterComma),
                ("testRead_LineString_Invalid_MissingLeftParen", testRead_LineString_Invalid_MissingLeftParen),
                ("testRead_LineString_Invalid_MissingRightParen", testRead_LineString_Invalid_MissingRightParen),
                ("testRead_LinearRing_Valid", testRead_LinearRing_Valid),
                ("testRead_LinearRing_Valid_Empty", testRead_LinearRing_Valid_Empty),
                ("testRead_LinearRing_Invalid_WhiteSpace", testRead_LinearRing_Invalid_WhiteSpace),
                ("testRead_LinearRing_Invalid_DoubleSapceAfterComma", testRead_LinearRing_Invalid_DoubleSapceAfterComma),
                ("testRead_LinearRing_Invalid_MissingLeftParen", testRead_LinearRing_Invalid_MissingLeftParen),
                ("testRead_LinearRing_Invalid_MissingRightParen", testRead_LinearRing_Invalid_MissingRightParen),
                ("testRead_MultiPoint_Valid", testRead_MultiPoint_Valid),
                ("testRead_MultiPoint_Valid_Empty", testRead_MultiPoint_Valid_Empty),
                ("testRead_MultiPoint_Invalid_WhiteSpace", testRead_MultiPoint_Invalid_WhiteSpace),
                ("testRead_MultiPoint_Invalid_DoubleSapceAfterComma", testRead_MultiPoint_Invalid_DoubleSapceAfterComma),
                ("testRead_MultiPoint_Invalid_MissingLeftParen", testRead_MultiPoint_Invalid_MissingLeftParen),
                ("testRead_MultiPoint_Invalid_MissingRightParen", testRead_MultiPoint_Invalid_MissingRightParen),
                ("testRead_MultiLineString_Valid", testRead_MultiLineString_Valid),
                ("testRead_MultiLineString_Valid_Empty", testRead_MultiLineString_Valid_Empty),
                ("testRead_MultiLineString_Invalid_WhiteSpace", testRead_MultiLineString_Invalid_WhiteSpace),
                ("testRead_MultiLineString_Invalid_DoubleSapceAfterComma", testRead_MultiLineString_Invalid_DoubleSapceAfterComma),
                ("testRead_MultiLineString_Invalid_MissingLeftParen", testRead_MultiLineString_Invalid_MissingLeftParen),
                ("testRead_MultiLineString_Invalid_MissingRightParen", testRead_MultiLineString_Invalid_MissingRightParen),
                ("testRead_Polygon_ZeroInnerRings_Valid", testRead_Polygon_ZeroInnerRings_Valid),
                ("testRead_Polygon_SingleOuterRing_Valid", testRead_Polygon_SingleOuterRing_Valid),
                ("testRead_Polygon_MultipleInnerRings_Valid", testRead_Polygon_MultipleInnerRings_Valid),
                ("testRead_Polygon_MultipleInnerRings_Invalid_MissingComma", testRead_Polygon_MultipleInnerRings_Invalid_MissingComma),
                ("testRead_Polygon_MultipleInnerRings_Invalid_ExtraWhiteSpace_InnerRing", testRead_Polygon_MultipleInnerRings_Invalid_ExtraWhiteSpace_InnerRing),
                ("testRead_Polygon_Valid_Empty", testRead_Polygon_Valid_Empty),
                ("testRead_Polygon_Invalid_WhiteSpace", testRead_Polygon_Invalid_WhiteSpace),
                ("testRead_Polygon_Invalid_DoubleSapceAfterComma", testRead_Polygon_Invalid_DoubleSapceAfterComma),
                ("testRead_Polygon_Invalid_MissingLeftParen", testRead_Polygon_Invalid_MissingLeftParen),
                ("testRead_Polygon_Invalid_MissingRightParen", testRead_Polygon_Invalid_MissingRightParen),
                ("testRead_MultiPolygon_Valid", testRead_MultiPolygon_Valid),
                ("testRead_MultiPolygon_Valid_Empty", testRead_MultiPolygon_Valid_Empty),
                ("testRead_MultiPolygon_Invalid_WhiteSpace", testRead_MultiPolygon_Invalid_WhiteSpace),
                ("testRead_MultiPolygon_Invalid_DoubleSapceAfterComma", testRead_MultiPolygon_Invalid_DoubleSapceAfterComma),
                ("testRead_MultiPolygon_Invalid_MissingLeftParen", testRead_MultiPolygon_Invalid_MissingLeftParen),
                ("testRead_MultiPolygon_Invalid_MissingRightParen", testRead_MultiPolygon_Invalid_MissingRightParen),
                ("testRead_GeometryCollection_Valid", testRead_GeometryCollection_Valid),
                ("testRead_GeometryCollection_Valid_Empty", testRead_GeometryCollection_Valid_Empty),
                ("testRead_GeometryCollection_Invalid_WhiteSpace", testRead_GeometryCollection_Invalid_WhiteSpace),
                ("testRead_GeometryCollection_Invalid_DoubleSapceAfterComma", testRead_GeometryCollection_Invalid_DoubleSapceAfterComma),
                ("testRead_GeometryCollection_Invalid_MissingLeftParen", testRead_GeometryCollection_Invalid_MissingLeftParen),
                ("testRead_GeometryCollection_Invalid_MissingRightParen", testRead_GeometryCollection_Invalid_MissingRightParen),
                ("testReadPerformance_Polygon_California", testReadPerformance_Polygon_California)
           ]
   }
}
extension WKTReader_Coordinate2DM_FloatingPrecision_Cartesian_Tests {

   static var allTests: [(String, (WKTReader_Coordinate2DM_FloatingPrecision_Cartesian_Tests) -> () throws -> Void)] {
      return [
                ("testRead_Point_Valid", testRead_Point_Valid),
                ("testRead_Point_Invalid_Coordinate_M", testRead_Point_Invalid_Coordinate_M),
                ("testRead_Point_Invalid_Coordinate_MissingM", testRead_Point_Invalid_Coordinate_MissingM),
                ("testRead_Point_Invalid_Coordinate_NoSpaceAfterM", testRead_Point_Invalid_Coordinate_NoSpaceAfterM),
                ("testRead_Point_Invalid_Coordinate_NoSpaceBeforeM", testRead_Point_Invalid_Coordinate_NoSpaceBeforeM),
                ("testRead_InvalidNumberOfCoordinates", testRead_InvalidNumberOfCoordinates),
                ("testRead_GeometryCollection_Valid", testRead_GeometryCollection_Valid),
                ("testRead_GeometryCollection_Invalid_ElementNoM", testRead_GeometryCollection_Invalid_ElementNoM)
           ]
   }
}
extension WKTReader_Coordinate3D_FloatingPrecision_Cartesian_Tests {

   static var allTests: [(String, (WKTReader_Coordinate3D_FloatingPrecision_Cartesian_Tests) -> () throws -> Void)] {
      return [
                ("testRead_Point_Valid", testRead_Point_Valid),
                ("testRead_Point_Invalid_Coordinate_Z", testRead_Point_Invalid_Coordinate_Z),
                ("testRead_Point_Invalid_Coordinate_MissingZ", testRead_Point_Invalid_Coordinate_MissingZ),
                ("testRead_Point_Invalid_Coordinate_NoSpaceAfterZ", testRead_Point_Invalid_Coordinate_NoSpaceAfterZ),
                ("testRead_Point_Invalid_Coordinate_NoSpaceBeforeZ", testRead_Point_Invalid_Coordinate_NoSpaceBeforeZ),
                ("testRead_GeometryCollection_Valid", testRead_GeometryCollection_Valid),
                ("testRead_GeometryCollection_Invalid_ElementNoZ", testRead_GeometryCollection_Invalid_ElementNoZ)
           ]
   }
}
extension WKTReader_Coordinate3DM_FloatingPrecision_Cartesian_Tests {

   static var allTests: [(String, (WKTReader_Coordinate3DM_FloatingPrecision_Cartesian_Tests) -> () throws -> Void)] {
      return [
                ("testRead_Point_Valid", testRead_Point_Valid),
                ("testRead_Point_Invalid_Coordinate_M", testRead_Point_Invalid_Coordinate_M),
                ("testRead_Point_Invalid_Coordinate_MissingM", testRead_Point_Invalid_Coordinate_MissingM),
                ("testRead_Point_Invalid_Coordinate_NoSpaceAfterM", testRead_Point_Invalid_Coordinate_NoSpaceAfterM),
                ("testRead_Point_Invalid_Coordinate_NoSpaceBeforeM", testRead_Point_Invalid_Coordinate_NoSpaceBeforeM),
                ("testRead_GeometryCollection_Valid", testRead_GeometryCollection_Valid),
                ("testRead_GeometryCollection_Invalid_ElementNoZ", testRead_GeometryCollection_Invalid_ElementNoZ),
                ("testRead_GeometryCollection_Invalid_ElementNoM", testRead_GeometryCollection_Invalid_ElementNoM)
           ]
   }
}
