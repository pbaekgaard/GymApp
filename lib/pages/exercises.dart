// ignore_for_file: use_build_context_synchronously

import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:gymapp/constants/bodyparts.dart';
import 'package:gymapp/constants/colors.dart';
import 'package:gymapp/constants/themes.dart';
import 'package:gymapp/models/exercise.dart';
import 'package:gymapp/pages/settings.dart';
import 'package:gymapp/widgets/exerciseItem.dart';
import 'package:gymapp/db/databaseHandler.dart';
import 'package:gymapp/models/gym.dart';
import 'package:collection/collection.dart';
import 'package:provider/provider.dart';

class Exercises extends StatefulWidget {
  const Exercises({Key? key}) : super(key: key);

  @override
  State<Exercises> createState() => _Exercises();
}

class _Exercises extends State<Exercises> {
  late List<Exercise> exercisesList;
  late List<Exercise> filteredExercises = exercisesList;
  late List<Gym> gymList;
  late ThemeService themeManager;
  String addExerciseGymSelection = '';
  String? chosenBodyPart;
  final _exerciseNameController = TextEditingController();
  final _weightController = TextEditingController();
  final _repsController = TextEditingController();
  final _searchFormKey = TextEditingController();
  bool isLoading = false;
  late List<String> filterOptions = [];
  late List<String> chosenFilters = [];
  final List<String> bodyParts = bodyparts;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    themeManager = Provider.of<ThemeService>(context, listen: false);

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
  }

  deleteDismissed(int? exercise) async {
    await AppDatabase.instance.removeExercise(
        exercisesList.firstWhere((element) => element.id == exercise));
    setState(() {
      exercisesList.remove(
          exercisesList.firstWhere((element) => element.id == exercise));
    });
  }

  Future fetchDB() async {
    setState(() => isLoading = true);
    // Gym mockGym = new Gym(gymName: "gymName");
    exercisesList = await AppDatabase.instance.readAllExercises();
    // await AppDatabase.instance.addGym(mockGym);
    gymList = await AppDatabase.instance.getGyms();
    filterOptions = [];
    filterOptions.addAll(bodyParts);
    filterOptions.addAll(gymList
        .map((e) => e.gymName)
        .where((element) => element != "No Gym Added"));
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
                            } else if (exercisesList.isNotEmpty) {
                              if (exercisesList.firstWhereOrNull((element) =>
                                      element.exerciseText == value) !=
                                  null) {
                                if (exercisesList[exercisesList.indexWhere(
                                            (element) =>
                                                element.exerciseText == value)]
                                        .gym ==
                                    addExerciseGymSelection) {
                                  return "This exercise already exists for this gym!";
                                }
                              }
                            }
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                            hintText: "e.g: Chest Press",
                            hintStyle: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w400,
                                fontSize: 12),
                            labelText: "Exercise:"),
                      ),
                      DropdownButtonFormField(
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(top: 20),
                          labelText: "Bodypart: ",
                          labelStyle: TextStyle(fontSize: 20),
                          hintStyle: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w400,
                              fontSize: 12),
                        ),
                        hint: const Text("Choose a Bodypart"),
                        value: chosenBodyPart,
                        validator: (value) {
                          if (value == null) {
                            return "You need to choose a body part!";
                          } else {
                            return null;
                          }
                        },
                        items: bodyParts.map((item) {
                          return DropdownMenuItem(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            chosenBodyPart = value!;
                          });
                        },
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
                      TextFormField(
                          keyboardType: TextInputType.number,
                          controller: _repsController,
                          style: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.onBackground),
                          validator: (value) {
                            if (value!.isNotEmpty) {
                              return null;
                            } else {
                              return "Please specify how many reps";
                            }
                          },
                          decoration: const InputDecoration(
                              hintText: "How many did you do?",
                              hintStyle: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12),
                              labelText: "Reps: ")),
                      DropdownButtonFormField(
                        isExpanded: true,
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
                            gymColor: addExerciseGymSelection == 'No Gym Added'
                                ? 0
                                : gymList[gymList.indexWhere((element) =>
                                        element.gymName ==
                                        addExerciseGymSelection)]
                                    .color,
                            gym: addExerciseGymSelection,
                            reps: [int.parse(_repsController.text)],
                            bodyPart: chosenBodyPart!);
                        await AppDatabase.instance.addExercise(newExercise);
                        _weightController.clear();
                        _exerciseNameController.clear();
                        _repsController.clear();
                        chosenBodyPart = null;
                        Navigator.of(context).pop();
                      }
                    },
                  )
                ]);
          });
        }).then((e) {
      setState(() {
        _exerciseNameController.clear();
        _repsController.clear();
        _weightController.clear();
        chosenBodyPart = null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Settings()));
              await fetchDB();
              setState(() {});
            },
            icon: Icon(
              Icons.settings,
              size: 28,
              color: Theme.of(context).colorScheme.secondary,
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
                            controller: _searchFormKey,
                            onChanged: (value) => searchExercises(value),
                            style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onBackground),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(0),
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
                              hintStyle: const TextStyle(color: pbGrey),
                            ))),
                    Container(
                      margin: const EdgeInsets.only(
                        bottom: 20,
                        top: 20,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Exercises",
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground)),
                          IconButton(
                              onPressed: () async {
                                await showFilters();
                              },
                              icon: const Icon(Icons.filter_list))
                        ],
                      ),
                    ),
                    if (filteredExercises.isNotEmpty)
                      for (Exercise exercise in filteredExercises.reversed)
                        ExerciseItem(
                          key: ValueKey(exercise.id),
                          exercise: exercise,
                          dismissCallback: () => deleteDismissed(exercise.id),
                        )
                    else
                      Column(children: [
                        const Center(
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
            addExerciseGymSelection = gymList.isEmpty
                ? "No Gym Added"
                : exercisesList.isEmpty
                    ? gymList.last.gymName
                    : gymList
                        .firstWhere(
                            (gym) => gym.gymName == exercisesList.last.gym)
                        .gymName;
            await showAddExerciseDialog(context);
            await fetchDB();
            searchExercises("");
            _searchFormKey.clear();
          },
          child: const Icon(Icons.add)),
    );
  }

  Future showFilters() async {
    List<Exercise> filteredBulk = [];
    List<Exercise> filtered = [];
    await FilterListDialog.display<String>(
      context,
      themeData: FilterListThemeData(context,
          headerTheme: HeaderThemeData(
              closeIconColor: Theme.of(context).colorScheme.secondary,
              backgroundColor: Theme.of(context).colorScheme.background),
          controlButtonBarTheme: ControlButtonBarThemeData(context,
              controlButtonTheme: ControlButtonThemeData(
                  borderRadius: 20,
                  primaryButtonBackgroundColor:
                      Theme.of(context).colorScheme.secondary,
                  textStyle: TextStyle(
                      color: Theme.of(context).colorScheme.secondary)),
              backgroundColor: Theme.of(context).colorScheme.background),
          choiceChipTheme: ChoiceChipThemeData(
              textStyle:
                  TextStyle(color: Theme.of(context).colorScheme.onBackground),
              selectedShape: StadiumBorder(
                  side: BorderSide(
                      color: Theme.of(context).colorScheme.secondary,
                      width: 1)),
              shape: StadiumBorder(
                  side: BorderSide(
                      color: Theme.of(context).colorScheme.secondary,
                      width: 1)),
              selectedBackgroundColor: Theme.of(context).colorScheme.secondary,
              backgroundColor: Theme.of(context).colorScheme.background),
          backgroundColor: Theme.of(context).colorScheme.background),
      listData: filterOptions,
      selectedListData: chosenFilters,
      choiceChipLabel: (filter) => filter,
      validateSelectedItem: (list, val) => list!.contains(val),
      hideSearchField: true,
      onItemSearch: (filter, query) {
        return filter.toLowerCase().contains(query.toLowerCase());
      },
      onApplyButtonClick: (list) {
        for (final search in list!) {
          if (bodyParts.contains(search)) {
            filteredBulk.addAll(exercisesList.where((item) =>
                item.bodyPart.toLowerCase().contains(search.toLowerCase())));
          } else {
            filteredBulk.addAll(exercisesList.where((item) =>
                item.gym.toLowerCase().contains(search.toLowerCase())));
          }
        }

        for (var element in filteredBulk) {
          if (!filtered.contains(element)) filtered.add(element);
        }

        if (list.isEmpty) {
          setState(() {
            chosenFilters = [];
            filteredExercises = exercisesList;
          });
        } else {
          setState(() {
            chosenFilters = List.from(list);
            filteredExercises = List.from(filtered);
          });
        }
        Navigator.pop(context);
      },
    );
  }
}
