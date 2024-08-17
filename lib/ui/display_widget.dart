import 'package:flutter/material.dart';

class DisplayWidget extends StatelessWidget {
  final String message;
  final bool isVisible;
  const DisplayWidget(
      {super.key, required this.message, required this.isVisible});

  @override
  Widget build(BuildContext context) {
    return Visibility(visible: isVisible, child: Text(message));
  }
}
