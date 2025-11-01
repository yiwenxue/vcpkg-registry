
vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO NVIDIA/stdexec
    REF 1f6379682dd1598c9b48313fa6dfdae620bc8535
    SHA512 268d580ec3dab708b1ee32d57982dd8f773d91d8d2af324c320b8599900ca3b586973507ed861753bd716f70b09393deb639e3e806fc2631acabb37c64e9cd7c
    HEAD_REF main
    PATCHES
        fix-cmake-build-rule.patch
)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH_RAPIDS
    REPO rapidsai/rapids-cmake
    REF c7a28304639a2ed460181b4753f3280c7833c718
    SHA512 9a87fdef490199337778b8c9b4df31ca37d65df23803d058f13b406dcfda4d96d992b2780b0b878b61b027c0dc848351496a0f32e779f95298f259bab040b49b
    HEAD_REF main
)

vcpkg_download_distfile(RAPIDS_cmake
    URLS "https://raw.githubusercontent.com/rapidsai/rapids-cmake/branch-24.02/RAPIDS.cmake"
    FILENAME "RAPIDS.cmake"
    SHA512 5ac649e93260e491e592302255e110441fb4582684fa28b0391d1017330e56b8d01e851a24160235c63976e82c14593dd90cc6a4fbfe21a5513769a787d7e1d9
)
file(COPY "${RAPIDS_cmake}" DESTINATION "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/")

vcpkg_download_distfile(execution_bs
    URLS "https://raw.githubusercontent.com/cplusplus/sender-receiver/main/execution.bs"
    FILENAME "execution.bs"
    SHA512 091c327eb1d161c46d77e7e0265c16d3de0c7fe7e1714c6891fbc6914d7147aed83ea28ba5a1f79703c9b00c84e7c2351fcf9106dacec46f634b0795692bc086
)
file(COPY "${execution_bs}" DESTINATION "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/")

set(VCPKG_BUILD_TYPE release)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DSTDEXEC_BUILD_TESTS=OFF
        -DSTDEXEC_BUILD_EXAMPLES=OFF
        -DFETCHCONTENT_SOURCE_DIR_RAPIDS-CMAKE="${SOURCE_PATH_RAPIDS}"
)

vcpkg_cmake_install()

vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/stdexec)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/lib")

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.txt")
