
flutter build apk --release --dart-define="CONFIGURATION=prod"
#
# https://firebase.google.com/docs/app-distribution/android/distribute-cli

firebase appdistribution:distribute build/app/outputs/flutter-apk/app-release.apk \
    --app $WMS_FIREBASE_ANDROID_APPID  
