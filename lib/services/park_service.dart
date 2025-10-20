import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/park.dart';

Future<List<Park>> loadParks() async {
  final data = await rootBundle.loadString('assets/parks_data.json');
  final List<dynamic> jsonResult = json.decode(data);
  return jsonResult.map((park) => Park.fromJson(park)).toList();
}
