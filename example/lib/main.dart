import 'package:flutter/material.dart';
import 'package:ip_country_lookup/ip_country_lookup.dart';

void main() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("IP Country Lookup")),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  isDataLoaded
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 44),
                          child: Column(
                            children: [
                              Text('Country name: ${countryData!.countryName}'),
                              Text('Country code: ${countryData!.countryCode}'),
                              const SizedBox(height: 30),
                              const Divider(),
                              const SizedBox(height: 30),
                              Text('User public IP: ${countryData!.ip}'),
                              Text('User ISP: ${countryData!.isp}'),
                              const SizedBox(height: 30),
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
                  ElevatedButton(
                    onPressed: isLoading ? null : _loadCountryData,
                    child: const Text("Get country data from IP"),
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> _loadCountryData() async {
    setState(() => isLoading = true);

    final IpCountryData result = await IpCountryLookup().getIpLocationData();
    if (!mounted) {
      return;
    }

    setState(() {
      countryData = result;
      isLoading = false;
      isDataLoaded = true;
    });
  }
}
