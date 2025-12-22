import 'package:flutter/material.dart';
import 'package:patient_holistic_healing/widget/screen/appointment/add_therapires.dart/theraphy_model.dart';

class TheraphyListScreen extends StatefulWidget {
  const TheraphyListScreen({super.key});

  @override
  State<StatefulWidget> createState() => _TheraphyListScreenState();
}

List<TheraphyModel> _therapies = [
  TheraphyModel(name: 'Acupuncture'),
  TheraphyModel(name: 'Naturopathy'),
  TheraphyModel(name: 'Herbal Medicine'),
  TheraphyModel(name: 'Chiropractic Care'),
  TheraphyModel(name: 'Ayurveda'),
  TheraphyModel(name: 'Osteopathy'),
  TheraphyModel(name: 'Reflexology'),
  TheraphyModel(name: 'Aromatherapy'),
  TheraphyModel(name: 'Nutritional Therapy'),
  TheraphyModel(name: 'Traditional Chinese Medicine'),
  TheraphyModel(name: 'Reiki'),
  TheraphyModel(name: 'None'),
];

class _TheraphyListScreenState extends State<TheraphyListScreen> {
  final Set<TheraphyModel> _selectedTherapies = {};

  void toogleTheraphySelection(TheraphyModel therapy, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedTherapies.add(therapy);
      } else {
        _selectedTherapies.remove(therapy);
      }
    });
  }

  void naivagteToAddTherapyScreen() {
    final List<String> selectedNamews = _selectedTherapies
        .map((th) => th.name)
        .toList();
    Navigator.pop(context, selectedNamews);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: const Text('Select Therapy'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextButton(
              onPressed: () {
                naivagteToAddTherapyScreen();
              },
              child: Text(
                'Add Selected',
                style: TextStyle(color: Colors.blue.shade700, fontSize: 16),
              ),
            ),
          ),
          SizedBox(width: 8.0),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, 'setting');
              },
              child: const Icon(Icons.close, color: Colors.white),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        //         shrinkWrap: true,
        itemCount: _therapies.length,
        itemBuilder: (ctx, index) {
          final therapy = _therapies[index];
          final isSelected = _selectedTherapies.contains(therapy);
          return CheckboxListTile(
            title: Text(
              therapy.name,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            value: isSelected,
            onChanged: (bool? value) {
              toogleTheraphySelection(therapy, value ?? false);
            },
            activeColor: Colors.blue.shade500,
          );
        },
      ),
    );
  }
}
