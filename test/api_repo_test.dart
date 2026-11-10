import 'package:flutter_test/flutter_test.dart';
import 'package:ip_country_lookup/api/api_repo.dart';
import 'package:ip_country_lookup/ip_country_lookup.dart';

void main() {
  group('ApiRepo', () {
    test('falls back when public IP and location providers fail', () async {
      final List<Uri> requests = <Uri>[];
      final ApiRepo repository = ApiRepo(
        request: (Uri uri) async {
          requests.add(uri);
          if (uri.host == 'api64.ipify.org') {
            throw Exception('Primary IP provider is unavailable');
          }
          if (uri.host == 'icanhazip.com') {
            return 'not an ip\n';
          }
          if (uri.host == 'checkip.amazonaws.com') {
            return '203.0.113.7\n';
          }
          if (uri.host == 'ipwho.is') {
            return <String, dynamic>{
              'success': false,
              'message': 'Rate limited',
            };
          }
          if (uri.host == 'ipapi.co') {
            return <String, dynamic>{
              'ip': '203.0.113.7',
              'version': 'IPv4',
              'country_name': 'Exampleland',
              'country_code': 'EX',
              'org': 'Example ISP',
            };
          }
          throw StateError('Unexpected provider: $uri');
        },
      );

      final IpCountryData result = await repository.getIpLocationData();

      expect(result.ip, '203.0.113.7');
      expect(result.countryName, 'Exampleland');
      expect(result.countryCode, 'EX');
      expect(result.isp, 'Example ISP');
      expect(result.responseCode, '200');
      expect(requests.map((Uri uri) => uri.host), <String>[
        'api64.ipify.org',
        'icanhazip.com',
        'checkip.amazonaws.com',
        'ipwho.is',
        'ipapi.co',
      ]);
    });

    test('returns a failure value when every provider fails', () async {
      final ApiRepo repository = ApiRepo(
        request: (Uri uri) async => throw Exception('Unavailable: $uri'),
      );

      final IpCountryData result = await repository.getIpLocationData();

      expect(result.ip, '0.0.0.0');
      expect(result.countryCode, 'N/A');
      expect(result.responseCode, '503');
      expect(result.responseMessage, contains('public IP'));
    });

    test('parses the ipwho.is response shape', () async {
      final ApiRepo repository = ApiRepo(
        request: (Uri uri) async {
          if (uri.host == 'api64.ipify.org') {
            return <String, dynamic>{'ip': '2001:db8::1'};
          }
          return <String, dynamic>{
            'ip': '2001:db8::1',
            'success': true,
            'type': 'IPv6',
            'country': 'Exampleland',
            'country_code': 'EX',
            'connection': <String, dynamic>{'isp': 'Example ISP'},
          };
        },
      );

      final IpCountryData result = await repository.getIpLocationData();

      expect(result.ipVersion, '6');
      expect(result.countryName, 'Exampleland');
      expect(result.countryCode, 'EX');
      expect(result.isp, 'Example ISP');
    });
  });

  test('IpCountryData JSON round-trip preserves the country code', () {
    final IpCountryData original = IpCountryData(
      ip: '203.0.113.7',
      countryName: 'Exampleland',
      countryCode: 'EX',
    );

    final IpCountryData restored = IpCountryData.fromJson(original.toJson());

    expect(restored.ip, original.ip);
    expect(restored.countryName, original.countryName);
    expect(restored.countryCode, original.countryCode);
  });
}
