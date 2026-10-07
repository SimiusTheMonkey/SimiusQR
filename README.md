# SimiusQR

An ad-free QR code scanner for Android. Scan a code, see the **real** destination, and tap to
open it. Nothing opens automatically.

Most scanner apps in the app stores bury the decoded link under ads that look like buttons.
SimiusQR does one job: it shows you what the QR code actually says and lets you decide.

## What it does

- Scans a QR code with the camera.
- Shows the full decoded link (or phone number, email, SMS) in plain text.
- Opens it only when you tap the button. No auto-redirect.

## What it does not do

- No ads.
- No analytics, tracking, or telemetry.
- **No internet access.** The app does not request the `INTERNET` permission, so Android
  itself blocks it from using the network. The only permission it asks for is the camera.
  You can confirm this on the app info page, or in the APK:
  `aapt2 dump permissions app-release.apk`.

Note: the scanning library (`mobile_scanner`, which uses Google ML Kit) tries to add network
permissions to the app for its own usage reporting. `android/app/src/main/AndroidManifest.xml`
strips them out on purpose. Scanning runs entirely on-device.

## Install

1. Download `app-release.apk` from the [Releases](../../releases) page.
2. Open it on your phone. Android will ask you to allow installing from that source (your
   browser or file manager). This is a one-time "Install unknown apps" setting, not developer mode.
3. Play Protect will block the install with "App blocked to protect your device ... hasn't
   seen an app from this developer before". This is expected for any new app that isn't from
   the Play Store. Tap **More details**; the **Install anyway** link is plain text further down
   the expanded section (you may need to scroll or expand more than once).
4. Allow the camera permission on first launch.

Requires Android 6.0 (API 23) or newer.

### Verify the download

Releases are signed with a key held by the author. Check it with `apksigner`
(from the Android SDK build-tools):

```
apksigner verify --print-certs app-release.apk
```

Expected signer: `CN=Simius, O=SimiusQR`

SHA-256 fingerprint:
`3933889c90ddbc13f30ebfe0ab6baed7d2a6c940e5fe91208336f8c6c00c9f51`

## Build it yourself

You need [Flutter](https://docs.flutter.dev/get-started/install) and the Android SDK.

```
flutter pub get
flutter build apk --release
```

The result is `build/app/outputs/flutter-apk/app-release.apk`. A build from source is signed
with Flutter's debug key unless you provide your own keystore, so its fingerprint will differ
from the official release. To sign with your own key, set `SIMIUSQR_KEYSTORE_PW` (and optionally
`SIMIUSQR_KEYSTORE` for the path) before building; see `android/app/build.gradle.kts`.

The code is small: `lib/` has four files (`main.dart`, `scanner_screen.dart`,
`result_screen.dart`, `uri_utils.dart`).

## Support

If you find it useful, you can [buy me a coffee](https://buymeacoffee.com/Simius). Entirely
optional.

## License

MIT. See [LICENSE](LICENSE).
