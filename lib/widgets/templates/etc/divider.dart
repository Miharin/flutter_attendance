import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({
    super.key,
    this.space,
    this.color = Colors.black38,
    this.height,
    this.thickness = 1.0,
  });
  final double? space;
  final Color? color;
  final double? height;
  final double? thickness;

  @override
  Widget build(BuildContext context) {
    return Divider(
      indent: space,
      endIndent: space,
      color: color,
      height: height,
      thickness: thickness,
    );
  }
}

class CustomVerticalDivider extends StatelessWidget {
  const CustomVerticalDivider({
    super.key,
    required this.height,
    this.color,
  });

  final double height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: VerticalDivider(
        width: 0.5,
        color: color ?? Colors.grey[400],
      ),
    );
  }
}
