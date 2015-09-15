#!/bin/sh

# Only if needed
if ./ignore.sh; then exit 0; fi

# Extract SDK version from tiapp.xml
TI_SDK_VERSION=$(grep tiapp.xml -e "<sdk-version>" | grep -oE "\d+\.\d+\.\d+")
echo "======== Titanium SDK version: $TI_SDK_VERSION"

# Extract the build url
TI_SDK_FILE=$(curl http://builds.appcelerator.com/mobile/master/index.json -X GET | \
    grep -oE "mobilesdk-$TI_SDK_VERSION.\w+-osx.zip" | tail -1)
echo "======== Titanium SDK file: $TI_SDK_FILE"

# Now, define the correct grabbed version for the build
TI_SDK_BUILD_VERSION=$(echo $TI_SDK_FILE | grep -oE "\d+\.\d+\.\d+\.?(GA)?\.\w+")
source bump_version.sh sdk $TI_SDK_BUILD_VERSION
echo "======== Titanium SDK build version: $TI_SDK_BUILD_VERSION"

# Install the sdk
echo "======== Install Titanium SDK"
titanium login travisci@appcelerator.com travisci
curl -o $TI_SDK_FILE http://builds.appcelerator.com/mobile/master/$TI_SDK_FILE
titanium sdk install $TI_SDK_FILE --no-progress-bars

# Install Android
if [ $PLATFORM = "android" ]; then
    echo "======== Install Android SDK v$ANDROID_VERSION"
    curl -o $ANDROID_SDK_FILE http://dl.google.com/android/${ANDROID_SDK_FILE}
    unzip -q $ANDROID_SDK_FILE -d $ANDROID_HOME
    titanium config android.sdkPath $ANDROID_SDK
    echo yes | android -s update sdk --no-ui --all --filter android-8
    echo yes | android -s update sdk --no-ui --all --filter android-10
    echo yes | android -s update sdk --no-ui --all --filter android-$ANDROID_VERSION
    echo yes | android -s update sdk --no-ui --all --filter sys-img-armeabi-v7a-android-$ANDROID_VERSION
    echo yes | android -s update sdk --no-ui --all --filter addon-google_apis-google-$ANDROID_VERSION
    echo yes | android -s update sdk --no-ui --all --filter extra-android-support
    echo yes | android -s update sdk --no-ui --all --filter tools
    echo yes | android -s update sdk --no-ui --all --filter platform-tools
    echo yes | android -s update sdk --no-ui --all --filter build-tools-19.1.0
    echo yes | android -s update sdk --no-ui --all --filter build-tools-20.0.0
    echo yes | android -s update sdk --no-ui --all --filter build-tools-21.0.0
    echo yes | android -s update sdk --no-ui --all --filter build-tools-22.0.0
fi
