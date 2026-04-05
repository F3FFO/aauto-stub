#/bin/bash

# Clean
rm -f stub-unaligned.apk stub.apk stub.apk.idsig

# Value of minSdk
MIN_SDK="${1:-21}"
# Output APK name (default stub.apk)
APK_NAME="${2:-stub.apk}"

# Make APK
aapt package -M AndroidManifest.xml -I $ANDROID_HOME/platforms/android-35/android.jar -F stub-unaligned.apk --min-sdk-version $MIN_SDK --target-sdk-version 35

# Align APK
zipalign 4 stub-unaligned.apk "$APK_NAME"
rm stub-unaligned.apk

# Sign APK
apksigner sign --cert data/cert.pem --key data/cert.pk8 --v1-signing-enabled true --v2-signing-enabled false --v3-signing-enabled false --v4-signing-enabled false "$APK_NAME"

rm "${APK_NAME}.idsig" 2>/dev/null || true

echo "Created: $APK_NAME"
