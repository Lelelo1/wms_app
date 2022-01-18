

#https://stackoverflow.com/questions/67964110/how-to-access-secrets-when-using-flutter-web-with-github-actions

if [ ! -f ./.gitignore ]; then
    echo "Gitignore not found!"
    exit [0];
fi

# follwing works, (the grep part is making print)
if ! grep "/lib/secrets/" .gitignore; then
    echo "/lib/secrets/" >> .gitignore
fi

mkdir ./lib/secrets
echo $WMS_SECRETS_FIREBASE | base64 -d > ./lib/secrets/WMS_Secrets_Firebase.dart
echo $WMS_KATSUMI_DATABASE_SETTINGS | base64 -d > ./lib/secrets/WMS_Katsumi_Database_Settings.dart
