vcpkg_from_git(
    OUT_SOURCE_PATH SOURCE_PATH
    URL https://git.sr.ok/cpp-deps/libinjection
    REF 85e252a28981d479822092bad235bb75beb7edfa
)

vcpkg_configure_make(
    SOURCE_PATH ${SOURCE_PATH}
    AUTOCONFIG
    COPY_SOURCE
)

vcpkg_build_make(
    BUILD_TARGET all
)
vcpkg_fixup_pkgconfig()

# Install
if(NOT VCPKG_BUILD_TYPE OR VCPKG_BUILD_TYPE STREQUAL debug)
    file(INSTALL ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg/src/.libs/libinjection.a DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib)
endif()
if(NOT VCPKG_BUILD_TYPE OR VCPKG_BUILD_TYPE STREQUAL release)
    file(INSTALL ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/src/.libs/libinjection.a DESTINATION ${CURRENT_PACKAGES_DIR}/lib)
endif()

file(INSTALL ${SOURCE_PATH}/src/libinjection.h DESTINATION ${CURRENT_PACKAGES_DIR}/include)
file(INSTALL ${SOURCE_PATH}/src/libinjection_html5.h DESTINATION ${CURRENT_PACKAGES_DIR}/include)
file(INSTALL ${SOURCE_PATH}/src/libinjection_sqli.h DESTINATION ${CURRENT_PACKAGES_DIR}/include)
file(INSTALL ${SOURCE_PATH}/src/libinjection_sqli_data.h DESTINATION ${CURRENT_PACKAGES_DIR}/include)
file(INSTALL ${SOURCE_PATH}/src/libinjection_xss.h DESTINATION ${CURRENT_PACKAGES_DIR}/include)

# Handle copyright
file(INSTALL ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
