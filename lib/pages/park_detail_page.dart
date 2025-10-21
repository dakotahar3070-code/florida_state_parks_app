import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:florida_state_parks_app/model/icons.dart';

class ParkDetailPage extends StatelessWidget {
  final Map park;
  final VoidCallback? onBack;

  const ParkDetailPage({
    super.key,
    required this.park,
    this.onBack,
  });

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildIconGrid(List<String> items, Map<String, IconData> iconMap) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: items.map((item) {
        final icon = iconMap[item] ?? Icons.help_outline;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 28, color: Colors.green[700]),
            const SizedBox(height: 4),
            Text(
              item,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final experiences = park["experiences"] != null
        ? List<String>.from(park["experiences"])
        : <String>[];
    final amenities = park["amenities"] != null
        ? List<String>.from(park["amenities"])
        : <String>[];

    return Scaffold(
      appBar: AppBar(
        title: Text(park["name"] ?? "Park Details"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (onBack != null) {
              onBack!();
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header
          if (park["headline"] != null)
            Text(
              park["headline"],
              style: Theme.of(context).textTheme.titleLarge,
            ),
          if (park["description"] != null) ...[
            const SizedBox(height: 8),
            Text(
              park["description"],
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],

          const SizedBox(height: 16),

          // Quick facts card
          Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (park["hours"] != null)
                    ListTile(
                      leading: const Icon(Icons.access_time),
                      title: const Text("Hours"),
                      subtitle: Text(park["hours"]),
                    ),
                  if (park["fees"] != null)
                    ListTile(
                      leading: const Icon(Icons.attach_money),
                      title: const Text("Fees"),
                      subtitle: Text(park["fees"]),
                    ),
                  if (park["address"] != null)
                    ListTile(
                      leading: const Icon(Icons.location_on),
                      title: const Text("Address"),
                      subtitle: Text(park["address"]),
                    ),
                  if (park["contact"] != null)
                    ListTile(
                      leading: const Icon(Icons.phone),
                      title: const Text("Contact"),
                      subtitle: Text(park["contact"]),
                    ),
                ],
              ),
            ),
          ),

               // Experiences
if (experiences.isNotEmpty)
  ExpansionTile(
    title: Text("Experiences (${experiences.length})"),
    children: [
      _buildIconGrid(experiences, experienceIcons),
    ],
  ),


                  // Amenities
          if (amenities.isNotEmpty)
  ExpansionTile(
    title: Text("Amenities (${amenities.length})"),
    children: [
      _buildIconGrid(amenities, amenityIcons),
    ],
  ),


          const SizedBox(height: 24),

          // Actions
          if (park["url"] != null)
            OutlinedButton.icon(
              icon: const Icon(Icons.public),
              label: const Text("Visit Official Website"),
              onPressed: () => _launchUrl(park["url"]),
            ),
          if (park["booking_url"] != null)
            ElevatedButton.icon(
              icon: const Icon(Icons.event_available),
              label: const Text("Book Now"),
              onPressed: () => _launchUrl(park["booking_url"]),
            ),
        ],
      ),
    );
  }
}
