if(NOT PREFER_BUNDLED_LIBS)
  find_package(OpenSSL)
  if(OPENSSL_FOUND)
    set(CRYPTO_FOUND ON)
    set(CRYPTO_BUNDLED OFF)
    set(CRYPTO_LIBRARY ${OPENSSL_CRYPTO_LIBRARY})
    set(CRYPTO_INCLUDEDIR ${OPENSSL_INCLUDE_DIR})
  endif()
endif()

if(PREFER_BUNDLED_LIBS AND (TARGET_OS STREQUAL "android" OR CMAKE_SYSTEM_NAME STREQUAL "Emscripten"))
  set_extra_dirs_lib(CRYPTO openssl)
  find_library(CRYPTO_LIBRARY1
    NAMES crypto
    HINTS ${HINTS_CRYPTO_LIBDIR} ${PC_CRYPTO_LIBDIR} ${PC_CRYPTO_LIBRARY_DIRS}
    PATHS ${PATHS_CRYPTO_LIBDIR}
    ${CROSSCOMPILING_NO_CMAKE_SYSTEM_PATH}
  )
  find_library(CRYPTO_LIBRARY2
    NAMES ssl
    HINTS ${HINTS_CRYPTO_LIBDIR} ${PC_CRYPTO_LIBDIR} ${PC_CRYPTO_LIBRARY_DIRS}
    PATHS ${PATHS_CRYPTO_LIBDIR}
    ${CROSSCOMPILING_NO_CMAKE_SYSTEM_PATH}
  )
  set(CRYPTO_LIBRARY ${CRYPTO_LIBRARY1} ${CRYPTO_LIBRARY2})

  set(CMAKE_FIND_FRAMEWORK FIRST)
  set_extra_dirs_include(CRYPTO openssl "${CRYPTO_LIBRARY}")
  find_path(CRYPTO_INCLUDEDIR1 openssl/opensslconf.h
    PATH_SUFFIXES CRYPTO
    HINTS ${HINTS_CRYPTO_INCLUDEDIR} ${PC_CRYPTO_INCLUDEDIR} ${PC_CRYPTO_INCLUDE_DIRS}
    PATHS ${PATHS_CRYPTO_INCLUDEDIR}
    ${CROSSCOMPILING_NO_CMAKE_SYSTEM_PATH}
  )
  find_path(CRYPTO_INCLUDEDIR2 openssl/configuration.h
    PATH_SUFFIXES CRYPTO
    HINTS ${HINTS_CRYPTO_INCLUDEDIR} ${PC_CRYPTO_INCLUDEDIR} ${PC_CRYPTO_INCLUDE_DIRS}
    PATHS ${PATHS_CRYPTO_INCLUDEDIR}
    ${CROSSCOMPILING_NO_CMAKE_SYSTEM_PATH}
  )
  set(CRYPTO_INCLUDEDIR ${CRYPTO_INCLUDEDIR1} ${CRYPTO_INCLUDEDIR2})
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Crypto DEFAULT_MSG CRYPTO_LIBRARY CRYPTO_INCLUDEDIR)

mark_as_advanced(CRYPTO_LIBRARY CRYPTO_INCLUDEDIR)

if(CRYPTO_FOUND)
  set(CRYPTO_LIBRARIES ${CRYPTO_LIBRARY})
  set(CRYPTO_INCLUDE_DIRS ${CRYPTO_INCLUDEDIR})
endif()
