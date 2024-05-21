import 'package:flutter/material.dart';

class CustomDropDown extends StatelessWidget {
  const CustomDropDown({
    super.key,
    this.onSelected,
    required this.list,
    required this.label,
    required this.verification,
    this.errorText,
    this.flex,
    this.enabled = true,
  });
  final String label;
  final List<dynamic> list;
  final bool verification;
  final String? errorText;
  final int? flex;
  final void Function(String?)? onSelected;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    // var errorVerificationFinal = !verification && controller.text.isNotEmpty;
    return Flexible(
      flex: flex ?? 1,
      child: Padding(
        padding: const EdgeInsets.only(right: 4.0),
        child: DropdownMenu<String>(
          enabled: enabled,
          expandedInsets: EdgeInsets.zero,
          menuHeight: MediaQuery.of(context).size.height * 0.35,
          enableFilter: true,
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: BorderSide(
                  color: Colors.grey[300]!,
                  width: 1.0,
                )),
          ),
          label: Text(label),
          helperText: "",
          onSelected: onSelected,
          dropdownMenuEntries:
              list.map<DropdownMenuEntry<String>>((dynamic value) {
            return DropdownMenuEntry<String>(
                value: value.id, label: value.name);
          }).toList(),
        ),
      ),
    );
  }
}
