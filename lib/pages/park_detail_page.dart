import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ParkDetailPage extends StatelessWidget {
  final Map park;
  const ParkDetailPage({super.key, required this.park});

  @override
  Widget build(BuildContext context) {
    final experiences = List<String>.from(park["experiences"] ?? []);
    final amenities = List<String>.from(park["amenities"] ?? []);

    return Scaffold(
      appBar: AppBar(title: Text(park["name"] ?? "Park")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            if (park["description"] != null)
              SelectableText(
                park["description"],
                style: const TextStyle(fontSize: 16),
              ),
            const SizedBox(height: 20),

            if (experiences.isNotEmpty)
              Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text("Experiences",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    ...experiences.map((e) => ListTile(
                          leading: const Icon(Icons.nature_people),
                          title: Text(e),
                        )),
                  ],
                ),
              ),

            const SizedBox(height: 20),

            if (amenities.isNotEmpty)
              Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text("Amenities",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    ...amenities.map((a) => ListTile(
                          leading: const Icon(Icons.check_circle_outline),
                          title: Text(a),
                        )),
                  ],
                ),
              ),

            const SizedBox(height: 20),

            if (park["url"] != null)
              ElevatedButton.icon(
                onPressed: () async {
                  final url = park["url"];
                  if (await canLaunchUrl(Uri.parse(url))) {
                    await launchUrl(Uri.parse(url));
                  }
                },
                icon: const Icon(Icons.open_in_browser),
                label: const Text("Visit Official Page"),
              ),

              const SizedBox(height: 20),

if (park["booking_url"] != null)
  ElevatedButton.icon(
    onPressed: () async {
      final bookingUrl = park["booking_url"];
      final uri = Uri.tryParse(bookingUrl);
      if (uri != null && await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.inAppWebView);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Could not open booking link")),
        );
      }
    },
    icon: const Icon(Icons.calendar_today),
    label: const Text("Book Now"),
  ),
          ],
        ),
      ),
    );
  }
}
