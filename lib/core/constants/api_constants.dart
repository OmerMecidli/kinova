import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/w500'; 
  
  // Dəyəri .env faylından oxuyuruq (əgər tapılmazsa boş string qaytarır)
  static String get apiKey => dotenv.env['TMDB_KEY'] ?? ''; 
}