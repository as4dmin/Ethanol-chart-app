import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

final dataProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final response = await http.get(Uri.parse(
    'https://api.data.gov.in/resource/fcfb05ab-16f6-424a-92b6-d9dc50215d14?api-key=579b464db66ec23bdd0000019b843fd240f6466458b357004c92ab92&format=json',
  ));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final records = data['records'] as List;
    return records.cast<Map<String, dynamic>>();
  } else {
    throw Exception('Failed to load data');
  }
});
