# NannyMcTeaSitters
Client mobile app for baby sitting business.

# https://www.nannymcteasitters.com/plans-pricing

#Key for creating APK is located here.
storeFile=/Users/treyhope/key.jks

## Create keystore file.
- Command [keytool -genkey -v -keystore ~/key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key]

## Build Android APK
- Command [flutter clean]
- Command [flutter build apk --release]
- Located [build/app/outputs/apk/release/app-release.apk]

## Build iOS IPA
- Command [flutter clean]
- Command [flutter build ios --release]
- Then go to PRODUCT -> ARCHIVE in XCODE
- Select VERSION OR PLATFORM to current version, (2.2.2)

## Beautify Flutter Code
- Command [shift + option + f]

## Splash Screen
mipmap-xxxhdpi in the Android folder when using App Icon tends to work best for both platforms.

##iPhone Dimensions
iPhone 3+4 (3.5 Inch)
    640 x 960
iPhone 5, iPhone 5S, iPhone 5C (4 Inch)
    640 x 1136
iPhone 6, iPhone 6S, iPhone 7, iPhone 8 (4.7 Inch)
    750 x 1334
iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus, iPhone 8 Plus (5.5 Inch)
    1242 x 2208
iPhone X (5.8 Inch)
    1125 x 2436
iPhone XS (5.8 Inch)
    1125 x 2436
iPhone XS Max, iPhone XR (6.5 Inch)
    1242 x 2688
iPad Mini 2, iPad Mini 3, iPad Mini 4 (7.9 Inch)
    1536 x 2048
iPad 3, iPad 4, iPad Pro, iPad Air, iPad Air 2 (9.7 Inch)
    1536 x 2048
iPad Pro (10.5 Inch)
    1668 x 2224
iPad Pro (12.9 Inch)
    2048 x 2732
Apple Watch Series 1, Apple Watch Series 2, Apple Watch Series 3 - 38mm (1.5 Inch)
    272 x 340
Apple Watch Series 4 - 40mm (1.57 Inch)
    394 x 324
Apple Watch Series 1, Apple Watch Series 2, Apple Watch Series 3 - 42mm (1.65 Inch)
    312 x 390
Apple Watch Series 4 - 44mm (1.78 Inch)
    448 x 368 -->

# How to Add Local Project to Bit Bucket
Git clone an existing repository.
git init
git remote add origin [my-repo]
git fetch
git checkout origin/master -ft

# ERROR FIX
pod update
"NameError - uninitialized constant Concurrent::Promises, Did you mean?  Concurrent::Promise"
sudo gem update concurrent-ruby

# iOS Swift Version Error
Bridging Header must be created.
Open the project with XCode. Then choose File -> New -> File -> Swift File.
A dialog will be displayed when creating the swift file(Since this file is deleted, any name can be used.). XCode will ask you if you wish to create Bridging Header, click yes.
Make sure you have use_frameworks! in the Runner block, in ios/Podfile。
Make sure you have SWIFT_VERSION 4.2 selected in you XCode -> Build Settings
Do flutter clean
Go to your ios folder, delete Podfile.lock and Pods folder and then execute pod install --repo-update
Thank you for giving detailed report!!