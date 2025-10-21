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

            // 🔽 Experiences dropdown
            if (experiences.isNotEmpty)
              Card(
                child: ExpansionTile(
                  leading: const Icon(Icons.nature_people),
                  title: const Text(
                    "Experiences",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  children: experiences
                      .map((e) => ListTile(title: Text(e)))
                      .toList(),
                ),
              ),

            const SizedBox(height: 10),

            // 🔽 Amenities dropdown
            if (amenities.isNotEmpty)
              Card(
                child: ExpansionTile(
                  leading: const Icon(Icons.check_circle_outline),
                  title: const Text(
                    "Amenities",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  children: amenities
                      .map((a) => ListTile(title: Text(a)))
                      .toList(),
                ),
              ),

            const SizedBox(height: 20),

            // 🔗 Visit official page
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

            const SizedBox(height: 10),

            // 📅 Book Now button
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

