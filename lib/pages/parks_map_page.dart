import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ParksMapPage extends StatefulWidget {
  final void Function(Map park) onParkSelected;

  const ParksMapPage({super.key, required this.onParkSelected});

  @override
  State<ParksMapPage> createState() => _ParksMapPageState();
}

class _ParksMapPageState extends State<ParksMapPage> {
  List parks = [];
  Set<Marker> _markers = {};
  Map? _selectedPark;

  @override
  void initState() {
    super.initState();
    loadParks();
  }

  Future<void> loadParks() async {
    final data = await rootBundle.loadString('assets/parks_data_with_coords.json');
    final List decoded = json.decode(data);

    final validParks = decoded.where((park) {
      final lat = park["lat"];
      final lng = park["lng"];
      return lat != null && lng != null;
    });

    final validMarkers = validParks.map((park) {
      final lat = (park["lat"] as num).toDouble();
      final lng = (park["lng"] as num).toDouble();
      final name = park["name"]?.toString() ?? "Unnamed Park";

      return Marker(
        markerId: MarkerId(name),
        position: LatLng(lat, lng),
        onTap: () {
          setState(() {
            _selectedPark = park;
          });
        },
      );
    }).toSet();

    setState(() {
      parks = decoded;
      _markers = validMarkers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Parks Map")),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(28.5, -82.0),
              zoom: 7,
            ),
            markers: _markers,
          ),
          if (_selectedPark != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () {
                  // Instead of pushing a new page, call back to parent
                  widget.onParkSelected(_selectedPark!);
                },
                child: Card(
                  margin: const EdgeInsets.all(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_selectedPark!["name"],
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text(
                          _selectedPark!["description"] ?? "No description",
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        const Text("Tap for more details →",
                            style: TextStyle(color: Colors.blue)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
