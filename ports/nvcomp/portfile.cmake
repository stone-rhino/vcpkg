vcpkg_download_distfile(ARCHIVE
    URLS "https://developer.download.nvidia.com/compute/nvcomp/4.0.0/local_installers/nvcomp-linux-x86_64-4.0.0-cuda12.5.tar.gz"
    FILENAME "nvcomp-linux-x86_64-4.0.0-cuda12.5.tar.gz"
    SHA512 6b7867e6b784fd8bf9016336c684c7294d358b97b030fa45d660a853c315cce7270ace83f695f2d48bf4abe5eeff72284f332daac290305eae4d82e6a60ce3f7
)

vcpkg_extract_source_archive(
    SOURCE_PATH
    ARCHIVE "${ARCHIVE}"
)

set(VCPKG_POLICY_MISMATCHED_NUMBER_OF_BINARIES enabled)

file(INSTALL ${SOURCE_PATH}/include/nvcomp DESTINATION ${CURRENT_PACKAGES_DIR}/include)
file(INSTALL ${SOURCE_PATH}/include/nvcomp.h DESTINATION ${CURRENT_PACKAGES_DIR}/include)
file(INSTALL ${SOURCE_PATH}/include/nvcomp.hpp DESTINATION ${CURRENT_PACKAGES_DIR}/include)
file(INSTALL ${SOURCE_PATH}/include/nvcomp_export.h DESTINATION ${CURRENT_PACKAGES_DIR}/include)
file(INSTALL ${SOURCE_PATH}/lib/libnvcomp_cpu_static.a DESTINATION ${CURRENT_PACKAGES_DIR}/lib)
file(INSTALL ${SOURCE_PATH}/lib/libnvcomp_device_static.a DESTINATION ${CURRENT_PACKAGES_DIR}/lib)
file(INSTALL ${SOURCE_PATH}/lib/libnvcomp_static.a DESTINATION ${CURRENT_PACKAGES_DIR}/lib)

# Handle copyright
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
