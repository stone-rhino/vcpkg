vcpkg_from_git(
    OUT_SOURCE_PATH SOURCE_PATH
    URL https://git.sr.ok/cpp-deps/brotli.git
    REF ed738e842d2fbdf2d6459e39267a633c4a9b2f5d
    PATCHES
        install.patch
        fix-arm-uwp.patch
        pkgconfig.patch
        emscripten.patch
)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DBROTLI_DISABLE_TESTS=ON
)
vcpkg_cmake_install()
vcpkg_copy_pdbs()
vcpkg_fixup_pkgconfig()
vcpkg_cmake_config_fixup(CONFIG_PATH share/unofficial-brotli PACKAGE_NAME unofficial-brotli)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/tools")

# Under emscripten the brotli executable tool is produced with .js extension but vcpkg_copy_tools
# has no special behaviour in this case and searches for the tool name with no extension
if(VCPKG_TARGET_IS_EMSCRIPTEN)
	set(TOOL_SUFFIX ".js" )
endif()

vcpkg_copy_tools(TOOL_NAMES "brotli${TOOL_SUFFIX}" SEARCH_DIR "${CURRENT_PACKAGES_DIR}/tools/brotli")

file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
