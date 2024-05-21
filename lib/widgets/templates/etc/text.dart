import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({
    super.key,
    required this.child,
  });

  final String child;
  @override
  Widget build(BuildContext context) {
    return Text(
      child,
      style: const TextStyle(
        fontSize: 30.0,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
