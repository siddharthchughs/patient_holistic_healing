import 'package:flutter/material.dart';

class SelectedTherapiesMenu extends StatefulWidget {
  const SelectedTherapiesMenu({super.key});

  @override
  State<SelectedTherapiesMenu> createState() => _SelectedTherapiesMenuState();
}

class _SelectedTherapiesMenuState extends State<SelectedTherapiesMenu> {
  bool _customTileExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ExpansionTile(
          title: const Text('Selected Therapies'),
          trailing: Icon(
            _customTileExpanded
                ? Icons.arrow_drop_down_circle
                : Icons.arrow_drop_down,
          ),
          children: const <Widget>[
            ListTile(title: Text('This is tile number 2')),
          ],
          onExpansionChanged: (bool expanded) {
            setState(() {
              _customTileExpanded = expanded;
            });
          },
        ),
      ],
    );
  }
}
