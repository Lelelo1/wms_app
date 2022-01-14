
#https://stackoverflow.com/questions/67964110/how-to-access-secrets-when-using-flutter-web-with-github-actions

echo $WMS_SECRETS_FIREBASE | base64 -d > ./lib/WMS_Secrets_Firebase.dart