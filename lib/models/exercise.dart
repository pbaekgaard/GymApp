final String tableExercise = 'exercises';

class ExerciseFields {
  static final String id = '_id';
  static final String exerciseText = 'exerciseText';
  static final String weights = 'weights';
  static final String updateDates = 'updateDates';
}

class Exercise {
  final int? id;
  final String exerciseText;
  final List<int> weights;
  final List<String> updateDates;

  const Exercise({
    this.id,
    required this.exerciseText,
    required this.weights,
    required this.updateDates,
  });
  String get updateDatesString => updateDates.join(',');
  Map<String, Object?> toJson() => {
        ExerciseFields.id: id,
        ExerciseFields.exerciseText: exerciseText,
        ExerciseFields.weights: weights,
        ExerciseFields.updateDates: updateDatesString,
      };

  static Exercise fromJson(Map<String, Object?> json) => Exercise(
        id: json[ExerciseFields.id] as int?,
        exerciseText: json[ExerciseFields.exerciseText] as String,
        weights:
            (json['weights']! as Iterable).cast().map((e) => e as int).toList(),
        updateDates: (json[ExerciseFields.updateDates] as String).split(','),
      );

  Exercise copy({
    int? id,
    String? exerciseText,
    List<int>? weights,
    List<String>? updateDates,
  }) =>
      Exercise(
        id: id ?? this.id,
        exerciseText: exerciseText ?? this.exerciseText,
        weights: weights ?? this.weights,
        updateDates: updateDates ?? this.updateDates,
      );
}
