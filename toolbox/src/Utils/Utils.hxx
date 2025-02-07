/*--------------------------------------------------------------------------*\
 |                                                                          |
 |  Copyright (C) 2017                                                      |
 |                                                                          |
 |         , __                 , __                                        |
 |        /|/  \               /|/  \                                       |
 |         | __/ _   ,_         | __/ _   ,_                                |
 |         |   \|/  /  |  |   | |   \|/  /  |  |   |                        |
 |         |(__/|__/   |_/ \_/|/|(__/|__/   |_/ \_/|/                       |
 |                           /|                   /|                        |
 |                           \|                   \|                        |
 |                                                                          |
 |      Enrico Bertolazzi                                                   |
 |      Dipartimento di Ingegneria Industriale                              |
 |      Universita` degli Studi di Trento                                   |
 |      email: enrico.bertolazzi@unitn.it                                   |
 |                                                                          |
\*--------------------------------------------------------------------------*/

///
/// file: Utils.hh
///

#pragma once

#ifndef UTILS_dot_HXX
#define UTILS_dot_HXX

// must be the first header included
#include "rang.hpp"

// select computer architecture
#if defined(__APPLE__) && defined(__MACH__)
  // osx architecture
  #define UTILS_OS_OSX 1
  #if defined(__i386__)
    #define UTILS_ARCH32 1
  #elif defined(__x86_64__)
    #define UTILS_ARCH64 1
  #endif
#elif defined(__unix__)
  // linux architecture
  #define UTILS_OS_LINUX 1
  #if defined(__i386__)
    #define UTILS_ARCH32 1
  #elif defined(__x86_64__)
    #define UTILS_ARCH64 1
  #endif
#elif defined(_WIN32) || defined(WIN32) || defined(_WIN64) || defined(WIN64)
  // windows architecture
  #define UTILS_OS_WINDOWS 1
  #if defined(_M_X64) || defined(_M_AMD64)
    #define UTILS_ARCH64 1
  #else
    #define UTILS_ARCH32 1
  #endif
  #ifndef WIN32_LEAN_AND_MEAN
    #define WIN32_LEAN_AND_MEAN
  #endif
  #include <windows.h>
  // workaround for windows that may define min and max as macros
  #ifdef min
    #undef min
  #endif
  #ifdef max
    #undef max
  #endif
#else
  #error "unsupported OS!"
#endif

// check if compiler is C++11
#if (defined(_MSC_VER) &&  _MSC_VER >= 1800) || \
    (defined(__cplusplus) && __cplusplus > 199711L)
#else
  #error "Lapack Wrapper must be compiled using C++ >= C++11"
#endif

#define UTILS_PURE_VIRTUAL = 0
#ifndef UTILS_OS_WINDOWS
  #define UTILS_OVERRIDE  override
  #define UTILS_CONSTEXPR constexpr
#else
  #define UTILS_OVERRIDE
  #define UTILS_CONSTEXPR
#endif

#include "fmt/printf.h"
#include "fmt/chrono.h"
#include "fmt/ostream.h"

#ifndef UTILS_OS_WINDOWS
#include "zstream/izstream.hpp"
#include "zstream/ozstream.hpp"
#endif

#include <string>
#include <iostream>
#include <iomanip>
#include <sstream>
#include <cstdlib>
#include <cmath>
#include <cstdint>
#include <stdexcept>
#include <mutex>
#include <atomic>

#include "Trace.hxx"
#include "Console.hxx"
#include "Malloc.hxx"
#include "Numbers.hxx"
#include "TicToc.hxx"
#include "ThreadPool.hxx"

namespace Utils {

  std::string basename( char const filename[] );

  template <typename T_int, typename T_real>
  void
  searchInterval(
    T_int        npts,
    T_real const X[],
    T_real     & x,
    T_int      & lastInterval,
    bool         closed,
    bool         can_extend
  );

  extern template void searchInterval(
    int32_t     npts,
    float const X[],
    float     & x,
    int32_t   & lastInterval,
    bool        closed,
    bool        can_extend
  );

  extern template void searchInterval(
    int32_t      npts,
    double const X[],
    double     & x,
    int32_t    & lastInterval,
    bool         closed,
    bool         can_extend
  );

  extern template void searchInterval(
    int64_t     npts,
    float const X[],
    float     & x,
    int64_t   & lastInterval,
    bool        closed,
    bool        can_extend
  );

  extern template void searchInterval(
    int64_t      npts,
    double const X[],
    double     & x,
    int64_t    & lastInterval,
    bool         closed,
    bool         can_extend
  );

}

#endif

///
/// eof: Utils.hh
///
