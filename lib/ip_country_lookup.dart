library ip_country_lookup;

import 'package:ip_country_lookup/api/api_repo.dart';
import 'package:ip_country_lookup/models/ip_country_data_model.dart';

class IpCountryLookup {
  IpCountryLookup._internal();
  static final IpCountryLookup _ipCountryLookup = IpCountryLookup._internal();
  factory IpCountryLookup() => _ipCountryLookup;

  Future<IpCountryData> getIpLocationData() async {
    return await ApiRepo().getIpLocationData();
  }

  Future<String> getUserIpAddress() async {
    return await ApiRepo().getUserIPAddress() ?? "";
  }
}
