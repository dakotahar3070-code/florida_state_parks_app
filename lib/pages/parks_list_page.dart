import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:url_launcher/url_launcher.dart';
import 'park_detail_page.dart';

class ParksListPage extends StatefulWidget {
  const ParksListPage({super.key});

  @override
  State<ParksListPage> createState() => _ParksListPageState();
}

class _ParksListPageState extends State<ParksListPage> {
  List parks = [];

  @override
  void initState() {
    super.initState();
    loadParks();
  }

  Future<void> loadParks() async {
    final data = await rootBundle.loadString('assets/parks_data.json');
    final List decoded = json.decode(data);
    setState(() {
      parks = decoded;
    });
  }

  Future<void> _openInMaps(String address) async {
    final query = Uri.encodeComponent(address);
    final googleMapsUrl =
        Uri.parse("https://www.google.com/maps/search/?api=1&query=$query");

    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not open maps")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Florida State Parks")),
      body: parks.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: parks.length,
              itemBuilder: (context, index) {
                final park = parks[index];
                final name = park["name"] ?? "Unnamed Park";
                final address = park["address"] ?? "";

                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ExpansionTile(
                    title: Text(name),
                    children: [
                      if (address.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () => _openInMaps(address),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.location_on,
                                    color: Colors.red),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    address,
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ParkDetailPage(park: park),
                              ),
                            );
                          },
                          child: const Text("More details →"),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
