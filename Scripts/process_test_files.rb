#!/usr/bin/env ruby

#
#   process_test_files.rb
#
#   Copyright 2016 Tony Stone
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
#   Created by Tony Stone on 5/4/16.
#

require 'fileutils'
include FileUtils

def header(fileName)
    string = <<-eos
/*
 *   <FileName>
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
 *   Created by Tony Stone on 5/4/16.
 */
import XCTest

/*
 *   NOTE: This file was auto generated by file process_test_files.rb.
 *
 *   Do NOT edit this file directly as it will be regenerated automatically when needed.
 */
    eos
    
    return string.sub! "<FileName>", File.basename(fileName)
end


def createExtensionFile(fileName, classes)
    
    extensionFile = fileName.sub! ".swift", "+XCTest.swift"
    print "Creating file: " + extensionFile + "\n"
    
     File.open(extensionFile, 'w') { |file|

         file.write header(extensionFile)
         file.write "\n"
         
         for classArray in classes
             file.write "extension " + classArray[0] + " {\n\n"
             file.write "   static var allTests : [(String, " + classArray[0] + " -> () throws -> Void)] {\n"
             file.write "      return [\n"
             
             for funcName in classArray[1]
                 file.write "                (\"" + funcName + "\", " + funcName + "),\n"
             end
             
             file.write "           ]\n"
             file.write "   }\n"
             file.write "}\n\n"
         end
     }
end

def createLinuxMain(files)
    
    fileName = "Tests/LinuxMain.swift"
    print "Creating file: " + fileName + "\n"
    
    File.open(fileName, 'w') { |file|
        
        file.write header(fileName)
        file.write "\n"
        
        file.write "#if os(Linux) || os(FreeBSD)\n"
        file.write "   @testable import GeometryTestSuite\n"
        file.write "\n"
        file.write "   XCTMain([\n"

        for classes in files
            for classArray in classes
                file.write "         testCase(" + classArray[0] + ".allTests),\n"
            end
        end
        file.write"    ])\n"
        file.write "#endif"
    }
end

def parseSourceFile(fileName)
    
    puts "Parsing file:  " + fileName + "\n"
    
    classes = Array.new
    
    currentClass = nil
    
    inIfLinux = false
    inElse    = false
    ignore    = false
    
    #
    # Read the file line by line
    # and parse to find the class
    # names and func names
    #
    File.readlines(fileName).each do |line|

        if inIfLinux
            if /\#else/.match(line)
                inElse = true
                ignore = true
                else
                if /\#end/.match(line)
                    inElse = false
                    inIfLinux = false
                    ignore = false
                end
            end
            else
            if /\#if[ \t]+os\(Linux\)/.match(line)
                inIfLinux = true
                ignore = false
            end
        end

        if !ignore
            
            # Match class or func
            match = line[/class[ \t]+[a-zA-Z0-9_]*(?=[ \t]*:)|func[ \t]+test[a-zA-Z0-9_]*(?=[ \t]*\(\))/, 0]
            if match
                
                if match[/class/, 0] == "class"
                    className = match.sub(/^class[ \t]+/, '')
                    
                    #
                    # Create a new class / func structure
                    # and add it to the classes array.
                    #
                    currentClass = [className, Array.new]
                    
                    classes << currentClass
                    
                else # Must be a func
                    funcName  = match.sub(/^func[ \t]+/, '')
                    
                    #
                    # Add each func name the the class / func
                    # structure created above.
                    #
                    currentClass[1] << funcName
                end
            end
        end
    end
    return classes
end

#
# Main routine
#
#
allFiles = Array.new

Dir['Tests/Geometry/*.swift'].each do |fileName|
    
    if File.file? fileName
        
        fileClasses = parseSourceFile(fileName)
        
        #
        # If there are classes in the
        # test source file, create an extension
        # file for it.
        #
        if fileClasses.count > 0
            
            createExtensionFile(fileName, fileClasses)
            
            allFiles << fileClasses
        end
    end
end

#
# Last step is the create a LinuxMain.swift file that
# references all the classes and funcs in the source files.
#
createLinuxMain(allFiles)

# eof