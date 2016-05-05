/*
 *   FloatingPrecisionTests.swift
 *
 *   Copyright 2016 Tony Stone
 *
 *   Licensed under the Apache License, Version 2.0 (the "License");
 *   you may not use this file except in compliance with the License.
 *   You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 *   Unless required by applicable law or agreed to in writing, software
 *   distributed under the License is distributed on an "AS IS" BASIS,
 *   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *   See the License for the specific language governing permissions and
 *   limitations under the License.
 *
 *   Created by Tony Stone on 2/11/16.
 */
import XCTest

#if SWIFT_PACKAGE
    import Geometry
#else
    import GeoFeatures2
#endif

class FloatingPrecisionTests: XCTestCase {

    let precision  = FloatingPrecision()
    
    func testConvert_Equal() {
        XCTAssertEqual(precision.convert(100.003), 100.003)
    }
    
    func testConvert_NotEqual1() {
        XCTAssertNotEqual(precision.convert(100.0), 100.003)
    }
    
    func testConvert_NotEqual2() {
        XCTAssertNotEqual(precision.convert(100.003), 100.0003)
    }

}
