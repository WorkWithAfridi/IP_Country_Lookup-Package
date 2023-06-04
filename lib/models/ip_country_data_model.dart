import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class IpCountryData {
  String? ip;
  String? ip_number;
  String? ip_version;
  String? country_name;
  String? country_code;
  String? isp;
  String? response_code;
  String? response_message;
  IpCountryData({
    this.ip,
    this.ip_number,
    this.ip_version,
    this.country_name,
    this.country_code,
    this.isp,
    this.response_code,
    this.response_message,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'ip': ip,
      'ip_number': ip_number,
      'ip_version': ip_version,
      'country_name': country_name,
      'country_code': country_code,
      'isp': isp,
      'response_code': response_code,
      'response_message': response_message,
    };
  }

  factory IpCountryData.fromMap(Map<String, dynamic> map) {
    return IpCountryData(
      ip: map['ip'] != null ? map['ip'].toString() : null,
      ip_number: map['ip_number'] != null ? map['ip_number'].toString() : null,
      ip_version: map['ip_version'] != null ? map['ip_version'].toString() : null,
      country_name: map['country_name'] != null ? map['country_name'].toString() : null,
      country_code: map['country_code2'] != null ? map['country_code2'].toString() : null,
      isp: map['isp'] != null ? map['isp'].toString() : null,
      response_code: map['response_code'] != null ? map['response_code'].toString() : null,
      response_message: map['response_message'] != null ? map['response_message'].toString() : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory IpCountryData.fromJson(String source) => IpCountryData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'IpCountryData(ip: $ip, ip_number: $ip_number, ip_version: $ip_version, country_name: $country_name, country_code: $country_code, isp: $isp, response_code: $response_code, response_message: $response_message)';
  }
}
