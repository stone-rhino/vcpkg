vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

if(VCPKG_HOST_IS_LINUX AND (VCPKG_TARGET_ARCHITECTURE STREQUAL "arm64"))
    set(HS_REF "ffae257207264b7c320a790e5d07473d231c05ff")
    set(HS_HEAD_REF "aarch64")
    set(HS_URL "https://github.com/kunpengcompute/hyperscan.git")
    set(HS_REPO "kunpengcompute/hyperscan")
    set(HS_VERSION "5.4.2.aarch64")
    set(HS_SHA512 "377e2cd41f1c3ae2908c17fd3085f583e8eba8d907e7d8b746d2a6653472bd01957be8178a6fdfd0f31c3499566029c2ce4459beacd138c0f5bd269f336faeb7")
else()
    set(HS_REF "bc3b191ab56055e8560c7cdc161c289c4d76e3d2")
    set(HS_HEAD_REF "master")
    set(HS_URL "https://github.com/intel/hyperscan.git")
    set(HS_REPO "intel/hyperscan")
    set(HS_VERSION "5.4.2")
    set(HS_SHA512 328f21133161d16b36ebdc7f8b80a7afe7ca9e7e7433348e9bfa9acb5f3641522e8314beea1b219891f4e95f1392ff8036ebb87780fe808b8b4bd15a535e9509)
endif()

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO ${HS_REPO}
    REF "v${HS_VERSION}"
    SHA512 ${HS_SHA512}
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
