`dart run build_runner build --delete-conflicting-outputs`
`flutter pub upgrade --major-versions`

Sometimes I name folders so it get good material icon

# Setup
1- Firebase: First setup firebase for both android/ios, register the apps and download the configurations and put
them in the desire place, "google-services.json" for android, ios "GoogleService-Info.plist"
already ignored in the .gitignore

2- Permissions

    Android:
        "<uses-feature
        android:name="android.hardware.camera"
        android:required="false" />

    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.CAMERA" />
    <uses-permission
        android:name="android.permission.WRITE_EXTERNAL_STORAGE"
        android:maxSdkVersion="29" />"

    Ios:
    "<key>NSCameraUsageDescription</key>
	<string>We need access to the photo library so you take a photo</string>
	<key>NSPhotoLibraryUsageDescription</key>
	<string>We need access to the photo library so you pick image</string>
	<key>NSPhotoLibraryAddUsageDescription</key>
	<string>To save images into the library, we need permission from you</string>
	<key>FirebaseAutomaticScreenReportingEnabled</key>
	<false/>"

3- Create firebase firestore index

Composite indexes:
userId: Ascending
updatedAt: Descending
__name__ Descending

Instead of defining a composite index manually, try to run all the queries in the app by testing everything to get a links for generating the required index.
[Example](https://console.firebase.google.com/v1/r/project/mynotes-eb717/firestore/indexes?create_composite=Cktwcm9qZWN0cy9teW5vdGVzLWViNzE3L2RhdGFiYXNlcy8oZGVmYXVsdCkvY29sbGVjdGlvbkdyb3Vwcy9ub3Rlcy9pbmRleGVzL18QARoKCgZ1c2VySWQQARoNCgl1cGRhdGVkQXQQAhoMCghfX25hbWVfXxAC)