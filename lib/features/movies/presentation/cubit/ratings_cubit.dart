import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:get_storage/get_storage.dart';

class RatingsState {
  final Map<int, double> ratings;
  RatingsState(this.ratings);
}

@injectable
class RatingsCubit extends Cubit<RatingsState> {
  final _storage = GetStorage();
  static const _ratingsKey = 'movie_ratings';

  RatingsCubit() : super(RatingsState({})) {
    loadRatings();
  }

  void loadRatings() {
    final Map<String, dynamic> savedRatings = _storage.read(_ratingsKey) ?? {};
    final parsedRatings = savedRatings.map((key, value) => MapEntry(int.parse(key), (value as num).toDouble()));
    emit(RatingsState(parsedRatings));
  }

  void rateMovie(int movieId, double rating) {
    final newRatings = Map<int, double>.from(state.ratings);
    newRatings[movieId] = rating;
    
    // Save to storage
    final stringKeyMap = newRatings.map((key, value) => MapEntry(key.toString(), value));
    _storage.write(_ratingsKey, stringKeyMap);
    
    emit(RatingsState(newRatings));
  }

  double? getRating(int movieId) {
    return state.ratings[movieId];
  }
}
