import 'package:flutter/material.dart';
import 'package:patient_holistic_healing/widget/screen/appointment/add_therapires.dart/Theraphy_list_screen.dart';

class SelectTheraphy extends StatefulWidget {
  const SelectTheraphy({super.key});

  @override
  State<SelectTheraphy> createState() => _SelectTheraphyState();
}

class _SelectTheraphyState extends State<SelectTheraphy> {
  @override
  Widget build(BuildContext context) {
    return Container(child: TheraphyListScreen());
  }
}
