set OPENSSL_DIR=%LIBRARY_PREFIX%
REM GitHub tag tarballs do not preserve symlinks on Windows. Upstream keeps protos in repo
REM root (protos/) and rust/lance-datafusion/protos is a symlink; build.rs expects files
REM under rust/lance-datafusion/protos. Copy from SRC_DIR/protos when missing.
if exist "%SRC_DIR%\rust\lance-datafusion\protos\table_identifier.proto" goto :protos_ok
rd /s /q "%SRC_DIR%\rust\lance-datafusion\protos" 2>nul
del /f /q "%SRC_DIR%\rust\lance-datafusion\protos" 2>nul
mkdir "%SRC_DIR%\rust\lance-datafusion\protos"
xcopy "%SRC_DIR%\protos\*" "%SRC_DIR%\rust\lance-datafusion\protos\" /E /I /Y
:protos_ok
REM Create temp folder
mkdir tmpbuild_%PY_VER%
set TEMP=%CD%\tmpbuild_%PY_VER%
REM Bundle all downstream library licenses
cd python
cargo-bundle-licenses ^
    --format yaml ^
    --output %SRC_DIR%\THIRDPARTY.yml ^
    || goto :error
REM install the package
%PYTHON% -m pip install . -vv --no-deps --no-build-isolation