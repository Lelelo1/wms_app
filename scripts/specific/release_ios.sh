
flutter build ipa  --export-options-plist=scripts/specific/ExportOptions.plist

firebase appdistribution:distribute build/ios/ipa/wms_app.ipa \
    --app $WMS_FIREBASE_IOS_APPID  