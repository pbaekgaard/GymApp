import 'package:flutter/material.dart';
import 'package:gymapp/constants/colors.dart';
import 'package:gymapp/models/exercise.dart';
import 'package:gymapp/widgets/exerciseItem.dart';
import 'package:gymapp/db/databaseHandler.dart';

class Exercises extends StatefulWidget {
  const Exercises({Key? key}) : super(key: key);

  @override
  _Exercises createState() => _Exercises();
}

class _Exercises extends State<Exercises> {
  late List<Exercise> exercisesList;
  final _exerciseController = TextEditingController();
  final _weightController = TextEditingController();
  bool isLoading = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    refreshExercises();
  }

  @override
  void dispose() {
    ExerciseDatabase.instance.close();

    super.dispose();
  }

  Future refreshExercises() async {
    setState(() => isLoading = true);

    this.exercisesList = await ExerciseDatabase.instance.readAllExercises();
    for (final exercise in exercisesList) {
      print('Exercise Text: ${exercise.exerciseText}');
      print('Weights: ${exercise.weights}');
      print('Update Dates: ${exercise.updateDates}');
    }
    setState(() => isLoading = false);
  }

  Future<void> showAddExerciseDialog(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
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
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        Exercise newExercise = Exercise(
                            exerciseText: _exerciseController.text,
                            weights: [
                              int.parse(_weightController.text),
                            ],
                            updateDates: [
                              DateTime.now().toString().substring(0, 10),
                            ]);
                        await ExerciseDatabase.instance
                            .addExercise(newExercise);
                        exercisesList =
                            await ExerciseDatabase.instance.readAllExercises();
                        setState(() => (exercisesList = this.exercisesList));
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
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        bottom: 20,
                        top: 50,
                      ),
                      child: Text("Exercises",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w500,
                              color: pbBlack)),
                    ),
                    if (!exercisesList.isEmpty)
                      for (Exercise exercise in exercisesList)
                        ExerciseItem(
                          exercise: exercise,
                        )
                    else
                      Column(children: [
                        Center(
                          child: Icon(Icons.sentiment_very_dissatisfied,
                              size: 128, color: pbGrey),
                        ),
                        Center(
                            child: Text("No exercises added.",
                                style: TextStyle(color: pbBlack))),
                      ])
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
