import 'package:flutter/material.dart';
import 'package:gymapp/constants/colors.dart';

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
  _ExerciseStatItemState createState() => _ExerciseStatItemState(
      weight: weight, previousWeight: previousWeight, entryDate: entryDate);
}

class _ExerciseStatItemState extends State<ExerciseStatItem> {
  final String weight;
  final String? previousWeight;
  final String entryDate;
  _ExerciseStatItemState(
      {Key? key,
      required this.weight,
      this.previousWeight,
      required this.entryDate});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 10),
        alignment: Alignment.center,
        child: ListTile(
          visualDensity: VisualDensity(vertical: 3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          tileColor: previousWeight == null
              ? Colors.white
              : double.parse(previousWeight!) < double.parse(weight)
                  ? Colors.greenAccent
                  : Colors.redAccent,
          title: Text(entryDate, style: const TextStyle(color: pbBlack)),
          trailing: Wrap(children: [
            Text(
              "$weight" "kg",
              style: const TextStyle(color: pbBlack),
            ),
            previousWeight == null
                ? const Icon(Icons.trending_neutral, color: pbBlack)
                : double.parse(previousWeight!) < double.parse(weight)
                    ? const Icon(Icons.trending_up, color: pbBlack)
                    : const Icon(Icons.trending_down, color: pbBlack)
          ]),
        ));
  }
}
