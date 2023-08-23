// ignore_for_file: file_names, no_logic_in_create_state, use_build_context_synchronously
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gymapp/models/exercise.dart';
import 'package:gymapp/db/databaseHandler.dart';
import 'package:collection/collection.dart';
import 'package:gymapp/models/gym.dart';

class ExerciseItem extends StatefulWidget {
  final Exercise exercise;
  final Function dismissCallback;
  const ExerciseItem(
      {required Key key, required this.exercise, required this.dismissCallback})
      : super(key: key);

  @override
  State<ExerciseItem> createState() => _ExerciseItem(
      key: key!, exercise: exercise, dismissCallback: dismissCallback);
}

class _ExerciseItem extends State<ExerciseItem> {
  late List<Exercise> exercisesList;
  late List<Gym> gymList;
  final _weightController = TextEditingController();
  late TextEditingController _exerciseNameController;
  final _exerciseRepController = TextEditingController();
  bool editName = false;
  bool editBody = false;
  bool editGym = false;
  final FocusNode editNameFocusNode = FocusNode();
  final FocusNode editBodyFocusNode = FocusNode();
  final FocusNode editGymFocusNode = FocusNode();
  final Exercise exercise;
  final Key key;
  late String addExerciseGymSelection;
  final Function dismissCallback;
  String chosenBodyPart = '';
  String chosenGym = '';
  _ExerciseItem(
      {required this.key,
      required this.exercise,
      required this.dismissCallback});
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  static List<String> bodyParts = [
    "Triceps",
    "Biceps",
    "Back",
    "Chest",
    "Abs",
    "Legs"
  ];

  @override
  void initState() {
    super.initState();
    _exerciseNameController =
        TextEditingController(text: exercise.exerciseText);
    chosenBodyPart = exercise.bodyPart;
    refreshExercises();
  }

  Future refreshExercises() async {
    exercisesList = await AppDatabase.instance.readAllExercises();
    gymList = await AppDatabase.instance.getGyms();
  }

  Future<void> showUpdateExerciseDialog(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          final TextEditingController weightEditingController =
              _weightController;
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
                content: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                              keyboardType: TextInputType.number,
                              controller: _exerciseRepController,
                              autofocus: true,
                              validator: (value) {
                                if (value!.isNotEmpty) {
                                  return null;
                                } else if (_exerciseNameController.text !=
                                    exercise.exerciseText) {
                                  return null;
                                } else {
                                  return "Please specify an amount of reps!";
                                }
                              },
                              decoration:
                                  const InputDecoration(hintText: "Reps")),
                          TextFormField(
                              keyboardType: TextInputType.number,
                              controller: _weightController,
                              validator: (value) {
                                if (value!.isNotEmpty) {
                                  return null;
                                } else if (_exerciseNameController.text !=
                                    exercise.exerciseText) {
                                  return null;
                                } else {
                                  return "Please specify a weight";
                                }
                              },
                              decoration:
                                  const InputDecoration(hintText: "Weight")),
                          Row(
                            children: [
                              SizedBox(
                                width: 200,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    contentPadding:
                                        const EdgeInsets.only(top: 20),
                                    labelText: "Title: ",
                                    labelStyle: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                      fontSize: 20,
                                    ),
                                    hintStyle: const TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12),
                                  ),
                                  keyboardType: TextInputType.number,
                                  controller: _exerciseNameController,
                                  enabled: editName,
                                  focusNode: editNameFocusNode,
                                  validator: (value) {
                                    if (value!.isNotEmpty) {
                                      if (!value
                                          .contains(RegExp(r'[a-zA-Z]'))) {
                                        return "Exercise title must contain at least one alphabetical character.";
                                      } else if (exercisesList.isNotEmpty) {
                                        if (exercisesList.firstWhereOrNull(
                                                (element) =>
                                                    element.exerciseText ==
                                                    value) !=
                                            null) {
                                          if (exercisesList[exercisesList
                                                          .indexWhere((element) =>
                                                              element
                                                                  .exerciseText ==
                                                              value)]
                                                      .gym ==
                                                  exercise.exerciseText &&
                                              exercisesList[exercisesList
                                                      .indexWhere((element) =>
                                                          element
                                                              .exerciseText ==
                                                          value)] !=
                                                  exercise) {
                                            return "This exercise already exists for this gym!";
                                          }
                                        }
                                      }
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              if (editName)
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _exerciseNameController.text =
                                          exercise.exerciseText;
                                      editName = false;
                                    });
                                  },
                                  icon: const Icon(Icons.cancel),
                                )
                              else
                                IconButton(
                                    onPressed:
                                        // Enable Exercise Title form field
                                        () async {
                                      setState(() {
                                        editName = true;
                                      });
                                      await Future.delayed(
                                          const Duration(milliseconds: 115));
                                      editNameFocusNode.requestFocus();
                                    },
                                    icon: const Icon(Icons.edit))
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 200,
                                child: DropdownButtonFormField(
                                  focusNode: editBodyFocusNode,
                                  decoration: InputDecoration(
                                    contentPadding:
                                        const EdgeInsets.only(top: 20),
                                    labelText: "Bodypart: ",
                                    labelStyle: TextStyle(
                                        fontSize: 20,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground),
                                    hintStyle: const TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12),
                                  ),
                                  value: chosenBodyPart,
                                  items: bodyParts.map((item) {
                                    return DropdownMenuItem(
                                      value: item,
                                      child: Text(item),
                                    );
                                  }).toList(),
                                  onChanged: editBody
                                      ? (String? value) {
                                          // This is called when the user selects an item.
                                          setState(() {
                                            chosenBodyPart = value!;
                                          });
                                        }
                                      : null,
                                ),
                              ),
                              if (editBody)
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      chosenBodyPart = exercise.bodyPart;
                                      editBody = false;
                                    });
                                  },
                                  icon: const Icon(Icons.cancel),
                                )
                              else
                                IconButton(
                                    onPressed:
                                        // Enable Exercise Title form field
                                        () async {
                                      setState(() {
                                        editBody = true;
                                      });
                                      await Future.delayed(
                                          const Duration(milliseconds: 115));
                                      editBodyFocusNode.requestFocus();
                                    },
                                    icon: const Icon(Icons.edit))
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 200,
                                child: DropdownButtonFormField(
                                  isExpanded: true,
                                  decoration: InputDecoration(
                                    contentPadding:
                                        const EdgeInsets.only(top: 20),
                                    labelText: "Gym: ",
                                    labelStyle: TextStyle(
                                      fontSize: 20,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                    ),
                                    hintStyle: const TextStyle(
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
                                      chosenGym = value!;
                                    });
                                  },
                                ),
                              ),
                              if (editGym)
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      chosenGym = exercise.gym;
                                      editGym = false;
                                    });
                                  },
                                  icon: const Icon(Icons.cancel),
                                )
                              else
                                IconButton(
                                    onPressed:
                                        // Enable Exercise Title form field
                                        () async {
                                      setState(() {
                                        editGym = true;
                                      });
                                      await Future.delayed(
                                          const Duration(milliseconds: 115));
                                      editGymFocusNode.requestFocus();
                                    },
                                    icon: const Icon(Icons.edit))
                            ],
                          ),
                        ],
                      ),
                    )),
                actions: <Widget>[
                  TextButton(
                    child: const Text("Update"),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Exercise updatedExercise = exercise;
                        exercise.exerciseText = _exerciseNameController.text;

                        final String currentDate =
                            DateTime.now().toString().substring(0, 10);
                        if (!(exercise.updateDates.last == currentDate)) {
                          if (weightEditingController.text.isNotEmpty) {
                            exercise.weights.add(
                                double.parse(weightEditingController.text));
                          }
                          if (_exerciseRepController.text.isNotEmpty) {
                            exercise.reps
                                .add(int.parse(_exerciseRepController.text));
                          }
                          exercise.updateDates.add(currentDate);
                        } else {
                          if (_exerciseRepController.text.isNotEmpty) {
                            exercise.reps.last =
                                int.parse(_exerciseRepController.text);
                          }
                          if (weightEditingController.text.isNotEmpty) {
                            exercise.weights.last =
                                double.parse(weightEditingController.text);
                          }
                        }
                        exercisesList[exercisesList.indexWhere(
                                (element) => element.id == exercise.id)] =
                            updatedExercise;
                        AppDatabase.instance.updateExercise(updatedExercise);
                        setState(() => ());
                        Navigator.of(context).pop();
                      }
                    },
                  )
                ]);
          });
        }).then((e) {
      setState(() {
        _exerciseNameController.text = exercise.exerciseText;
        _exerciseRepController.clear();
        _weightController.clear();
        chosenBodyPart = exercise.bodyPart;
      });
      setState(() {
        editName = false;
      });
    });
  }

  Future<bool> showRemoveExerciseDialog(BuildContext context) async {
    bool remove = false;
    await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
                title: const Icon(Icons.delete, size: 32),
                contentTextStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 16),
                content: const Text(
                    "Are you sure you want to delete this exercise?"),
                actions: <Widget>[
                  TextButton(
                    child: const Text("Yes, remove it!"),
                    onPressed: () {
                      remove = true;
                      setState(() => ());
                      Navigator.of(context).pop();
                    },
                  )
                ]);
          });
        });
    return remove;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Dismissible(
          key: key,
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.endToStart) {
              addExerciseGymSelection = gymList.isEmpty
                  ? "No Gym Added"
                  : gymList
                      .firstWhere(
                          (gym) => gym.gymName == exercisesList.last.gym)
                      .gymName;
              await showUpdateExerciseDialog(context);
              setState(() => {});
              return false;
            } else {
              bool delete = false;
              delete = await showRemoveExerciseDialog(context);
              if (delete) {
                final snackbarController =
                    ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Deleted ${exercise.exerciseText}'),
                    action: SnackBarAction(
                        label: 'Undo', onPressed: () => delete = false),
                    duration: const Duration(seconds: 1),
                  ),
                );
                await snackbarController.closed;
                if (delete) {
                  await AppDatabase.instance.removeExercise(exercise);
                  dismissCallback();
                }
              }
              setState(() => {});
              return delete;
            }
          },
          background: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Theme.of(context).colorScheme.secondary,
            ),
            child: const Row(children: [
              Icon(Icons.delete, color: Colors.white),
              Text(
                "Remove",
                style: TextStyle(color: Colors.white),
              )
            ]),
          ),
          secondaryBackground: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.tertiary,
                borderRadius: BorderRadius.circular(15)),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Edit ",
                  style: TextStyle(color: Colors.white),
                ),
                Icon(Icons.edit, color: Colors.white)
              ],
            ),
          ),
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            tileColor: Theme.of(context).colorScheme.primaryContainer,
            title: Wrap(children: [
              Text(exercise.exerciseText,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground)),
              if (exercise.gym != "")
                Text(
                  exercise.gym,
                  style: TextStyle(
                    color: Color(exercise.gymColor!),
                    fontWeight: FontWeight.w500,
                    fontSize: 10,
                    fontFeatures: const [
                      FontFeature.superscripts(),
                    ],
                  ),
                )
            ]),
            trailing: Wrap(children: [
              Text(
                  "${exercise.reps.last}x${exercise.weights.last.truncateToDouble() == exercise.weights.last ? exercise.weights.last.toStringAsFixed(0) : num.parse(exercise.weights.last.toString())}kg",
                  style: TextStyle(
                      color: exercise.weights.length > 1
                          ? (exercise.weights.last >
                                  exercise.weights[exercise.weights.length - 2]
                              ? Colors.green
                              : exercise.weights.last ==
                                      exercise
                                          .weights[exercise.weights.length - 2]
                                  ? Theme.of(context).colorScheme.onBackground
                                  : Theme.of(context).colorScheme.secondary)
                          : Theme.of(context).colorScheme.onBackground)),
              exercise.weights.length > 1
                  ? (exercise.weights.last >
                          exercise.weights[exercise.weights.length - 2]
                      ? const Icon(Icons.trending_up,
                          size: 20, color: Colors.green)
                      : exercise.weights.last ==
                              exercise.weights[exercise.weights.length - 2]
                          ? Icon(Icons.trending_neutral,
                              size: 20,
                              color: Theme.of(context).colorScheme.onBackground)
                          : Icon(Icons.trending_down,
                              size: 20,
                              color: Theme.of(context).colorScheme.secondary))
                  : Icon(Icons.trending_neutral,
                      size: 20,
                      color: Theme.of(context).colorScheme.onBackground)
            ]),
          )),
    );
  }
}
