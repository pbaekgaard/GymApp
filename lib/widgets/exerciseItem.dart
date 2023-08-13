import 'package:flutter/material.dart';
import 'package:gymapp/constants/colors.dart';
import 'package:gymapp/models/exercise.dart';

class ExerciseItem extends StatelessWidget {
  final Exercise exercise;
  const ExerciseItem({Key? key, required this.exercise}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 10),
        child: ListTile(
          onTap: () {},
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          tileColor: Colors.white,
          title: Text(exercise.exerciseText, style: TextStyle(color: pbBlack)),
          trailing: Wrap(children: [
            Text(exercise.weights.last.toString() + "kg",
                style: TextStyle(
                    color: exercise.weights.last >
                            exercise.weights[exercise.weights.length - 2]
                        ? Colors.green
                        : pbRed)),
            exercise.weights.last >
                    exercise.weights[exercise.weights.length - 2]
                ? Icon(Icons.trending_up, size: 20, color: Colors.green)
                : Icon(Icons.trending_down, size: 20, color: pbRed)
          ]),
        ));
  }
}
