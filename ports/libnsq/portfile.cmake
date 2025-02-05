vcpkg_download_distfile(ARCHIVE
    URLS "https://git.ouryun.cn/base/libnsq/archive/570e8f1461b04e96e6a9dbf0161ff7e1243de827.tar.gz"
    FILENAME "570e8f1461b04e96e6a9dbf0161ff7e1243de827.tar.gz"
    SHA512 6ad85e599406ec06367a17a55df1ee7d6a469aeb16ed886664018b6f15c629ce18e76c7fb54df702b15d070a0547e5c9683d5c084a5abc57bf2cd152a5139d98
)

vcpkg_extract_source_archive(
    SOURCE_PATH
    ARCHIVE "${ARCHIVE}"
)

vcpkg_configure_make(
    SOURCE_PATH ${SOURCE_PATH}
    SKIP_CONFIGURE
    COPY_SOURCE
)

vcpkg_build_make(
    BUILD_TARGET all
    OPTIONS
        "CFLAGS=-I${CURRENT_INSTALLED_DIR}/include/libev"
)
vcpkg_fixup_pkgconfig()

# Install
if(NOT VCPKG_BUILD_TYPE OR VCPKG_BUILD_TYPE STREQUAL debug)
    file(INSTALL ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg/libnsq.a DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib)
endif()
if(NOT VCPKG_BUILD_TYPE OR VCPKG_BUILD_TYPE STREQUAL release)
    file(INSTALL ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/libnsq.a DESTINATION ${CURRENT_PACKAGES_DIR}/lib)
endif()

file(INSTALL ${SOURCE_PATH}/nsq.h DESTINATION ${CURRENT_PACKAGES_DIR}/include)
file(INSTALL ${SOURCE_PATH}/evbuffsock.h DESTINATION ${CURRENT_PACKAGES_DIR}/include)

# Handle copyright
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
