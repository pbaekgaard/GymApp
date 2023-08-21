const String tableGym = 'gyms';

class GymFields {
  static const String id = '_id';
  static const String gymName = 'exerciseText';
  static const String color = 'color';
}

class Gym {
  final int? id;
  final String gymName;
  final int color;

  const Gym({
    this.id,
    required this.gymName,
    required this.color,
  });

  Map<String, Object?> toJson() => {
        GymFields.id: id,
        GymFields.gymName: gymName,
        GymFields.color: color,
      };

  static Gym fromJson(Map<String, Object?> json) => Gym(
        id: json[GymFields.id] as int?,
        gymName: json[GymFields.gymName] as String,
        color: json[GymFields.color] as int,
      );

  Gym copy({
    int? id,
    String? gymName,
    int? color,
  }) =>
      Gym(
        id: id ?? this.id,
        gymName: gymName ?? this.gymName,
        color: color ?? this.color,
      );
}
