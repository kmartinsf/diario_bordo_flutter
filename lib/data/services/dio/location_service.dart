import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LocationService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://wft-geo-db.p.rapidapi.com/v1/geo/',
      headers: {
        'X-RapidAPI-Key': dotenv.env['GEODB_API_KEY'],
        'X-RapidAPI-Host': 'wft-geo-db.p.rapidapi.com',
      },
    ),
  );

  Future<List<String>> searchCities(String query) async {
    try {
      final response = await _dio.get(
        'cities',
        queryParameters: {
          'namePrefix': query,
          'limit': 5,
          'sort': '-population',
        },
      );

      final List<dynamic> cities = response.data['data'];
      return cities
          .map((city) => "${city['city']}, ${city['country']}")
          .cast<String>()
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar cidades: $e');
    }
  }
}
