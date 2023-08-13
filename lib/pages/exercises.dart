import 'package:flutter/material.dart';
import 'package:gymapp/constants/colors.dart';
import 'package:gymapp/models/exercise.dart';
import 'package:gymapp/widgets/exerciseItem.dart';

class Exercises extends StatelessWidget {
  const Exercises({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListView(
      children: [
        Container(
          margin: EdgeInsets.only(
            bottom: 20,
            top: 50,
          ),
          child: Text("Exercises",
              style: TextStyle(
                  fontSize: 30, fontWeight: FontWeight.w500, color: pbBlack)),
        ),
        ExerciseItem(
          exercise: Exercise(
              id: "0",
              exerciseText: "Bicep Curls",
              weights: <int>[12, 12, 14, 12]),
        ),
        ExerciseItem(
          exercise: Exercise(
              id: "1",
              exerciseText: "Cabel Tricep Extensions",
              weights: <int>[12, 18, 22, 25]),
        ),
        ExerciseItem(
          exercise: Exercise(
              id: "2",
              exerciseText: "Cabel Fly's",
              weights: <int>[10, 10, 12, 14]),
        )
      ],
    ));
  }
}
