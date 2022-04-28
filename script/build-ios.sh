flutter build ios --release --no-codesign
cd build/ios/iphoneos
mkdir Payload
cd Payload
ln -s ../Runner.app
cd ..
zip -r app.ipa Payload
open .