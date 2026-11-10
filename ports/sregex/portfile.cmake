vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO stone-rhino/sregex
    REF "v${VERSION}"
    SHA512 a65145172cdcaed6d31e40e87ea5fd3ae7b3315dfb65856c81213ea8c94dc38c17f9e0f24285142e9084e35a7293f697011aedfc92b9605c6da8a2e1b5ead078
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