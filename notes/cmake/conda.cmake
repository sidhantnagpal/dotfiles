cmake_minimum_required(VERSION 3.15 FATAL_ERROR)
include_guard()


if (NOT DEFINED CONDA_PREFIX)
  message(FATAL_ERROR "You must conda environment before using conda.cmake")
endif()

list(APPEND CMAKE_PREFIX_PATH ${CONDA_PREFIX})


# Function to get the exact python version installed in the conda environment
# NOTE: This only gives the major.minor version
function(cmake_get_python_version return_value)
  execute_process(COMMAND ${CONDA_PREFIX}/bin/python -c
                "import sys; sys.stdout.write('.'.join([str(x) for x in sys.version_info[:2]]))"
                RESULT_VARIABLE output_error_rc
                OUTPUT_VARIABLE version_string
                ERROR_QUIET
                OUTPUT_STRIP_TRAILING_WHITESPACE)
  if(output_error_rc)
    message(FATAL_ERROR "cmake_get_python_version exited with error: ${output_error_rc}. \nCannot determine the python version installed in the environment.")
  endif()
  string(REGEX MATCH "[0-9]+\\.[0-9]+" version_number "${version_string}")
  set(${return_value} ${version_number} PARENT_SCOPE)
endfunction()
