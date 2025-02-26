vcpkg_from_git(
    OUT_SOURCE_PATH SOURCE_PATH
    URL https://git.sr.ok/cpp-deps/pugixml.git
    REF ee86beb30e4973f5feffe3ce63bfa4fbadf72f38
    HEAD_REF master
)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DPUGIXML_BUILD_TESTS=OFF
)

vcpkg_cmake_install()
vcpkg_copy_pdbs()
vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/${PORT})
vcpkg_fixup_pkgconfig()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.md")
