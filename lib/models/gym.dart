const String tableGym = 'gyms';

class GymFields {
  static const String id = '_id';
  static const String gymName = 'exerciseText';
}

class Gym {
  final int? id;
  final String gymName;

  const Gym({
    this.id,
    required this.gymName,
  });

  Map<String, Object?> toJson() => {
        GymFields.id: id,
        GymFields.gymName: gymName,
      };

  static Gym fromJson(Map<String, Object?> json) => Gym(
        id: json[GymFields.id] as int?,
        gymName: json[GymFields.gymName] as String,
      );

  Gym copy({
    int? id,
    String? gymName,
  }) =>
      Gym(
        id: id ?? this.id,
        gymName: gymName ?? this.gymName,
      );
}
