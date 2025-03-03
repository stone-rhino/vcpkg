vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

if(VCPKG_HOST_IS_LINUX AND (VCPKG_TARGET_ARCHITECTURE STREQUAL "arm64"))
    set(HS_REF "ffae257207264b7c320a790e5d07473d231c05ff")
    set(HS_HEAD_REF "aarch64")
else()
    set(HS_REF "bc3b191ab56055e8560c7cdc161c289c4d76e3d2")
    set(HS_HEAD_REF "master")
endif()

vcpkg_from_git(
    OUT_SOURCE_PATH SOURCE_PATH
    URL https://git.sr.ok/cpp-deps/hyperscan.git
    REF ${HS_REF}
    HEAD_REF ${HS_HEAD_REF}
    PATCHES
        0001-remove-Werror.patch
)


vcpkg_find_acquire_program(PYTHON3)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS "-DPYTHON_EXECUTABLE=${PYTHON3}"
)

vcpkg_cmake_install()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")

vcpkg_fixup_pkgconfig()
