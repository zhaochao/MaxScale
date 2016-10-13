# Common packaging configuration

execute_process(COMMAND uname -m COMMAND tr -d '\n' OUTPUT_VARIABLE CPACK_PACKAGE_ARCHITECTURE)

# Generic CPack configuration variables
set(CPACK_SET_DESTDIR ON)
set(CPACK_PACKAGE_RELOCATABLE FALSE)
set(CPACK_STRIP_FILES FALSE)
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "MaxScale")
set(CPACK_PACKAGE_VERSION_MAJOR "${MAXSCALE_VERSION_MAJOR}")
set(CPACK_PACKAGE_VERSION_MINOR "${MAXSCALE_VERSION_MINOR}")
set(CPACK_PACKAGE_VERSION_PATCH "${MAXSCALE_VERSION_PATCH}")
set(CPACK_PACKAGE_CONTACT "MariaDB Corporation Ab")
set(CPACK_PACKAGE_VENDOR "MariaDB Corporation Ab")
set(CPACK_PACKAGE_DESCRIPTION_FILE ${CMAKE_SOURCE_DIR}/etc/DESCRIPTION)
set(CPACK_PACKAGING_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# If we're building something other than the main package, append the target name
# to the package name.
if(DEFINED TARGET_COMPONENT AND NOT TARGET_COMPONENT STREQUAL "core" AND NOT TARGET_COMPONENT STREQUAL "")
  set(CPACK_PACKAGE_NAME "${PACKAGE_NAME}-${TARGET_COMPONENT}")
else()
  set(CPACK_PACKAGE_NAME "${PACKAGE_NAME}")
endif()

if(DISTRIB_SUFFIX)
  set(CPACK_PACKAGE_FILE_NAME "${CPACK_PACKAGE_NAME}-${MAXSCALE_VERSION}-${MAXSCALE_BUILD_NUMBER}.${DISTRIB_SUFFIX}.${CMAKE_SYSTEM_PROCESSOR}")
else()
  set(CPACK_PACKAGE_FILE_NAME "${CPACK_PACKAGE_NAME}-${MAXSCALE_VERSION}-${MAXSCALE_BUILD_NUMBER}.${CMAKE_SYSTEM_PROCESSOR}")
endif()

# See if we are on a RPM-capable or DEB-capable system
find_program(RPMBUILD rpmbuild)
find_program(DEBBUILD dpkg-buildpackage)

if(TARBALL)
  include(cmake/package_tgz.cmake)

elseif (NOT ( ${RPMBUILD} STREQUAL "RPMBUILD-NOTFOUND" ) OR NOT ( ${DEBBUILD} STREQUAL "DEBBUILD-NOTFOUND" ))
  if(NOT ( ${RPMBUILD} STREQUAL "RPMBUILD-NOTFOUND" ) )
    include(cmake/package_rpm.cmake)
  endif()
  if(NOT ( ${DEBBUILD} STREQUAL "DEBBUILD-NOTFOUND" ) )
    include(cmake/package_deb.cmake)
  endif()

  message(STATUS "You can install startup scripts and system configuration files for MaxScale by running the 'postinst' shell script located at ${CMAKE_INSTALL_PREFIX}.")
  message(STATUS "To remove these installed files, run the 'postrm' shell script located in the same folder.")

else()
  message(FATAL_ERROR "Could not automatically resolve the package generator and no generators "
    "defined on the command line. Please install distribution specific packaging software or "
    "define -DTARBALL=Y to build tar.gz packages.")
endif()