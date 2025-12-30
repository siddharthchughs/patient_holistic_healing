// import 'package:flutter/material.dart';
// import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';

// class SelectedTherapiesMenu extends StatefulWidget {
//   const SelectedTherapiesMenu({super.key});

//   @override
//   State<SelectedTherapiesMenu> createState() => _SelectedTherapiesMenuState();
// }

// class _SelectedTherapiesMenuState extends State<SelectedTherapiesMenu> {
//   final bool _customTileExpanded = false;

//   @override
//   Widget build(BuildContext context) {
//     return ExpandedTileList.builder(
//       itemCount: 1,
//       itemBuilder: (context, index, con) {
//         return ExpandedTile(
//           title: const Text('Selected Therapies'),
//           trailing: Icon(
//             _customTileExpanded
//                 ? Icons.keyboard_arrow_up
//                 : Icons.keyboard_arrow_down_rounded,
//           ),
//           controller: con,
//           content: Column(children: [Text('data')]),
//         );
//       },
//     );
//   }
// }
