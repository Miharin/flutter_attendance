import 'package:flutter/material.dart';
import 'package:flutter_attendance/widgets/templates/etc/divider.dart';
import 'package:gap/gap.dart';

class CustomCardWithHeader extends StatelessWidget {
  const CustomCardWithHeader({
    super.key,
    required this.header,
    required this.children,
    this.flex,
    this.divider,
    this.fontsize,
    this.fontweight = FontWeight.bold,
    this.isGap = true,
  });
  final String header;
  final Widget children;
  final CustomDivider? divider;
  final bool isGap;

  final int? flex;
  final double? fontsize;
  final FontWeight fontweight;

  @override
  Widget build(BuildContext context) {
    return FlatCard(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 10.0,
            ),
            child: Text(
              header.toUpperCase(),
              style: TextStyle(
                fontSize: fontsize ?? 18.0,
                fontWeight: fontweight,
              ),
            ),
          ),
          divider ?? const CustomDivider(space: 20.0),
          isGap ? const Gap(10.0) : const Gap(0.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: children,
          ),
        ],
      ),
    );
  }
}

class FlatCard extends StatelessWidget {
  const FlatCard({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Colors.grey[200]!,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: child,
    );
  }
}
