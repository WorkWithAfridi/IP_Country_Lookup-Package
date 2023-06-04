import 'package:dio/dio.dart';

import '../models/ip_country_data_model.dart';

class ApiRepo {
  Future<IpCountryData> getIpLocationData() async {
    final userIpAddress = await getUserIPAddress();
    if (userIpAddress == null) {
      return _returnDefaultIpData();
    }
    final response = await Dio().get('https://api.iplocation.net/?ip=$userIpAddress');
    var data = response.data;
    if (data['response_code'] == '200') {
      return IpCountryData.fromMap(data as Map<String, dynamic>);
    } else {
      return _returnDefaultIpData();
    }
  }

  IpCountryData _returnDefaultIpData() {
    return IpCountryData.fromMap({
      'ip': '000.000.000.000',
      'ip_number': '000000000000',
      'ip_version': 4,
      'country_name': 'NA',
      'country_code2': 'NA',
      'isp': 'NA',
      'response_code': '200',
      'response_message': 'IP lookup failed.'
    });
  }

  Future<String?> getUserIPAddress() async {
    try {
      final res = await Dio().get('https://icanhazip.com/');
      var data = res.data;

      /// Need to substring res, cause the ip data contains an end line.
      return data.toString().substring(0, data.toString().length - 1);
    } catch (err) {
      return null;
    }
  }
}
