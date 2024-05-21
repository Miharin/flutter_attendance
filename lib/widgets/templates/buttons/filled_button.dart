import 'package:flutter/material.dart';

class CustomFilledButton extends StatelessWidget {
  const CustomFilledButton(
      {super.key,
      this.icon,
      required this.label,
      this.width,
      required this.onPressed});
  final Icon? icon;
  final String label;
  final Size? width;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    // Return if icon not Null Then Set Widget To FillledButton.icon
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 4.0, 8.0),
      child: icon != null
          ? FilledButton.icon(
              label: Text(label),
              icon: icon!,
              style: FilledButton.styleFrom(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
                fixedSize: width,
                minimumSize: const Size.fromHeight(50.0),
              ),
              onPressed: onPressed,
            )

          // Otherwise Set Widget To FilledButton
          : FilledButton(
              style: FilledButton.styleFrom(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
                fixedSize: width,
                minimumSize: const Size.fromHeight(50.0),
              ),
              onPressed: onPressed,
              child: Text(label),
            ),
    );
  }
}
