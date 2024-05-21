import 'package:flutter/material.dart';

class CustomChoiceChip extends StatelessWidget {
  const CustomChoiceChip({
    super.key,
    this.fontsize,
    required this.content,
    required this.selected,
    required this.onSelected,
    this.titlefontzise,
  });
  final double? titlefontzise;
  final String content;
  final void Function(bool)? onSelected;
  final bool selected;
  final double? fontsize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: ChoiceChip(
        label: Text(
          content,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: fontsize,
          ),
        ),
        selected: selected,
        onSelected: onSelected,
      ),
    );
  }
}
