class Exercise {
  final int id;
  final String exerciseText;
  final List<int> weights;
  Exercise(
      {required this.id, required this.exerciseText, required this.weights});

  static List<Exercise> exerciseList() {
    return [
      Exercise(id: 0, exerciseText: "Bicep Curls", weights: [12, 14, 14, 16]),
      Exercise(id: 1, exerciseText: "Chest Flys", weights: [12, 12, 14, 17]),
      Exercise(id: 2, exerciseText: "Lateral Raise", weights: [8, 10, 10, 12])
    ];
  }
}
