import 'dart:convert';

// Backward-compatible aliases retain the public snake_case API from 1.0.x.
// ignore_for_file: non_constant_identifier_names

/// Country and network information associated with a public IP address.
///
/// Values are mutable for compatibility with the 1.0.x API. New code should use
/// the camelCase properties; deprecated snake_case aliases remain available for
/// migration.
class IpCountryData {
  /// Creates an IP country lookup result.
  ///
  /// If both forms of a property are supplied, the camelCase value takes
  /// precedence over its deprecated snake_case alias.
  IpCountryData({
    this.ip,
    String? ipNumber,
    @Deprecated('Use ipNumber instead.') String? ip_number,
    String? ipVersion,
    @Deprecated('Use ipVersion instead.') String? ip_version,
    String? countryName,
    @Deprecated('Use countryName instead.') String? country_name,
    String? countryCode,
    @Deprecated('Use countryCode instead.') String? country_code,
    this.isp,
    String? responseCode,
    @Deprecated('Use responseCode instead.') String? response_code,
    String? responseMessage,
    @Deprecated('Use responseMessage instead.') String? response_message,
  }) : ipNumber = ipNumber ?? ip_number,
       ipVersion = ipVersion ?? ip_version,
       countryName = countryName ?? country_name,
       countryCode = countryCode ?? country_code,
       responseCode = responseCode ?? response_code,
       responseMessage = responseMessage ?? response_message;

  /// The public IPv4 or IPv6 address used for the location lookup.
  String? ip;

  /// The provider's numeric representation of [ip], when available.
  String? ipNumber;

  /// The IP version, normally `'4'` or `'6'`.
  String? ipVersion;

  /// The country name associated with [ip].
  String? countryName;

  /// The two-letter ISO 3166-1 country code associated with [ip].
  String? countryCode;

  /// The Internet service provider or network organization, when available.
  String? isp;

  /// The normalized lookup status code.
  ///
  /// Package lookups return `'200'` for success and `'503'` after all required
  /// providers fail.
  String? responseCode;

  /// A provider message, `'OK'` on normalized success, or a failure summary.
  String? responseMessage;

  /// Converts this value to the wire-compatible map used in earlier releases.
  Map<String, dynamic> toMap() => <String, dynamic>{
    'ip': ip,
    'ip_number': ipNumber,
    'ip_version': ipVersion,
    'country_name': countryName,
    'country_code': countryCode,
    'isp': isp,
    'response_code': responseCode,
    'response_message': responseMessage,
  };

  /// Creates a result from camelCase or supported provider-style map keys.
  factory IpCountryData.fromMap(Map<String, dynamic> map) => IpCountryData(
    ip: _asString(map['ip']),
    ipNumber: _asString(map['ip_number'] ?? map['ipNumber']),
    ipVersion: _asString(map['ip_version'] ?? map['ipVersion']),
    countryName: _asString(map['country_name'] ?? map['countryName']),
    countryCode: _asString(
      map['country_code2'] ?? map['country_code'] ?? map['countryCode'],
    ),
    isp: _asString(map['isp']),
    responseCode: _asString(map['response_code'] ?? map['responseCode']),
    responseMessage: _asString(
      map['response_message'] ?? map['responseMessage'],
    ),
  );

  /// Encodes this result as a JSON object using the keys from [toMap].
  String toJson() => json.encode(toMap());

  /// Decodes a result from a JSON object accepted by [fromMap].
  factory IpCountryData.fromJson(String source) => IpCountryData.fromMap(
    (json.decode(source) as Map<Object?, Object?>).map(
      (Object? key, Object? value) => MapEntry(key.toString(), value),
    ),
  );

  @override
  String toString() =>
      'IpCountryData(ip: $ip, ipNumber: $ipNumber, ipVersion: $ipVersion, '
      'countryName: $countryName, countryCode: $countryCode, isp: $isp, '
      'responseCode: $responseCode, responseMessage: $responseMessage)';

  /// Deprecated alias for [ipNumber].
  @Deprecated('Use ipNumber instead.')
  String? get ip_number => ipNumber;

  /// Updates [ipNumber].
  @Deprecated('Use ipNumber instead.')
  set ip_number(String? value) => ipNumber = value;

  /// Deprecated alias for [ipVersion].
  @Deprecated('Use ipVersion instead.')
  String? get ip_version => ipVersion;

  /// Updates [ipVersion].
  @Deprecated('Use ipVersion instead.')
  set ip_version(String? value) => ipVersion = value;

  /// Deprecated alias for [countryName].
  @Deprecated('Use countryName instead.')
  String? get country_name => countryName;

  /// Updates [countryName].
  @Deprecated('Use countryName instead.')
  set country_name(String? value) => countryName = value;

  /// Deprecated alias for [countryCode].
  @Deprecated('Use countryCode instead.')
  String? get country_code => countryCode;

  /// Updates [countryCode].
  @Deprecated('Use countryCode instead.')
  set country_code(String? value) => countryCode = value;

  /// Deprecated alias for [responseCode].
  @Deprecated('Use responseCode instead.')
  String? get response_code => responseCode;

  /// Updates [responseCode].
  @Deprecated('Use responseCode instead.')
  set response_code(String? value) => responseCode = value;

  /// Deprecated alias for [responseMessage].
  @Deprecated('Use responseMessage instead.')
  String? get response_message => responseMessage;

  /// Updates [responseMessage].
  @Deprecated('Use responseMessage instead.')
  set response_message(String? value) => responseMessage = value;

  static String? _asString(Object? value) => value?.toString();
}
