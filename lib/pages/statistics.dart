import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymapp/models/exercise.dart';
import 'package:gymapp/db/databaseHandler.dart';
import 'package:gymapp/models/gym.dart';
import 'package:gymapp/widgets/statisticItem.dart';

class Statistics extends StatefulWidget {
  const Statistics({Key? key}) : super(key: key);

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  bool isLoading = false;
  late List<Exercise> exercisesList;
  late List<Exercise> filteredExercises = exercisesList;
  late List<Gym> gymList;
  late List<String> filterOptions = [];
  late List<String> chosenFilters = [];
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

    refreshExercises();
  }

  Future refreshExercises() async {
    setState(() => isLoading = true);

    exercisesList = await AppDatabase.instance.readAllExercises();
    gymList = await AppDatabase.instance.getGyms();
    filterOptions = [];
    filterOptions.addAll(bodyParts);
    filterOptions.addAll(gymList
        .map((e) => e.gymName)
        .where((element) => element != "No Gym Added"));
    setState(() => isLoading = false);
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
        ),
        body: Container(
            child: isLoading
                ? const CircularProgressIndicator()
                : ListView(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                          bottom: 20,
                          top: 20,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Statistics",
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
                      SingleChildScrollView(
                        child: GridView.count(
                          physics: const ScrollPhysics(),
                          crossAxisCount: 2,
                          childAspectRatio: (1 / .4),
                          shrinkWrap: true,
                          children: [
                            for (Exercise exercise in filteredExercises)
                              StatisticsItem(exercise: exercise)
                          ],
                        ),
                      )
                    ],
                  )));
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
              textStyle: GoogleFonts.montserrat(
                  color: Theme.of(context).colorScheme.onBackground),
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
