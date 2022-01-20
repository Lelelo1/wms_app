
#flutter build apk --release

# https://firebase.google.com/docs/app-distribution/android/distribute-cli

firebase appdistribution:distribute build/app/outputs/flutter-apk/app-release.apk \
    --app $WMS_FIREBASE_ANDROID_APPID  
