import 'package:flutter/material.dart';

class ForceUpdateWrapper extends StatelessWidget {
  final Widget child;
  
  const ForceUpdateWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }
}