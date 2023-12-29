:: bns | Build n' Send!
:: --------------------
:: - This is a quick batch file to build this docker image and 
:: then send it to a local registry, provided you've set one up

@echo off

:: Variables
SET image_name=python-test
:: - Uncomment below if you're building for a raspberry pi 4b running pi os lite (debian bookworm) 
:: SET build_platform=linux/arm64/v8
:: - you can change localhost to your machine's name + .local, ex. smallpapa.local is my laptop
SET repo_ip=localhost 
SET repo_port=5000


:: Script
:: Build for machine
echo Building...
:: If building for a specific platform (I built for my pi) specify with: --platform %build_platform% <-- add this to the end of the line below
docker build -t %image_name% . 

:: Push the image to your repo
echo Tagging...
docker tag %image_name% %repo_ip%:%repo_port%/%image_name%

:: Send the image to your repo
echo Pushing...
docker push %repo_ip%:%repo_port%/%image_name%

echo Finished.