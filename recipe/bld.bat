set OPENSSL_DIR=%LIBRARY_PREFIX%
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