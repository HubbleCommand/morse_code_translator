# Flutter Morse Code Translator
Flutter mobile app that can translate text to Morse code.

## To Morse
Users can type text, and translate it to:
- Text representation of Morse Code translation

As well as audiovisual representations:
- Audio beeps
- Flashes from phone light
- Vibrations

## From Morse
Simple two-button interface to type a short or long tone.

## Resources
### Morse Code
- https://www.codebug.org.uk/learn/step/541/morse-code-timing-rules/
- https://morsecode.world/international/timing.html
- http://www.kent-engineers.com/codespeed.htm
- https://en.wikipedia.org/wiki/Morse_code

### Callback pattern flutter
- https://stackoverflow.com/questions/57727090/call-was-called-on-null-for-parent-callback-function-from-stateful-widget
- https://stackoverflow.com/questions/51029655/call-method-in-one-stateful-widget-from-another-stateful-widget-flutter
- https://stackoverflow.com/questions/52043283/how-i-can-get-data-from-other-widget

### AdMob Ads
- https://flutter.dev/ads
- https://developers.google.com/admob/flutter/quick-start

### Release
- https://stackoverflow.com/questions/49874194/flutter-build-apk-on-release-mode-cannot-generate-updated-version
- https://docs.flutter.dev/deployment/android#configure-signing-in-gradle
- https://docs.flutter.dev/deployment/android#build-the-app-for-release

Read above articles for configuring keys. If using new key, need to upload as Upload Key to Google Play Console.

Need to run `flutter build appbundle` to generate .aab bundle file for upload.
