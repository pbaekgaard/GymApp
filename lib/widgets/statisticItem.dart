import 'package:flutter/material.dart';
import 'package:gymapp/constants/colors.dart';
import 'package:gymapp/models/exercise.dart';
import 'package:gymapp/db/databaseHandler.dart';
import 'package:gymapp/pages/exerciseStatPage.dart';

class StatisticsItem extends StatefulWidget {
  final Exercise exercise;
  const StatisticsItem({Key? key, required this.exercise}) : super(key: key);

  @override
  _StatisticsItem createState() => _StatisticsItem(exercise: exercise);
}

class _StatisticsItem extends State<StatisticsItem> {
  late List<Exercise> exercisesList;
  final Exercise exercise;
  _StatisticsItem({Key? key, required this.exercise});

  @override
  void initState() {
    super.initState();

    refreshExercises();
  }

  Future refreshExercises() async {
    exercisesList = await ExerciseDatabase.instance.readAllExercises();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Material(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ExerciseStatPage(exercise: exercise)));
            },
            child: Container(
                margin: const EdgeInsets.all(10),
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Text(exercise.exerciseText,
                        style: const TextStyle(fontSize: 20, color: pbBlack)),
                  ),
                ))),
      ),
    );
  }
}
