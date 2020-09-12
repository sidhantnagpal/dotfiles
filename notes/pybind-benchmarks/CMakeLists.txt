cmake_minimum_required(VERSION 3.15 FATAL_ERROR)

project(pybind_benchmarks)

find_package(pybind11 REQUIRED)
find_package(Boost 1.66 REQUIRED COMPONENTS python)
find_package(Python 3 REQUIRED COMPONENTS Development)

set(CMAKE_POSITION_INDEPENDENT_CODE ON)


## PyBind11
pybind11_add_module(benchmark_pybind11 benchmark_pybind11.cpp)
# To pass extra compile flags (for higher quality code
#   generation) use `add_library` and `target_link_libraries`
#   instead of `pybind11_add_module`


## Boost.Python
add_library(benchmark_boost SHARED
  benchmark_boost.cpp)
target_link_libraries(benchmark_boost PRIVATE
  Boost::python
  Python::Python)

# Tweaks the name of the library to match what Python expects
#   See https://pybind11.readthedocs.io/en/stable/compiling.html#advanced-interface-library-target
set_target_properties(benchmark_boost PROPERTIES
    PREFIX ""
    SUFFIX "${PYTHON_MODULE_EXTENSION}")


install(
  PROGRAMS
    benchmark.py
  TYPE LIB
  COMPONENT pybench)
