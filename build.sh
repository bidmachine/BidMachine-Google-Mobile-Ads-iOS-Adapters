#!/bin/bash

# 1
# Set bash script to exit immediately if any commands fail.
set -e

rm -rf build
rm -rf release

mkdir -p build
mkdir -p build/release

start=`date +%s`
# 2
# Setup some constants for use later on.
FRAMEWORK_NAMES=(
	"BidMachineAdMobAdManager"
	)

pod install

# 3
# Build the framework for device and for simulator (using
# all needed architectures).
for framework_name in ${FRAMEWORK_NAMES[@]}; do
	xcodebuild  -workspace AdMobBidMachineSample.xcworkspace \
				-scheme "${framework_name}" \
				-sdk iphoneos \
				-configuration Debug \
				GCC_GENERATE_DEBUGGING_SYMBOLS=NO \
                STRIP_INSTALLED_PRODUCT=YES \
                LINK_FRAMEWORKS_AUTOMATICALLY=NO \
				OTHER_CFLAGS="-fembed-bitcode -Qunused-arguments" \
				ONLY_ACTIVE_ARCH=NO \
				DEPLOYMENT_POSTPROCESSING=YES \
				MACH_O_TYPE=staticlib \
				IPHONEOS_DEPLOYMENT_TARGET=9.0 \
				CONFIGURATION_BUILD_DIR="${PWD}/build/iphones" \
				build 

	xcodebuild  -workspace AdMobBidMachineSample.xcworkspace \
				-scheme "${framework_name}" \
				-sdk iphonesimulator \
				-configuration Debug \
				GCC_GENERATE_DEBUGGING_SYMBOLS=NO \
                STRIP_INSTALLED_PRODUCT=YES \
                LINK_FRAMEWORKS_AUTOMATICALLY=NO \
				OTHER_CFLAGS="-fembed-bitcode -Qunused-arguments" \
				ONLY_ACTIVE_ARCH=NO \
				DEPLOYMENT_POSTPROCESSING=YES \
				MACH_O_TYPE=staticlib \
				IPHONEOS_DEPLOYMENT_TARGET=9.0 \
				CONFIGURATION_BUILD_DIR="${PWD}/build/iphonesimulator" \
				build 

	# 4
	# Remove .framework file if exists on Release dir from previous run.
	if [ -d "${PWD}/build/release/${framework_name}.framework" ]; then
		rm -rf "${PWD}/build/release/${framework_name}.framework"
	fi

	# 5
	# Copy the simulator version of framework to Desktop.
	rm -rf "${PWD}/build/iphonesimulator/${framework_name}.framework/_CodeSignature"
	rm -rf "${PWD}/build/iphonesimulator/${framework_name}.framework/Frameworks"

	mkdir -p "${PWD}/build/release/${framework_name}.framework"
	
	cp -r "${PWD}/build/iphonesimulator/${framework_name}.framework/" "${PWD}/build/release/${framework_name}.framework/"
	rm -rf "${PWD}/build/release/${framework_name}.framework/Info.plist"

	if [[ -d "${PWD}/build/iphones/${framework_name}.framework/Modules/${framework_name}.swiftmodule" ]]; then
		cp -a "${PWD}/build/iphones/${framework_name}.framework/Modules/${framework_name}.swiftmodule/." "${PWD}/build/release/${framework_name}.framework/Modules/${framework_name}.swiftmodule/"
	fi 

	# 6
	# Replace the framework executable within the framework with
	# a new version created by merging the device and simulator
	# frameworks' executables with lipo.
	lipo -create -output "${PWD}/build/release/${framework_name}.framework/${framework_name}" \
							"${PWD}/build/iphonesimulator/${framework_name}.framework/${framework_name}" \
							"${PWD}/build/iphones/${framework_name}.framework/${framework_name}" 

done

cd "build/release"
touch "Dummy.swift"
echo "import Foundation" > "Dummy.swift"

end=`date +%s`
runtime=$((end-start))
echo "🚀 Build finished at: $runtime seconds"