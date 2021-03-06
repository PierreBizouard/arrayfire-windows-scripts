@echo off
setlocal EnableDelayedExpansion

call common.bat

SET OLDDIR=%CD%
cd %AF_DIR%

if "%1"=="clean" (
	REM CLEAN BUILD
	echo "Cloning submodules"
	"%GIT_EXE%" submodule init
	"%GIT_EXE%" submodule update

	echo "Cleaning build directory"
	REM Clean build space
	rmdir /Q /S build
	mkdir build
)

cd build

REM Generate cmake
SET CPU_OPTIONS=-DBUILD_CPU:BOOL=OFF
SET CUDA_OPTIONS=-DBUILD_CUDA:BOOL=OFF
SET OPENCL_OPTIONS=-DBUILD_OPENCL:BOOL=OFF
if "%CPU%"=="ON" (
    echo "Running CPU CMake Configuration"
    SET CPU_OPTIONS=-DBUILD_CPU:BOOL=ON %FFT_OPTIONS% %BLAS_OPTIONS% %LAPACK_OPTIONS%
)
if "%CUDA%"=="ON" (
    echo "Running CUDA CMake Configuration"
    if %CUDA_COMPUTE_DETECT%=="ON" (
        SET CUDA_OPTIONS=-DBUILD_CUDA:BOOL=ON -DBOOST_INCLUDEDIR:STRING="%DEPS_DIR%/boost_1_56_0"
    ) else (
        SET CUDA_OPTIONS=-DBUILD_CUDA:BOOL=ON -DCUDA_COMPUTE_DETECT:BOOL=OFF -DCUDA_COMPUTE_20:BOOL=%CUDA_COMPUTE_20% -DCUDA_COMPUTE_30:BOOL=%CUDA_COMPUTE_30% -DCUDA_COMPUTE_32:BOOL=%CUDA_COMPUTE_32% -DCUDA_COMPUTE_50:BOOL=%CUDA_COMPUTE_50% -DCUDA_COMPUTE_52:BOOL=%CUDA_COMPUTE_52%	-DBOOST_INCLUDEDIR:STRING="%DEPS_DIR%/boost_1_56_0"
    )
)
if "%OPENCL%"=="ON" (
    echo "Running OpenCL CMake Configuration"
     SET OPENCL_OPTIONS=-DBUILD_OPENCL:BOOL=ON -DBOOST_INCLUDEDIR:STRING="%DEPS_DIR%/boost_1_56_0" %LAPACK_OPTIONS%
)

echo "Generating CMAKE"
%CMAKE% .. %CMAKE_GENERATOR% -DCMAKE_BUILD_TYPE:STRING="%BUILD_TYPE%" -DCMAKE_INSTALL_PREFIX:STRING=%AF_INSTALL_PATH% -DBUILD_TEST:STRING=%TESTS% -DBUILD_GTEST:STRING=%TESTS% -DBUILD_EXAMPLES:STRING=%EXAMPLES% %FREEIMAGE_OPTIONS% %GRAPHICS_OPTIONS% %CPU_OPTIONS% %CUDA_OPTIONS% %OPENCL_OPTIONS%

@echo off

echo "Running MSBuild"
REM Build
%MSBUILD% /p:Configuration=%BUILD_TYPE% ArrayFire.sln
%MSBUILD% /p:Configuration=%BUILD_TYPE% INSTALL.vcxproj

cd %OLDDIR%
