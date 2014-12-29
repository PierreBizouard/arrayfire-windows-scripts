Build ArrayFire on Windows
==========================

This repository contains sample batch scripts for building ArrayFire on Windows.

## Source Requirements
* [ArrayFire](https://github.com/arrayfire/arrayfire)
* [ArrayFire Windows Dependencies](https://drive.google.com/file/d/0ByGyhTmHFow9OHhEcGZJcmZnc3M/view?usp=sharing). Includes pre-built:
    * clBLAS, clFFT
    * FreeImage 3.16
    * OpenBLAS
    * Boost 1.56 Header Files
* Other requirements as stated in the ArrayFire repo (CUDA, OpenCL SDKs etc).

## Software Requirements
* Visual Studio 2013 or newer
    * Community edition is free for Open Source projects
* GitHub for Windows preffered. Regular command prompt will also work.
* SilkSVN or other Subversion tool
* CMake

## How to use the scripts
### common.bat
This file contains common macros. This is probably the only file that you will need to change. The variables are explained below

Variable          | Description
------------------|------------------
WORKSPACE         | Working directory
AF_DIR            | ArrayFire source code directory
AF_INSTALL_PATH   | Where ArrayFire include and library files are installed. Can be relative with respect to AF_DIR/build or can be an absolute path
DEPS_DIR          | Where the dependencies are extracted from the `arrayfire_deps.zip` file
CPU, CUDA, OPENCL | To select which backends to use, set them to ON. To deselect, set them to OFF
CUDA_COMPUTE      | If building on a remote machine which cannot run CUDA, set this to the appropriate compute capability.
THREADS           | No. of logical processors to dedicate to parallel builds
MSBUILD           | MSBuild.exe file from Visual Studio 2013
GIT_EXE           | Git executable
CMAKE             | CMake executable
CMAKE_GENERATOR   | Visual Studio 2013 Win64 generator option
CTEST             | ctest executable

### rebuild_arrayfire.bat
* Builds a clean version of ArrayFire. Deletes the build directory, runs cmake, builds and installs (to AF_INSTALL_PATH) ArrayFire.

### build_arrayfire.bat
* Builds ArrayFire. This is not a clean build.
* Builds and installs ArrayFire to the install directory set in rebuild_arrayfire.bat

### run_test.bat
* Runs files from tests.
* Usage: .\run_test.bat expr device
* All tests that match the expression expr are run on the device. Both are optional.
  * Not passing expr runs all tests and not passing device runs it on the device 0.

### run_example.bat
* Runs files from examples.
* Usage: .\run_example.bat executable device
* executable must be name_backend.
* Device is optional (default 0)

### build_clMath.bat
* This file is not used when building ArrayFire using the pre-built libraries.
* This file builds the clBLAS and clFFT libraries from source.

## Building ArrayFire
The example below assume that C:\workspace is the working directory.
* Clone ArrayFire and Boost.Compute (only if building OpenCL)
    * C:\workspace\arrayfire is the ArrayFire source code
    * C:\workspace\compute is the Boost.Compute source code
* Extract the arrayfire_deps.zip into C:\workspace. This should create:
    * C:\workspace\clBLAS
    * C:\workspace\clFFT
    * C:\workspace\dependencies
* Copy the scripts from this repo into C:\workspace
* Using Git powershell (or any other command prompt) run rebuild_arrayfire.bat.

## License
* The scripts are available unser ArrayFire's BSD 3-clause license.
* The pre-built dependencies shippied in arrayfire_deps.zip are licensed under
  their own licenses.
