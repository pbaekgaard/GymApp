// ignore_for_file: file_names, no_logic_in_create_state

import 'package:flutter/material.dart';

class ExerciseStatItem extends StatefulWidget {
  final String weight;
  final String? previousWeight;
  final String entryDate;
  const ExerciseStatItem(
      {Key? key,
      required this.weight,
      this.previousWeight,
      required this.entryDate})
      : super(key: key);

  @override
  State<ExerciseStatItem> createState() => _ExerciseStatItemState(
      weight: weight, previousWeight: previousWeight, entryDate: entryDate);
}

class _ExerciseStatItemState extends State<ExerciseStatItem> {
  final String weight;
  final String? previousWeight;
  final String entryDate;
  _ExerciseStatItemState(
      {required this.weight, this.previousWeight, required this.entryDate});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 10),
        alignment: Alignment.center,
        child: ListTile(
          visualDensity: const VisualDensity(vertical: 3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          tileColor: previousWeight == null
              ? Theme.of(context).colorScheme.secondaryContainer
              : double.parse(previousWeight!) < double.parse(weight)
                  ? Theme.of(context).colorScheme.tertiary
                  : Theme.of(context).colorScheme.primary,
          title: Text(entryDate,
              style:
                  TextStyle(color: Theme.of(context).colorScheme.onBackground)),
          trailing: Wrap(children: [
            Text(
              "$weight" "kg",
              style:
                  TextStyle(color: Theme.of(context).colorScheme.onBackground),
            ),
            previousWeight == null
                ? Icon(Icons.trending_neutral,
                    color: Theme.of(context).colorScheme.onBackground)
                : double.parse(previousWeight!) < double.parse(weight)
                    ? Icon(Icons.trending_up,
                        color: Theme.of(context).colorScheme.onBackground)
                    : Icon(Icons.trending_down,
                        color: Theme.of(context).colorScheme.onBackground)
          ]),
        ));
  }
}
