import 'package:flutter/material.dart';
import 'package:gymapp/constants/colors.dart';
import 'package:gymapp/models/exercise.dart';
import 'package:gymapp/widgets/exerciseItem.dart';
import 'package:gymapp/db/databaseHandler.dart';
import 'package:gymapp/models/gym.dart';

class Exercises extends StatefulWidget {
  const Exercises({Key? key}) : super(key: key);

  @override
  _Exercises createState() => _Exercises();
}

class _Exercises extends State<Exercises> {
  late List<Exercise> exercisesList;
  late List<Exercise> filteredExercises = exercisesList;
  late List<Gym> gymList;
  String addExerciseGymSelection = '';
  final _exerciseNameController = TextEditingController();
  final _weightController = TextEditingController();
  bool isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fetchDB();
  }

  void searchExercises(String value) {
    List<Exercise> results;
    if (value.isEmpty) {
      results = exercisesList;
    } else {
      results = exercisesList
          .where((item) =>
              item.exerciseText!.toLowerCase().contains(value.toLowerCase()))
          .toList();
    }

    setState(() {
      filteredExercises = results;
    });
  }

  Future fetchDB() async {
    setState(() => isLoading = true);
    exercisesList = await AppDatabase.instance.readAllExercises();
    gymList = await AppDatabase.instance.getGyms();
    setState(() => isLoading = false);
  }

  Future<void> showAddExerciseDialog(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
                scrollable: true,
                content: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _exerciseNameController,
                        autofocus: true,
                        validator: (value) {
                          if (value!.isNotEmpty) {
                            if (!value.contains(RegExp(r'[a-zA-Z]'))) {
                              return "Exercise title must contain at least one alphabetical character.";
                            } else if (exercisesList
                                .map((e) => e.exerciseText)
                                .contains(value)) {
                              return "This exercise already exists";
                            } else {
                              return null;
                            }
                          } else {
                            return "Invalid Input";
                          }
                        },
                        decoration:
                            const InputDecoration(hintText: "Exercise Name"),
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
                          decoration:
                              const InputDecoration(hintText: "Weight")),
                      DropdownButton(
                        value: addExerciseGymSelection,
                        items: gymList.map((item) {
                          return DropdownMenuItem(
                            value: item.gymName,
                            child: new Text(item.gymName),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            addExerciseGymSelection = value!;
                          });
                        },
                      )
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text("Add"),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        Exercise newExercise = Exercise(
                          exerciseText: _exerciseNameController.text,
                          weights: [
                            double.parse(_weightController.text),
                          ],
                          updateDates: [
                            DateTime.now().toString().substring(0, 10),
                          ],
                          gym: addExerciseGymSelection == 'No Gym Added'
                              ? null
                              : addExerciseGymSelection,
                        );
                        await AppDatabase.instance.addExercise(newExercise);
                        exercisesList.add(newExercise);
                        _weightController.clear();
                        _exerciseNameController.clear();
                        setState(() => (exercisesList = exercisesList));
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
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  padding: const EdgeInsets.only(bottom: 72),
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      child: TextFormField(
                          onChanged: (value) => searchExercises(value),
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(0),
                              prefixIcon: Icon(
                                Icons.search,
                                color: pbBlack,
                                size: 20,
                              ),
                              prefixIconConstraints: BoxConstraints(
                                maxHeight: 20,
                                maxWidth: 25,
                              ),
                              border: InputBorder.none,
                              hintText: 'Search',
                              hintStyle: TextStyle(color: pbGrey))),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        bottom: 20,
                        top: 20,
                      ),
                      child: const Text("Exercises",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w500,
                              color: pbBlack)),
                    ),
                    if (filteredExercises.isNotEmpty)
                      for (Exercise exercise in filteredExercises)
                        ExerciseItem(
                          key: Key(exercise.id.toString()),
                          exercise: exercise,
                        )
                    else
                      const Column(children: [
                        Center(
                          child: Icon(Icons.sentiment_very_dissatisfied,
                              size: 128, color: pbGrey),
                        ),
                        Center(
                            child: Text("No exercises added.",
                                style: TextStyle(color: pbBlack))),
                      ]),
                  ],
                )),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            print(gymList);
            addExerciseGymSelection =
                gymList.isEmpty ? "No Gym Added" : gymList.first.gymName;
            await showAddExerciseDialog(context);
            setState(() {});
          },
          child: const Icon(Icons.add)),
    );
  }
}
