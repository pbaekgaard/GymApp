import 'package:flutter/material.dart';
import 'package:gymapp/constants/colors.dart';
import 'package:gymapp/models/exercise.dart';
import 'package:gymapp/pages/settings.dart';
import 'package:gymapp/widgets/exerciseItem.dart';
import 'package:gymapp/db/databaseHandler.dart';
import 'package:gymapp/models/gym.dart';

class Exercises extends StatefulWidget {
  const Exercises({Key? key}) : super(key: key);

  @override
  State<Exercises> createState() => _Exercises();
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
              item.exerciseText.toLowerCase().contains(value.toLowerCase()))
          .toList();
    }

    setState(() {
      filteredExercises = results;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchDB();
  }

  Future fetchDB() async {
    setState(() => isLoading = true);
    // Gym mockGym = new Gym(gymName: "gymName");
    exercisesList = await AppDatabase.instance.readAllExercises();
    // await AppDatabase.instance.addGym(mockGym);
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
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground),
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
                        decoration: const InputDecoration(
                            hintText: "e.g: Chest Press",
                            hintStyle: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w400,
                                fontSize: 12),
                            labelText: "Exercise:"),
                      ),
                      TextFormField(
                          keyboardType: TextInputType.number,
                          controller: _weightController,
                          style: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.onBackground),
                          validator: (value) {
                            if (value!.isNotEmpty) {
                              return null;
                            } else {
                              return "Please specify a weight";
                            }
                          },
                          decoration: const InputDecoration(
                              hintText: "How did you do?",
                              hintStyle: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12),
                              labelText: "Weight: ")),
                      DropdownButtonFormField(
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(top: 20),
                          labelText: "Gym: ",
                          labelStyle: TextStyle(fontSize: 20),
                          hintStyle: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w400,
                              fontSize: 12),
                        ),
                        value: addExerciseGymSelection,
                        disabledHint: const Text(
                          "No Gym's Available",
                          style: TextStyle(fontSize: 14),
                        ),
                        items: gymList.map((item) {
                          return DropdownMenuItem(
                            value: item.gymName,
                            child: Text(item.gymName),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            addExerciseGymSelection = value!;
                          });
                        },
                      ),
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
                              ? ""
                              : addExerciseGymSelection,
                        );
                        await AppDatabase.instance.addExercise(newExercise);
                        exercisesList.add(newExercise);
                        _weightController.clear();
                        _exerciseNameController.clear();
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
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        elevation: 0,
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.background,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        centerTitle: true,
        title: Text("Overload",
            style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Settings()));
              await fetchDB();
              setState(() {});
            },
            icon: Icon(
              Icons.settings,
              size: 28,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
        ],
      ),
      body: Container(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  padding: const EdgeInsets.only(bottom: 72),
                  children: [
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .secondaryContainer,
                            borderRadius: BorderRadius.circular(15)),
                        child: TextFormField(
                            onChanged: (value) => searchExercises(value),
                            style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onBackground),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(0),
                              prefixIcon: Icon(
                                Icons.search,
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                                size: 20,
                              ),
                              prefixIconConstraints: const BoxConstraints(
                                maxHeight: 20,
                                maxWidth: 25,
                              ),
                              border: InputBorder.none,
                              hintText: 'Search',
                              hintStyle: TextStyle(color: pbGrey),
                            ))),
                    Container(
                      margin: const EdgeInsets.only(
                        bottom: 20,
                        top: 20,
                      ),
                      child: Text("Exercises",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w500,
                              color:
                                  Theme.of(context).colorScheme.onBackground)),
                    ),
                    if (filteredExercises.isNotEmpty)
                      for (Exercise exercise in filteredExercises)
                        ExerciseItem(
                          key: Key(exercise.id.toString()),
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
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground))),
                      ]),
                  ],
                )),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            addExerciseGymSelection =
                gymList.isEmpty ? "No Gym Added" : gymList.first.gymName;
            await showAddExerciseDialog(context);
            setState(() {});
          },
          child: const Icon(Icons.add)),
    );
  }
}
