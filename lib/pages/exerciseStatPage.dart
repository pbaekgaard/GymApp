// ignore_for_file: file_names, no_logic_in_create_state

import 'package:flutter/material.dart';

import 'package:gymapp/models/exercise.dart';

import 'package:gymapp/widgets/exerciseStatItem.dart';

class ExerciseStatPage extends StatefulWidget {
  final Exercise exercise;
  const ExerciseStatPage({Key? key, required this.exercise}) : super(key: key);

  @override
  State<ExerciseStatPage> createState() =>
      _ExerciseStatPageState(exercise: exercise);
}

class _ExerciseStatPageState extends State<ExerciseStatPage> {
  final Exercise exercise;
  _ExerciseStatPageState({required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
            elevation: 0,
            iconTheme:
                IconThemeData(color: Theme.of(context).colorScheme.secondary),
            // TRY THIS: Try changing the color here to a specific color (to
            // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
            // change color while the other colors stay the same.
            backgroundColor: Theme.of(context).colorScheme.background,
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            centerTitle: true,
            title: Text(exercise.exerciseText,
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary))),
        body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              children: [
                for (final entry in exercise.updateDates.reversed)
                  ExerciseStatItem(
                      reps: exercise.reps.last,
                      weight: exercise.weights[exercise.updateDates
                          .indexWhere((element) => element == entry)],
                      entryDate: entry,
                      previousWeight: exercise.updateDates
                                  .indexWhere((element) => element == entry) >=
                              1
                          ? exercise.weights[exercise.updateDates.indexWhere(
                                      (element) => element == entry) -
                                  1]
                              .toString()
                          : null)
              ],
            )));
    // This trailing comma makes auto-formatting nicer for build methods.
  }
}
