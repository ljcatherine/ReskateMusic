# CMake generated Testfile for 
# Source directory: C:/Users/Liam/Documents/Projects/ReskateMusic/tests
# Build directory: C:/Users/Liam/Documents/Projects/ReskateMusic/tests/build
# 
# This file includes the relevant testing commands required for 
# testing this directory and lists subdirectories to be tested as well.
if(CTEST_CONFIGURATION_TYPE MATCHES "^([Dd][Ee][Bb][Uu][Gg])$")
  add_test([=[spotify_actions]=] "C:/Users/Liam/Documents/Projects/ReskateMusic/tests/build/Debug/spotify_actions_tests.exe")
  set_tests_properties([=[spotify_actions]=] PROPERTIES  _BACKTRACE_TRIPLES "C:/Users/Liam/Documents/Projects/ReskateMusic/tests/CMakeLists.txt;6;add_test;C:/Users/Liam/Documents/Projects/ReskateMusic/tests/CMakeLists.txt;0;")
elseif(CTEST_CONFIGURATION_TYPE MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
  add_test([=[spotify_actions]=] "C:/Users/Liam/Documents/Projects/ReskateMusic/tests/build/Release/spotify_actions_tests.exe")
  set_tests_properties([=[spotify_actions]=] PROPERTIES  _BACKTRACE_TRIPLES "C:/Users/Liam/Documents/Projects/ReskateMusic/tests/CMakeLists.txt;6;add_test;C:/Users/Liam/Documents/Projects/ReskateMusic/tests/CMakeLists.txt;0;")
elseif(CTEST_CONFIGURATION_TYPE MATCHES "^([Mm][Ii][Nn][Ss][Ii][Zz][Ee][Rr][Ee][Ll])$")
  add_test([=[spotify_actions]=] "C:/Users/Liam/Documents/Projects/ReskateMusic/tests/build/MinSizeRel/spotify_actions_tests.exe")
  set_tests_properties([=[spotify_actions]=] PROPERTIES  _BACKTRACE_TRIPLES "C:/Users/Liam/Documents/Projects/ReskateMusic/tests/CMakeLists.txt;6;add_test;C:/Users/Liam/Documents/Projects/ReskateMusic/tests/CMakeLists.txt;0;")
elseif(CTEST_CONFIGURATION_TYPE MATCHES "^([Rr][Ee][Ll][Ww][Ii][Tt][Hh][Dd][Ee][Bb][Ii][Nn][Ff][Oo])$")
  add_test([=[spotify_actions]=] "C:/Users/Liam/Documents/Projects/ReskateMusic/tests/build/RelWithDebInfo/spotify_actions_tests.exe")
  set_tests_properties([=[spotify_actions]=] PROPERTIES  _BACKTRACE_TRIPLES "C:/Users/Liam/Documents/Projects/ReskateMusic/tests/CMakeLists.txt;6;add_test;C:/Users/Liam/Documents/Projects/ReskateMusic/tests/CMakeLists.txt;0;")
else()
  add_test([=[spotify_actions]=] NOT_AVAILABLE)
endif()
