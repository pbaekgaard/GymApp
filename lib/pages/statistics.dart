import 'package:flutter/material.dart';
import 'package:gymapp/models/exercise.dart';
import 'package:gymapp/db/databaseHandler.dart';
import 'package:gymapp/constants/colors.dart';
import 'package:gymapp/widgets/statisticItem.dart';

class Statistics extends StatefulWidget {
  const Statistics({Key? key}) : super(key: key);

  @override
  _StatisticsState createState() => _StatisticsState();
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

    exercisesList = await ExerciseDatabase.instance.readAllExercises();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
              ));
  }
}
