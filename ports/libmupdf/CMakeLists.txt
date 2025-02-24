cmake_minimum_required(VERSION 3.9)
project(libmupdf)
include(GNUInstallDirs)

option(ENABLE_OCR "Build with OCR" OFF)

set(CMAKE_DEBUG_POSTFIX d)
set(PROJECT_VERSION 1.24.10)

if(WIN32)
  execute_process(
    COMMAND "cmd.exe" "/c" "platform\\win32\\generate.bat"
    WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
  )
else()
  find_program(MAKE_EXE NAMES make REQUIRED)
  execute_process(
    COMMAND ${MAKE_EXE} "generate"
    WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
  )
endif()

find_package(PkgConfig REQUIRED)
pkg_check_modules(GUMBO REQUIRED gumbo)

find_package(freetype NO_MODULE REQUIRED)
find_package(JPEG REQUIRED)
find_package(harfbuzz CONFIG REQUIRED)
find_package(ZLIB REQUIRED)
find_package(OpenJPEG CONFIG REQUIRED)
find_library(JBIG2DEC_LIB NAMES jbig2decd jbig2dec)

if (ENABLE_OCR)
  find_package(Leptonica CONFIG REQUIRED)
  find_package(Tesseract CONFIG REQUIRED)
endif()

file(GLOB_RECURSE SOURCES "source/*.c" "generated/*.c" "source/*.h")
list(FILTER SOURCES EXCLUDE REGEX "source/tools/[a-z]*\\.c$")
list(FILTER SOURCES EXCLUDE REGEX "source/tests/.*.c$")
list(FILTER SOURCES EXCLUDE REGEX "source/fitz/output-docx.c")

if (ENABLE_OCR)
  list(APPEND SOURCES "source/fitz/tessocr.cpp")
endif()

add_library(libmupdf ${SOURCES})

if(WIN32)
  target_compile_definitions(libmupdf PRIVATE -DSHARE_JPEG -DFZ_ENABLE_JS=0 -DFZ_ENABLE_ICC=0 -DMEMENTO_MUPDF_HACKS -DFZ_ENABLE_DOCX_OUTPUT=0 -DFZ_ENABLE_ODT_OUTPUT=0)
else()
  target_compile_definitions(libmupdf PRIVATE -DHAVE_PTHREAD=1 -DSHARE_JPEG -DFZ_ENABLE_JS=0 -DFZ_ENABLE_ICC=0 -DMEMENTO_MUPDF_HACKS -DFZ_ENABLE_DOCX_OUTPUT=0 -DFZ_ENABLE_ODT_OUTPUT=0)
endif()


if (ENABLE_OCR)
  target_compile_definitions(libmupdf PRIVATE -DHAVE_TESSERACT=1 -DHAVE_LEPTONICA=1)
else()
  target_compile_definitions(libmupdf PRIVATE -DOCR_DISABLED=1)
endif()

target_include_directories(libmupdf
  PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
    # $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
  PRIVATE
    generated
    ${JPEG_INCLUDE_DIR}
    ${HARFBUZZ_INCLUDE}
)

if (ENABLE_OCR)
target_include_directories(libmupdf
  PRIVATE
    ${Leptonica_INCLUDE_DIRS}
)
endif()

target_link_libraries(libmupdf PRIVATE
  openjp2
  freetype
  ${JPEG_LIBRARIES}
  harfbuzz::harfbuzz harfbuzz::harfbuzz-subset
  ${JBIG2DEC_LIB}
  ZLIB::ZLIB
  ${GUMBO_LINK_LIBRARIES}
)

export(TARGETS libmupdf
  FILE "${CMAKE_CURRENT_BINARY_DIR}/libmupdf-targets.cmake"
  NAMESPACE libmupdf::
)

# Joins arguments and places the results in ${result_var}.
function(join result_var)
  set(result "")
  foreach (arg ${ARGN})
    set(result "${result}${arg}")
  endforeach ()
  set(${result_var} "${result}" PARENT_SCOPE)
endfunction()

# Sets a cache variable with a docstring joined from multiple arguments:
#   set(<variable> <value>... CACHE <type> <docstring>...)
# This allows splitting a long docstring for readability.
function(set_verbose)
  # cmake_parse_arguments is broken in CMake 3.4 (cannot parse CACHE) so use
  # list instead.
  list(GET ARGN 0 var)
  list(REMOVE_AT ARGN 0)
  list(GET ARGN 0 val)
  list(REMOVE_AT ARGN 0)
  list(REMOVE_AT ARGN 0)
  list(GET ARGN 0 type)
  list(REMOVE_AT ARGN 0)
  join(doc ${ARGN})
  set(${var} ${val} CACHE ${type} ${doc})
endfunction()

set_verbose(LIBMUPDF_INC_DIR ${CMAKE_INSTALL_INCLUDEDIR} CACHE STRING
            "Installation directory for include files, a relative path that "
            "will be joined with ${CMAKE_INSTALL_PREFIX} or an absolute path.")

install(TARGETS libmupdf
  EXPORT libmupdf-targets
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  # PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)


include(CMakePackageConfigHelpers)

write_basic_package_version_file(
  "${CMAKE_CURRENT_BINARY_DIR}/libmupdf-config-version.cmake"
  VERSION ${PROJECT_VERSION}
  COMPATIBILITY AnyNewerVersion
)

install(FILES
  "${CMAKE_CURRENT_LIST_DIR}/libmupdf-config.cmake"
  "${CMAKE_CURRENT_BINARY_DIR}/libmupdf-config-version.cmake"
  DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/libmupdf
)

install(EXPORT libmupdf-targets
  FILE libmupdf-targets.cmake
  NAMESPACE libmupdf::
  DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/libmupdf
)