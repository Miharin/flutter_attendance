import 'package:flutter/material.dart';

class CustomForm extends StatelessWidget {
  const CustomForm({
    super.key,
    required this.formKey,
    required this.child,
    this.onChanged,
  });
  final Key formKey;
  final Widget child;
  final void Function()? onChanged;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: onChanged,
      child: child,
    );
  }
}
