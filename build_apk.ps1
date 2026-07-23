New-Item -ItemType Directory -Force -Path "C:\ProjectMobile"
robocopy "c:\Users\MyBook Hype AMD\Downloads\Project Mobile\Day_Care" "C:\ProjectMobile\Day_Care" /E /XD .git .idea build .dart_tool
Set-Location "C:\ProjectMobile\Day_Care"
if (Test-Path "android\.gradle") { Remove-Item -Recurse -Force "android\.gradle" }
if (Test-Path "android\app\build") { Remove-Item -Recurse -Force "android\app\build" }
if (Test-Path "android\.idea") { Remove-Item -Recurse -Force "android\.idea" }
flutter clean
flutter pub get
flutter build apk
copy "build\app\outputs\flutter-apk\app-release.apk" "C:\Users\MyBook Hype AMD\Downloads\DayCare-App.apk"
