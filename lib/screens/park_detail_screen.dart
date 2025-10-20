import 'package:flutter/material.dart';
import '../models/park.dart';
import '../services/park_service.dart';
import 'park_detail_screen.dart';

class ParkListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Florida State Parks")),
      body: FutureBuilder<List<Park>>(
        future: loadParks(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          final parks = snapshot.data!;
          return ListView.builder(
            itemCount: parks.length,
            itemBuilder: (context, index) {
              final park = parks[index];
              return ListTile(
                title: Text(park.name),
                subtitle: Text(park.description),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ParkDetailScreen(park: park),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
