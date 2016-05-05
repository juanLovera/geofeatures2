#!/bin/sh

#  process_tests_gyb.sh
#  GeoFeatures2
#
#  Created by Tony Stone on 3/10/16.
#  Copyright © 2016 CocoaPods. All rights reserved.

cd ../Tests/Geometry

../../bin/gyb --line-directive '' -DGeometryType=LineString -DFileName=LineString.swift -o LineStringTests.swift CoordinateCollectionTests.swift.gyb
../../bin/gyb --line-directive '' -DGeometryType=LinearRing -DFileName=LinearRing.swift -o LinearRingTests.swift CoordinateCollectionTests.swift.gyb

../../bin/gyb --line-directive '' -DGeometryType=MultiPoint -DFileName=MultiPoint.swift -o MultiPointTests.swift MultiPointTests.swift.gyb
