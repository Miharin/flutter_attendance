import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExpansionPanelItem {
  final String title;
  final Widget body;
  final bool isExpanded;
  ExpansionPanelItem({required this.title, required this.body})
      : isExpanded = false.obs.value;
}

// Expansion Callback to Set Which Index Has Expanded
class CustomExpandableWidget extends StatelessWidget {
  const CustomExpandableWidget({
    super.key,
    required this.expansionCallback,
    required this.children,
  });

  final Function(int, bool) expansionCallback;
  final List<ExpansionPanel> children;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ExpansionPanelList(
        expansionCallback: expansionCallback,
        children: children.toList(),
      ),
    );
  }
}
