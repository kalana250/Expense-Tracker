import 'package:expence_master/models/expence.dart';
import 'package:expence_master/widgets/expence_tile.dart';
import 'package:flutter/material.dart';

class ExpenceList extends StatelessWidget {
  final void Function(ExpenceModel expence) onDeleteExpence;
  const ExpenceList({super.key, required this.expenceList, required this.onDeleteExpence});
  
  //constroctor
  final List<ExpenceModel> expenceList;

  @override
  Widget build(BuildContext context) {
    return Expanded(
            child: ListView.builder(
              itemCount: expenceList.length,
              itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 5
                ),
                child: Dismissible(
                  key: ValueKey(expenceList[index]),
                  direction: DismissDirection.startToEnd,
                  onDismissed: (direction) {
                    onDeleteExpence(expenceList[index]);
                  },
                  child: ExpenceTile(
                    expence: expenceList[index],
                  ),
                ),
              );
              },
            ),
          );
  }
}