if(NOT VCPKG_TARGET_ARCHITECTURE STREQUAL "x64")
    message(FATAL_ERROR "This port currently only supports x64 architecture")
endif()

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO 9prady9/forge
    REF ee6865cdb427a81e6be20042687255c8c0a04e37
    SHA512 5085910e26403eb9ea3e8148006ba2e46569a37f8846a6c81f1224ce3827496bd04d5a82e7d2b608e72515c273efa88464c9bb39044d3d50851d527cc802a4f2
    HEAD_REF cmake_config_fix
)

vcpkg_find_acquire_program(GIT)
get_filename_component(GIT_EXE_PATH ${GIT} DIRECTORY)
vcpkg_add_to_path(${GIT_EXE_PATH})

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        -DGIT_EXECUTABLE=${GIT}
        -DFG_BUILD_DOCS=OFF
        -DFG_BUILD_EXAMPLES=OFF
        -DFG_INSTALL_BIN_DIR=bin
)

vcpkg_install_cmake()

if (VCPKG_TARGET_IS_WINDOWS)
    vcpkg_fixup_cmake_targets(CONFIG_PATH cmake)
else()
    vcpkg_fixup_cmake_targets(CONFIG_PATH share/Forge/cmake)
endif()

file(GLOB DLLS ${CURRENT_PACKAGES_DIR}/bin/* ${CURRENT_PACKAGES_DIR}/debug/bin/*)
list(FILTER DLLS EXCLUDE REGEX "forge\\.dll\$")
file(REMOVE_RECURSE
    ${CURRENT_PACKAGES_DIR}/debug/include
    ${CURRENT_PACKAGES_DIR}/debug/share
    ${CURRENT_PACKAGES_DIR}/debug/examples
    ${CURRENT_PACKAGES_DIR}/examples
    ${DLLS}
)

file(INSTALL ${SOURCE_PATH}/.github/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
