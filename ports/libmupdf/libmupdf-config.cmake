# libmupdf-config.cmake
include(CMakeFindDependencyMacro)

find_package(freetype NO_MODULE REQUIRED)
find_package(JPEG REQUIRED)
find_package(harfbuzz CONFIG REQUIRED)
find_package(ZLIB REQUIRED)
find_package(OpenJPEG CONFIG REQUIRED)
find_library(JBIG2DEC_LIB NAMES jbig2decd jbig2dec)

if(ENABLE_OCR)
  find_dependency(Leptonica REQUIRED)
  find_dependency(Tesseract REQUIRED)
endif()

include("${CMAKE_CURRENT_LIST_DIR}/libmupdf-targets.cmake")