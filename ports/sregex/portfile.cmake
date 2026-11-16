vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO stone-rhino/sregex
    REF "v${VERSION}"
    SHA512 f81df8c85533d9d122c57885708a83e565a451732d0a886117e0161db9892b851f0ee031aef3703f9bf9b6b199f93dd175e5fb4e43e00643acb63dd30f41d3c6
    HEAD_REF main
)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DBUILD_BENCHES=OFF
        -DBUILD_TESTS=OFF
        -DBUILD_EXAMPLES=OFF
)

vcpkg_cmake_install()
vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/sregex)
vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(WRITE "${CURRENT_PACKAGES_DIR}/share/${PORT}/usage" [=[
sregex provides CMake targets:

    find_package(sregex CONFIG REQUIRED)
    target_link_libraries(main PRIVATE sregex::sregex)
]=])