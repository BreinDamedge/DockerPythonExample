:: This is just a .bat script that builds the container for the pi.
:: I just didn't want to have to remember the build platform.

@echo off
SET image_name=python-test
SET build_platform=linux/arm64/v8

:: Script
:: Build for machine
echo Building...
:: add to end of build to build for arm: --platform %build_platform%
docker build -t %image_name% . --platform %build_platform%

echo Finished.