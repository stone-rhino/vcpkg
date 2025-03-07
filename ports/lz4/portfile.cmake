vcpkg_from_git(
    OUT_SOURCE_PATH SOURCE_PATH
    URL https://git.sr.ok/cpp-deps/lz4.git
    REF ebb370ca83af193212df4dcbadcc5d87bc0de2f0
    HEAD_REF dev
    PATCHES
        target-lz4-lz4.diff
)

vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        tools LZ4_BUILD_CLI
)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}/build/cmake"
    OPTIONS
        ${FEATURE_OPTIONS}
    OPTIONS_DEBUG
        -DCMAKE_DEBUG_POSTFIX=d
)

vcpkg_cmake_install()
vcpkg_copy_pdbs()

if("tools" IN_LIST FEATURES)
    vcpkg_copy_tools(
        TOOL_NAMES lz4
        AUTO_CLEAN
    )
endif()

if(VCPKG_LIBRARY_LINKAGE STREQUAL "dynamic")
    set(DLL_IMPORT "1 && defined(_MSC_VER)")
else()
    set(DLL_IMPORT "0")
endif()
foreach(FILE lz4.h lz4frame.h)
    vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/include/${FILE}"
        "defined(LZ4_DLL_IMPORT) && (LZ4_DLL_IMPORT==1)"
        "${DLL_IMPORT}"
    )
endforeach()

vcpkg_cmake_config_fixup(CONFIG_PATH "lib/cmake/lz4")

vcpkg_fixup_pkgconfig()
if(NOT DEFINED VCPKG_BUILD_TYPE OR VCPKG_BUILD_TYPE STREQUAL "debug")
    vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/liblz4.pc" " -llz4" " -llz4d")
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")

set(LICENSE_FILES "${SOURCE_PATH}/lib/LICENSE")
if("tools" IN_LIST FEATURES)
    list(APPEND LICENSE_FILES "${SOURCE_PATH}/programs/COPYING")
endif()
vcpkg_install_copyright(FILE_LIST ${LICENSE_FILES})
