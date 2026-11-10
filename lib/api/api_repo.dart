import 'dart:convert';

import 'package:dio/dio.dart';

import '../models/ip_country_data_model.dart';

/// Makes a GET request to [uri] and returns its response body.
///
/// The body may be a decoded JSON value or plain text. Implementations may
/// throw; [ApiRepo] treats a thrown value as a provider failure and moves to the
/// next fallback.
typedef ApiRequest = Future<Object?> Function(Uri uri);

/// Coordinates public-IP discovery and country/ISP provider fallbacks.
///
/// Most applications should use `IpCountryLookup` from the package's main
/// library. This class is public primarily to support custom Dio clients and
/// deterministic tests.
class ApiRepo {
  /// Creates a repository.
  ///
  /// When [request] is supplied, it handles every provider request and [dio]
  /// and [timeout] are ignored. Otherwise [dio] is used as-is. If neither is
  /// supplied, a Dio client is created with [timeout] as its connect, send, and
  /// receive timeout. The default timeout is five seconds per provider.
  ApiRepo({
    Dio? dio,
    ApiRequest? request,
    Duration timeout = const Duration(seconds: 5),
  }) : _request =
           request ??
           _DioRequester(
             dio ??
                 Dio(
                   BaseOptions(
                     connectTimeout: timeout,
                     receiveTimeout: timeout,
                     sendTimeout: timeout,
                     responseType: ResponseType.plain,
                   ),
                 ),
           ).get;

  final ApiRequest _request;

  static final List<Uri> _ipProviders = <Uri>[
    Uri.parse('https://api64.ipify.org?format=json'),
    Uri.parse('https://icanhazip.com/'),
    Uri.parse('https://checkip.amazonaws.com/'),
  ];

  static final List<Uri Function(String)> _locationProviders =
      <Uri Function(String)>[
        (String ip) => Uri.https('ipwho.is', '/$ip'),
        (String ip) => Uri.https('ipapi.co', '/$ip/json/'),
        (String ip) =>
            Uri.https('api.iplocation.net', '/', <String, String>{'ip': ip}),
      ];

  /// Returns public-IP, country, and ISP information.
  ///
  /// The returned response code is `'200'` on success. When public-IP discovery
  /// or all location lookups fail, it returns a failure value with response
  /// code `'503'`; provider failures are not thrown.
  Future<IpCountryData> getIpLocationData() async {
    final String? userIpAddress = await getUserIPAddress();
    if (userIpAddress == null) {
      return _failureData(
        message: 'Unable to determine the public IP address.',
      );
    }

    for (final Uri Function(String) provider in _locationProviders) {
      try {
        final Map<String, dynamic>? data = _asMap(
          await _request(provider(userIpAddress)),
        );
        final IpCountryData? result = _parseLocation(data, userIpAddress);
        if (result != null) {
          return result;
        }
      } on Object {
        // A failed provider is expected; continue with the next fallback.
      }
    }

    return _failureData(
      ip: userIpAddress,
      message: 'All IP location providers are currently unavailable.',
    );
  }

  IpCountryData _failureData({String? ip, required String message}) {
    return IpCountryData(
      ip: ip ?? '0.0.0.0',
      ipVersion: (ip?.contains(':') ?? false) ? '6' : '4',
      countryName: 'N/A',
      countryCode: 'N/A',
      isp: 'N/A',
      responseCode: '503',
      responseMessage: message,
    );
  }

  /// Returns a validated public IPv4 or IPv6 address.
  ///
  /// Providers are tried in order. Returns `null` if they all fail, time out,
  /// or return invalid data.
  Future<String?> getUserIPAddress() async {
    for (final Uri provider in _ipProviders) {
      try {
        final Object? data = await _request(provider);
        final String? candidate =
            _asMap(data)?['ip']?.toString().trim() ?? data?.toString().trim();
        if (candidate != null && _isValidIp(candidate)) {
          return candidate;
        }
      } on Object {
        // A failed provider is expected; continue with the next fallback.
      }
    }
    return null;
  }

  static Map<String, dynamic>? _asMap(Object? value) {
    if (value is Map) {
      return value.map(
        (Object? key, Object? item) => MapEntry(key.toString(), item),
      );
    }
    if (value is String) {
      try {
        return _asMap(jsonDecode(value));
      } on FormatException {
        return null;
      }
    }
    return null;
  }

  static IpCountryData? _parseLocation(
    Map<String, dynamic>? data,
    String fallbackIp,
  ) {
    if (data == null || data['success'] == false || data['error'] == true) {
      return null;
    }

    final String? responseCode = _string(data['response_code']);
    if (responseCode != null && responseCode != '200') {
      return null;
    }

    final String? countryName =
        _string(data['country_name']) ??
        (data.containsKey('success') ? _string(data['country']) : null);
    final String? countryCode =
        _string(data['country_code2']) ??
        _string(data['country_code']) ??
        (data.containsKey('country_name') ? _string(data['country']) : null);
    final Map<String, dynamic>? connection = _asMap(data['connection']);
    final String? isp =
        _string(data['isp']) ??
        _string(connection?['isp']) ??
        _string(connection?['org']) ??
        _string(data['org']);

    if (countryName == null || countryCode == null) {
      return null;
    }

    final String ip = _string(data['ip']) ?? fallbackIp;
    return IpCountryData(
      ip: ip,
      ipNumber: _string(data['ip_number']),
      ipVersion:
          _string(data['ip_version']) ??
          _string(data['type'])?.replaceFirst('IPv', '') ??
          (ip.contains(':') ? '6' : '4'),
      countryName: countryName,
      countryCode: countryCode,
      isp: isp,
      responseCode: responseCode ?? '200',
      responseMessage: _string(data['response_message']) ?? 'OK',
    );
  }

  static String? _string(Object? value) {
    final String? result = value?.toString().trim();
    return result == null || result.isEmpty ? null : result;
  }

  static bool _isValidIp(String value) {
    if (value.isEmpty || value.length > 45 || value.contains(RegExp(r'\s'))) {
      return false;
    }

    return value.contains(':') ? _isValidIpv6(value) : _isValidIpv4(value);
  }

  static bool _isValidIpv4(String value) {
    final List<String> octets = value.split('.');
    return octets.length == 4 &&
        octets.every((String octet) {
          final int? number = int.tryParse(octet);
          return number != null &&
              number >= 0 &&
              number <= 255 &&
              number.toString() == octet;
        });
  }

  static bool _isValidIpv6(String value) {
    if (!RegExp(r'^[0-9a-fA-F:.]+$').hasMatch(value)) {
      return false;
    }

    final List<String> compressedParts = value.split('::');
    if (compressedParts.length > 2) {
      return false;
    }

    final bool isCompressed = compressedParts.length == 2;
    final List<String> segments = value
        .replaceFirst('::', ':')
        .split(':')
        .where((String segment) => segment.isNotEmpty)
        .toList();
    int segmentCount = segments.length;

    for (var index = 0; index < segments.length; index++) {
      final String segment = segments[index];
      if (segment.contains('.')) {
        if (index != segments.length - 1 || !_isValidIpv4(segment)) {
          return false;
        }
        segmentCount++;
      } else if (!RegExp(r'^[0-9a-fA-F]{1,4}$').hasMatch(segment)) {
        return false;
      }
    }

    return isCompressed ? segmentCount < 8 : segmentCount == 8;
  }
}

class _DioRequester {
  const _DioRequester(this._dio);

  final Dio _dio;

  Future<Object?> get(Uri uri) async {
    final Response<Object?> response = await _dio.getUri<Object?>(uri);
    return response.data;
  }
}
