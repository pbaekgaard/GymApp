// ignore_for_file: file_names, no_logic_in_create_state

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gymapp/models/exercise.dart';
import 'package:gymapp/db/databaseHandler.dart';
import 'package:gymapp/pages/exerciseStatPage.dart';

class StatisticsItem extends StatefulWidget {
  final Exercise exercise;
  const StatisticsItem({Key? key, required this.exercise}) : super(key: key);

  @override
  State<StatisticsItem> createState() => _StatisticsItem(exercise: exercise);
}

class _StatisticsItem extends State<StatisticsItem> {
  late List<Exercise> exercisesList;
  final Exercise exercise;
  _StatisticsItem({required this.exercise});

  @override
  void initState() {
    super.initState();

    refreshExercises();
  }

  Future refreshExercises() async {
    exercisesList = await AppDatabase.instance.readAllExercises();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Material(
        color: Theme.of(context).colorScheme.secondaryContainer,
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
                      child: Column(children: [
                        Text(
                          exercise.exerciseText,
                          style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.width * 0.0600,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        ),
                        if (exercise.gym != "")
                          Text(
                            exercise.gym,
                            style: TextStyle(
                              color: Color(exercise.gymColor!),
                              fontWeight: FontWeight.w700,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.0250,
                              fontFeatures: const [
                                FontFeature.superscripts(),
                              ],
                            ),
                          )
                      ])),
                ))),
      ),
    );
  }
}
