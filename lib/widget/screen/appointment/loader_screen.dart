import 'package:flutter/material.dart';

class LoaderScreen extends StatelessWidget {
  double? _deviceWidth, _deviceHeight;

  LoaderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;

    return Container(
      color: Colors.white,
      width: _deviceWidth!,
      height: _deviceHeight! * 0.07,
    );
  }
}
