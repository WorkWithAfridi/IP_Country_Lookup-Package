import 'package:flutter/material.dart';
import 'package:ip_country_lookup/ip_country_lookup.dart';
import 'package:ip_country_lookup/models/ip_country_data_model.dart';

void main(List<String> args) {
  runApp(const IpCountryLookupExampleApp());
}

class IpCountryLookupExampleApp extends StatelessWidget {
  const IpCountryLookupExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool isDataLoaded = false;
  bool isLoading = false;
  IpCountryData? countryData;
  String? usersPublicIpAddress;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "IP Country Lookup",
        ),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  isDataLoaded
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 44),
                          child: Column(
                            children: [
                              Text(
                                "Country name: ${countryData!.country_name.toString()}",
                              ),
                              Text(
                                "Country code: ${countryData!.country_code.toString()}",
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              const Divider(),
                              const SizedBox(
                                height: 30,
                              ),
                              Text(
                                "Users public ip: ${countryData!.ip.toString()}",
                              ),
                              Text(
                                "Users ISP: ${countryData!.isp.toString()}",
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      countryData = await IpCountryLookup().getIpLocationData();
                      setState(() {
                        isLoading = false;
                        isDataLoaded = true;
                      });
                    },
                    child: const Text(
                      "Get country data from IP",
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
