import 'package:flutter/material.dart';
import 'package:patient_holistic_healing/widget/screen/appointment/add_therapires.dart/theraphy_model.dart';

class ItemtheraphyLayout extends StatelessWidget {
  ItemtheraphyLayout({
    super.key,
    required this.theraphy,
    required this.isSelected,
    required this.therapySelected,
    required this.selectedTherapies,
  });
  final TheraphyModel theraphy;
  bool isSelected = false;
  final void Function(TheraphyModel theaphy, bool) therapySelected;
  Set<TheraphyModel> selectedTherapies = {};

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => therapySelected(theraphy, !isSelected),
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Row(
                children: [
                  CheckboxListTile(
                    title: Text(theraphy.name),
                    tileColor: isSelected
                        ? Colors.blueAccent.shade100
                        : Colors.white,
                    value: isSelected,
                    onChanged: (bool? therapySelected) {
                      //         toggleTherapySelected(theraphy, therapySelected ?? false);
                    },
                  ),

                  // Icon(
                  //   size: 40,
                  //   Icons.check_box_outline_blank_rounded,
                  //   color: Colors.blueAccent,
                  // ),
                  const SizedBox(width: 12),
                  // Expanded(
                  //   child: Text(
                  //     theraphy.name,
                  //     style: Theme.of(context).textTheme.titleLarge,
                  //   ),
                  // ),
                  // const SizedBox(width: 4),
                ],
              ),
              const SizedBox(height: 4),
            ],
          ),
        ),
      ),
    );
  }
}
