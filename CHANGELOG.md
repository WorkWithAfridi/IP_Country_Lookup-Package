## 1.1.0

- Updated Dio and development dependencies to their latest stable releases.
- Added fallback providers for public-IP and country/ISP lookup.
- Added request timeouts, IP validation, response validation, and safe failure
  results when every provider is unavailable.
- Added camelCase model properties while retaining deprecated 1.0.x aliases.
- Fixed `IpCountryData` JSON round-tripping for country codes.
- Exported `IpCountryData` from the package's main library.
- Modernized the example and replaced its stale widget test.
- Migrated the example to Flutter's current Android Gradle plugin format and
  current iOS application lifecycle.
- Added tests for provider failover and response parsing.

## 1.0.3
- Dependencies updated
## 1.0.2
- Documentation update
## 1.0.1
- Updated in-app screenshots
## 1.0.0
- Release v1.0.0 
