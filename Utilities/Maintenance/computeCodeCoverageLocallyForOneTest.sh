#!/bin/bash
#==========================================================================
#
#   Copyright NumFOCUS
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#          https://www.apache.org/licenses/LICENSE-2.0.txt
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
#==========================================================================*/
if [[ $# == 0 || $1 == "--help" ]]
then
echo "                                                                        "
echo "  How to use this script   "
echo "   "
echo "   0)  Use Linux or Mac   "
echo "        - install lcov"
echo "        - use the gcc compiler"
echo "   "
echo "   1)  Add the CMake flags:   "
echo "   "
echo "       CMAKE_CXX_FLAGS:STRING=-g -O0  -fprofile-arcs -ftest-coverage   "
echo "       CMAKE_C_FLAGS:STRING= -g -O0  -fprofile-arcs -ftest-coverage   "
echo "   "
echo "   2)  Compile ITK for Debug   "
echo "   "
echo "                     CMAKE_BUILD_TYPE  Debug   "
echo "   "
echo "   3)  From the TOP of the binary directory type the "ctest" expression that "
echo "       selects the tests that you want to use to generate coverage (Ideally "
echo "       this should only need to be the unit tests of the class in question).   "
echo "   "
echo "       For example:   "
echo "   "
echo "                ctest  -R   itkHDF5ImageIOTest   -V   -N   "
echo "   "
echo "       This will print to the console the command line instructions needed to   "
echo "       run the tests (-V option), but without running the tests (-N option).   "
echo "   "
echo "   4)  From the TOP of the binary directory type the path to this script in    "
echo "       the ITK source tree. Add the relative path from your location at the TOP "
echo "       of the binary directory to the directory of the Module for which you want "
echo "       to compute code coverage, and add the selection expression that you put "
echo "       after ctest in numeral (3) above.   "
echo "   "
echo "       More specifically, for example:   "
echo "   "
echo "        computeCodeCoverageLocallyForOneTest.sh ./Modules/IO/HDF5    \   "
echo "                                 -R  itkHDF5ImageIOTest   "
echo "   "
echo "   "
echo "       This will run the selected tests in ITK and generate code coverage for   "
echo "       the entire toolkit, but only from the test that you have selected. The   "
echo "       code coverage report will be generated in HTML can be opened with your   "
echo "       favorite browser. The HTML report will be placed in the MODULE directory. "
echo "       For example, in the case above: "
echo "    "
echo "          In Linux, you can do        firefox  ./Modules/IO/HDF5/index.html     "
echo "          In Mac,   you can do        open     ./Modules/IO/HDF5/index.html     "
echo "    "

else

#==========================================================================
lcov --directory . --zerocounters
destinationdir=$1
shift
ctest $*
cd $destinationdir
lcov --directory . --capture --output-file app.info
lcov --remove app.info '*test*'  '*ThirdParty*' '/usr/*' --output-file  app.info2
genhtml app.info2
echo "To view results on Linux, type firefox "$destinationdir"/index.html"
echo "To view results on Mac, type open "$destinationdir"/index.html"
fi
