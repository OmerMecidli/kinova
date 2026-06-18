class ActorDetails {
  final int id;
  final String name;
  final String biography;
  final String? profilePath;
  final String? placeOfBirth;
  final String? birthday;

  const ActorDetails({
    required this.id,
    required this.name,
    required this.biography,
    this.profilePath,
    this.placeOfBirth,
    this.birthday,
  });
}
