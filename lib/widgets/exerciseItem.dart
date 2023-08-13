import 'package:flutter/material.dart';
import 'package:gymapp/constants/colors.dart';
import 'package:gymapp/constants/databaseHandler.dart';
import 'package:gymapp/models/exercise.dart';

class ExerciseItem extends StatefulWidget {
  final Exercise exercise;
  const ExerciseItem({Key? key, required this.exercise}) : super(key: key);

  @override
  _ExerciseItem createState() => _ExerciseItem(exercise: exercise);
}

class _ExerciseItem extends State<ExerciseItem> {
  late DatabaseHandler dbHandler;
  var exercisesList = Exercise.exerciseList();
  final _weightController = TextEditingController();
  final Exercise exercise;
  _ExerciseItem({Key? key, required this.exercise});
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> showAddExerciseDialog(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          final TextEditingController _weightEditingController =
              _weightController;
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
                content: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                          keyboardType: TextInputType.number,
                          controller: _weightController,
                          validator: (value) {
                            if (value!.isNotEmpty) {
                              return null;
                            } else {
                              return "Please specify a weight";
                            }
                          },
                          decoration: InputDecoration(hintText: "Weight")),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text("Update"),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Exercise updatedExercise = exercise;
                        exercise.weights
                            .add(int.parse(_weightEditingController.text));
                        exercisesList[exercisesList.indexWhere(
                                (element) => element.id == exercise.id)] =
                            updatedExercise;
                        Navigator.of(context).pop();
                      }
                    },
                  )
                ]);
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 10),
        child: ListTile(
          onTap: () async {
            await showAddExerciseDialog(context);
            setState(() {});
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          tileColor: Colors.white,
          title: Text(exercise.exerciseText, style: TextStyle(color: pbBlack)),
          trailing: Wrap(children: [
            Text(exercise.weights.last.toString() + "kg",
                style: TextStyle(
                    color: exercise.weights.length > 1
                        ? (exercise.weights.last >
                                exercise.weights[exercise.weights.length - 2]
                            ? Colors.green
                            : pbRed)
                        : pbBlack)),
            exercise.weights.length > 1
                ? (exercise.weights.last >
                        exercise.weights[exercise.weights.length - 2]
                    ? Icon(Icons.trending_up, size: 20, color: Colors.green)
                    : Icon(Icons.trending_down, size: 20, color: pbRed))
                : Icon(Icons.trending_neutral, size: 20, color: pbBlack)
          ]),
        ));
  }
}
