import 'package:flutter/material.dart';
import 'package:gymapp/constants/colors.dart';
import 'package:gymapp/models/exercise.dart';
import 'package:gymapp/widgets/exerciseItem.dart';

class Exercises extends StatefulWidget {
  const Exercises({Key? key}) : super(key: key);

  @override
  _Exercises createState() => _Exercises();
}

class _Exercises extends State<Exercises> {
  var exercisesList = Exercise.exerciseList();
  final _exerciseController = TextEditingController();
  final _weightController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> showAddExerciseDialog(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          final TextEditingController _textEditingController =
              _exerciseController;
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
                        controller: _exerciseController,
                        validator: (value) {
                          if (value!.isNotEmpty) {
                            if (exercisesList
                                .map((e) => e.exerciseText)
                                .contains(value)) {
                              return "This exercise already exists";
                            } else {
                              return null;
                            }
                          } else
                            return "Invalid Input";
                        },
                        decoration: InputDecoration(hintText: "Exercise Name"),
                      ),
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
                    child: Text("Add"),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Exercise newExercise = Exercise(
                            id: exercisesList.last.id + 1,
                            exerciseText: _exerciseController.text,
                            weights: [
                              int.parse(_weightController.text),
                            ]);
                        exercisesList.add(newExercise);
                        setState(() => ());
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
    return Scaffold(
      backgroundColor: pbBG,
      body: Container(
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
          for (Exercise exercise in exercisesList)
            ExerciseItem(
              exercise: exercise,
            )
        ],
      )),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await showAddExerciseDialog(context);
            setState(() {});
          },
          child: Icon(Icons.add)),
    );
  }
}
