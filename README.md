# Ip_Country_Lookup
A Flutter package for retrieving country information based on a user's public IP address.

## Features
Get the user's public IP address.
Retrieve country information such as country code, country name, and ISP (Internet Service Provider).
Usage

## In App Screenshots
<p align="center">
<img src="https://github.com/WorkWithAfridi/IP_Country_Lookup-Package/blob/master/example/assets/promotional_images/img1.png" width="360" height="665">
<img src="https://github.com/WorkWithAfridi/IP_Country_Lookup-Package/blob/master/example/assets/promotional_images/img2.png" width="360" height="665">
</p>

## Getting started
To use this package, follow the steps below:

Add the package to your pubspec.yaml file:
````md

dependencies:
  ip_country_lookup: ^1.0.0

````

Import the package in your Dart file:
````md

import 'package:ip_country_lookup/ip_country_lookup.dart';

````

Get the user's public IP address:
````md

String publicIp = await IpCountryLookup().getUserIpAddress();

````

Retrieve country information using the user's IP address:
````md

IpCountryData countryData = await IpCountryLookup().getIpLocationData();

````

Note: Ensure that you have the necessary permissions and internet connectivity to retrieve the user's IP address and access the country information.

## Example
````md

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

````

## Support
For any issues, questions, or feature requests, please email me at: afridi.khondakar@gmail.com.

## Conclusion
The ip_country_lookup package allows you to easily retrieve a user's public IP address and obtain country information such as the country code, country name, and ISP. It simplifies the process of identifying the user's location based on their IP address, enabling you to build geolocation-aware applications with ease.