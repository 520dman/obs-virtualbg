@echo on
setlocal enabledelayedexpansion

cd %~dp0
cd ..
set DEPS_DIR=%CD%\deps

set ONNXRUNTIME_VERSION=1.9.0
set HALIDE_VERSION=12.0.1

set ONNXRUNTIME_URL=https://github.com/microsoft/onnxruntime/releases/download/v1.9.0/Microsoft.ML.OnnxRuntime.DirectML.%ONNXRUNTIME_VERSION%.zip
set ONNXRUNTIME_ZIP=%DEPS_DIR%\Microsoft.ML.OnnxRuntime.DirectML.%ONNXRUNTIME_VERSION%.zip
set ONNXRUNTIME_DIR=%DEPS_DIR%\onnxruntime

set HALIDE_URL=https://github.com/halide/Halide/releases/download/v12.0.1/Halide-12.0.1-x86-64-windows-5dabcaa9effca1067f907f6c8ea212f3d2b1d99a.zip
set HALIDE_ZIP=Halide-%HALIDE_VERSION%.zip
set HALIDE_DIR=%DEPS_DIR%\Halide-%HALIDE_VERSION%-x86-64-windows

IF not exist deps mkdir deps

pushd %DEPS_DIR%
  IF not exist %ONNXRUNTIME_ZIP% curl -L -o %ONNXRUNTIME_ZIP% %ONNXRUNTIME_URL%
  IF not exist %ONNXRUNTIME_DIR% 7z x -o%ONNXRUNTIME_DIR% %ONNXRUNTIME_ZIP%

  IF not exist %HALIDE_ZIP% curl -L -o %HALIDE_ZIP% %HALIDE_URL%
  IF not exist %HALIDE_DIR% 7z x %HALIDE_ZIP%
popd


call %~dp0\build_obs.bat
IF ERRORLEVEL 1 goto ERR

IF exist build rmdir /s /q build
mkdir build
pushd build
  cmake ^
    -DobsPath=%DEPS_DIR%\obs-studio ^
    -DOnnxRuntimePath=%ONNXRUNTIME_DIR% ^
    -DCMAKE_SYSTEM_VERSION=10.0.18363.657 ^
    -DHalide_DIR=%HALIDE_DIR%\lib\cmake\Halide ^
    -DHalideHelpers_DIR=%HALIDE_DIR%\lib\cmake\HalideHelpers ^
    ..
  IF ERRORLEVEL 1 GOTO ERR
  cmake --build . --config RelWithDebInfo
  IF ERRORLEVEL 1 GOTO ERR
  cpack
  IF ERRORLEVEL 1 GOTO ERR
popd

goto END
:ERR
echo BUILD ERROR %ERRORLEVEL%
exit /b 1


:END
endlocal
