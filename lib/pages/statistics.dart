import 'package:flutter/material.dart';
import 'package:gymapp/models/exercise.dart';
import 'package:gymapp/db/databaseHandler.dart';
import 'package:gymapp/constants/colors.dart';
import 'package:gymapp/widgets/statisticItem.dart';

class Statistics extends StatefulWidget {
  const Statistics({Key? key}) : super(key: key);

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  bool isLoading = false;
  late List<Exercise> exercisesList;

  @override
  void initState() {
    super.initState();

    refreshExercises();
  }

  Future refreshExercises() async {
    setState(() => isLoading = true);

    exercisesList = await AppDatabase.instance.readAllExercises();
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
                          top: 50,
                        ),
                        child: const Text("Statistics",
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w500,
                                color: pbBlack)),
                      ),
                      SingleChildScrollView(
                        child: GridView.count(
                          physics: const ScrollPhysics(),
                          crossAxisCount: 2,
                          childAspectRatio: (1 / .4),
                          shrinkWrap: true,
                          children: [
                            for (Exercise exercise in exercisesList)
                              StatisticsItem(exercise: exercise)
                          ],
                        ),
                      )
                    ],
                  )));
  }
}
