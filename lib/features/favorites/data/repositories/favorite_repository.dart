import 'package:get_storage/get_storage.dart';
import '../../../movies/domain/entities/movie.dart';
import '../../../movies/data/models/movie_model.dart';

class FavoriteRepository {
  final _box = GetStorage();
  final String _key = 'favorite_movies'; // Yaddaşdakı açarımız

  // Yaddaşdakı filmləri oxuyur
  List<Movie> getFavorites() {
    final List<dynamic> data = _box.read(_key) ?? [];
    return data.map((json) => MovieModel.fromJson(json)).toList();
  }

  // Filmi siyahıya əlavə edir və ya ordan silir
  Future<void> toggleFavorite(Movie movie) async {
    final favorites = getFavorites();
    final isExist = favorites.any((m) => m.id == movie.id);

    if (isExist) {
      favorites.removeWhere((m) => m.id == movie.id);
    } else {
      favorites.add(movie);
    }

    // Yenilənmiş siyahını JSON formatına salıb yaddaşa yazırıq
    final List<Map<String, dynamic>> jsonData = favorites.map((m) {
      return MovieModel(
        id: m.id,
        title: m.title,
        overview: m.overview,
        posterPath: m.posterPath,
        voteAverage: m.voteAverage,
        releaseDate: m.releaseDate,
      ).toJson();
    }).toList();

    await _box.write(_key, jsonData);
  }
}