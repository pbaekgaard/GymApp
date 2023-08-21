const String tableExercise = 'exercises';

class ExerciseFields {
  static const String id = '_id';
  static const String exerciseText = 'exerciseText';
  static const String weights = 'weights';
  static const String updateDates = 'updateDates';
  static const String gym = 'gym';
  static const String gymColor = 'gymColor';
  static const String bodyPart = 'bodyPart';
  static const String reps = 'reps';
}

class Exercise {
  final int? id;
  final String exerciseText;
  final List<double> weights;
  final List<int> reps;
  final List<String> updateDates;
  final String? gym;
  final String bodyPart;
  final int? gymColor;

  const Exercise(
      {this.id,
      required this.exerciseText,
      required this.weights,
      required this.updateDates,
      required this.reps,
      required this.bodyPart,
      this.gym,
      this.gymColor});
  String get updateDatesString => updateDates.join(',');
  Map<String, Object?> toJson() => {
        ExerciseFields.id: id,
        ExerciseFields.exerciseText: exerciseText,
        ExerciseFields.weights: weights.join(','),
        ExerciseFields.updateDates: updateDatesString,
        ExerciseFields.gym: gym,
        ExerciseFields.gymColor: gymColor,
        ExerciseFields.bodyPart: bodyPart,
        ExerciseFields.reps: reps.join(',')
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
      reps: (json['reps'] as String)
          .split(',')
          .map((repsString) => int.parse(repsString))
          .toList(),
      bodyPart: json[ExerciseFields.bodyPart] as String,
      gymColor: json[ExerciseFields.gymColor] as int?);

  Exercise copy({
    int? id,
    String? exerciseText,
    List<double>? weights,
    List<String>? updateDates,
    String? gym,
    int? gymColor,
    String? bodyPart,
    List<int>? reps,
  }) =>
      Exercise(
          id: id ?? this.id,
          exerciseText: exerciseText ?? this.exerciseText,
          weights: weights ?? this.weights,
          updateDates: updateDates ?? this.updateDates,
          gym: gym ?? this.gym,
          gymColor: gymColor ?? this.gymColor,
          reps: reps ?? this.reps,
          bodyPart: bodyPart ?? this.bodyPart);
}
