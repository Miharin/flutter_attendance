import 'package:flutter/material.dart';
import 'package:flutter_attendance/widgets/templates/etc/appbar.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key, required this.child, required this.title});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: title,
      ),
      body: child,
    );
  }
}
