import 'package:ip_country_lookup/api/api_repo.dart';

export 'package:ip_country_lookup/models/ip_country_data_model.dart';

import 'package:ip_country_lookup/models/ip_country_data_model.dart';

/// Looks up public-IP, country, and ISP information for the current connection.
///
/// [IpCountryLookup] is a singleton. Each method call performs a new lookup;
/// results are not cached.
class IpCountryLookup {
  IpCountryLookup._internal();

  static final IpCountryLookup _ipCountryLookup = IpCountryLookup._internal();
  final ApiRepo _apiRepo = ApiRepo();

  /// Returns the shared lookup instance.
  factory IpCountryLookup() => _ipCountryLookup;

  /// Looks up the caller's public IP, country, and ISP.
  ///
  /// This method first discovers the public IP, then tries the location
  /// providers in sequence. Provider, network, timeout, and invalid-response
  /// failures trigger the next fallback.
  ///
  /// A successful result has [IpCountryData.responseCode] set to `'200'`. If
  /// every required provider fails, the method returns a result with response
  /// code `'503'`, `N/A` location fields, and a descriptive response message.
  /// Ordinary provider failures are represented in the result rather than
  /// thrown.
  Future<IpCountryData> getIpLocationData() => _apiRepo.getIpLocationData();

  /// Returns the caller's validated public IPv4 or IPv6 address.
  ///
  /// Returns an empty string when every public-IP provider fails, times out, or
  /// returns an invalid address.
  Future<String> getUserIpAddress() async =>
      await _apiRepo.getUserIPAddress() ?? '';
}
