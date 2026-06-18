import '../../domain/entities/actor_details.dart';

class ActorDetailsModel extends ActorDetails {
  const ActorDetailsModel({
    required super.id,
    required super.name,
    required super.biography,
    super.profilePath,
    super.placeOfBirth,
    super.birthday,
  });

  factory ActorDetailsModel.fromJson(Map<String, dynamic> json) {
    return ActorDetailsModel(
      id: json['id'],
      name: json['name'],
      biography: json['biography'] ?? '',
      profilePath: json['profile_path'],
      placeOfBirth: json['place_of_birth'],
      birthday: json['birthday'],
    );
  }
}
