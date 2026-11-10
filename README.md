# IP Country Lookup

A Flutter package for retrieving a user's public IP address and its associated
country and ISP.

## Features

- IPv4 and IPv6 support.
- Country name, ISO country code, and ISP lookup.
- Automatic fallback between multiple no-key providers.
- Five-second timeout per provider when using the default HTTP client.
- A structured `503` result when all location providers are unavailable.

## Install

```yaml
dependencies:
  ip_country_lookup: ^1.1.0
```

The package requires Dart 3.8 or newer and Flutter 3.32 or newer.

## Use

```dart
import 'package:ip_country_lookup/ip_country_lookup.dart';

final IpCountryLookup lookup = IpCountryLookup();
final IpCountryData data = await lookup.getIpLocationData();

if (data.responseCode == '200') {
  print('${data.countryName} (${data.countryCode})');
  print(data.isp);
} else {
  print(data.responseMessage);
}
```

`getIpLocationData()` performs public-IP discovery itself. To retrieve only the
public IP address, use:

```dart
final String publicIp = await IpCountryLookup().getUserIpAddress();
```

Calling both methods performs two independent public-IP requests because lookup
results are not cached.

## Return values and failures

`getUserIpAddress()` returns an empty string if no IP provider can be reached.
`getIpLocationData()` does not throw for ordinary provider/network failures. It
returns an `IpCountryData` with `responseCode == '503'`, `N/A` location fields,
and a descriptive `responseMessage` after all fallbacks fail.

| Result | `responseCode` | `ip` | Country/ISP fields |
| --- | --- | --- | --- |
| Successful lookup | `200` | Discovered address | Provider values |
| IP discovered, location providers failed | `503` | Discovered address | `N/A` |
| IP discovery failed | `503` | `0.0.0.0` | `N/A` |

`isp` can be `null` on a successful lookup if the selected provider does not
return an ISP or network organization. A provider can take up to five seconds
to time out, and providers are attempted sequentially, so a complete outage can
take longer than five seconds to resolve.

### Migrating from 1.0.x

Importing `ip_country_lookup.dart` now also exports `IpCountryData`, so a
separate model import is no longer needed. Prefer these camelCase properties:

- `ipNumber`
- `ipVersion`
- `countryName`
- `countryCode`
- `responseCode`
- `responseMessage`

The previous snake_case constructor arguments, getters, and setters remain as
deprecated aliases for source compatibility.

## Provider fallback and privacy

Public IP discovery tries these HTTPS services in order:

1. [ipify](https://www.ipify.org/) (`api64.ipify.org`)
2. [icanhazip](https://icanhazip.com/) (`icanhazip.com`)
3. [AWS Check IP](https://checkip.amazonaws.com/) (`checkip.amazonaws.com`)

Country/ISP lookup then tries:

1. [ipwho.is](https://ipwhois.io/documentation)
2. [ipapi.co](https://ipapi.co/api/)
3. the legacy [IPLocation.net](https://api.iplocation.net/) endpoint

Only the providers needed to complete a lookup are contacted. A fallback is
contacted when a preceding provider times out, returns an error, or returns an
invalid response. Every attempted IP service observes the request's source IP,
and the discovered public IP is sent to every attempted location service. A
fallback therefore shares the address with an additional provider. Provider
availability, rate limits, response accuracy, terms, and privacy policies are
outside this package's control; review them before production use.

IP geolocation is approximate. VPNs, proxies, mobile networks, and carrier-grade
NAT can change or obscure the reported country and ISP.

## Platform setup

The package uses HTTPS and requires network access. Android release builds must
declare Internet access in `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET" />
```

The included example already declares this permission. Apple platforms do not
require a location permission because the package does not access GPS or other
device-location APIs.

See the `example` directory for a runnable Flutter application.

## Development checks

```sh
flutter analyze
flutter test
cd example
flutter analyze
flutter test
```

## Support

For issues and feature requests, open an issue in the
[GitHub repository](https://github.com/WorkWithAfridi/IP_Country_Lookup-Package).
