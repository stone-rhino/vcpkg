vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO stone-rhino/sregex
    REF "v${VERSION}"
    SHA512 ab4a3252c78978c6786796e880f6342064a7e6180c05737b48ffa7d0ef0b5bbc7cd0e9aae640cfbbb64abb43d16b8b6dd008e3ae0d908bb23f3e0da66b00776d
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