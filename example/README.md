# IP Country Lookup example

Run the example on a connected Flutter device:

```sh
flutter pub get
flutter run
```

Tap **Get country data from IP** to exercise public-IP discovery and the
country/ISP provider fallback chain. The example's main Android manifest
already includes the Internet permission required by release builds.

Provider requests disclose the connection's public IP as described in the
package's main README. No GPS or device-location permission is used.
