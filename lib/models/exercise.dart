const String tableExercise = 'exercises';

class ExerciseFields {
  static const String id = '_id';
  static const String exerciseText = 'exerciseText';
  static const String weights = 'weights';
  static const String updateDates = 'updateDates';
  static const String gym = 'gym';
  static const String gymColor = 'gymColor';
}

class Exercise {
  final int? id;
  final String exerciseText;
  final List<double> weights;
  final List<String> updateDates;
  final String? gym;
  final int? gymColor;

  const Exercise(
      {this.id,
      required this.exerciseText,
      required this.weights,
      required this.updateDates,
      this.gym,
      this.gymColor});
  String get updateDatesString => updateDates.join(',');
  Map<String, Object?> toJson() => {
        ExerciseFields.id: id,
        ExerciseFields.exerciseText: exerciseText,
        ExerciseFields.weights: weights.join(','),
        ExerciseFields.updateDates: updateDatesString,
        ExerciseFields.gym: gym,
        ExerciseFields.gymColor: gymColor
      };

  static Exercise fromJson(Map<String, Object?> json) => Exercise(
      id: json[ExerciseFields.id] as int?,
      exerciseText: json[ExerciseFields.exerciseText] as String,
      weights: (json['weights'] as String)
          .split(',')
          .map((weightStr) => double.parse(weightStr))
          .toList(),
      updateDates: (json[ExerciseFields.updateDates] as String).split(','),
      gym: json[ExerciseFields.gym] as String?,
      gymColor: json[ExerciseFields.gymColor] as int?);

  Exercise copy({
    int? id,
    String? exerciseText,
    List<double>? weights,
    List<String>? updateDates,
    String? gym,
    int? gymColor,
  }) =>
      Exercise(
        id: id ?? this.id,
        exerciseText: exerciseText ?? this.exerciseText,
        weights: weights ?? this.weights,
        updateDates: updateDates ?? this.updateDates,
        gym: gym ?? this.gym,
        gymColor: gymColor ?? this.gymColor,
      );
}
