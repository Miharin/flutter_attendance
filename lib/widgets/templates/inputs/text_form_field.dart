import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  CustomTextFormField({
    super.key,
    required this.label,
    required this.verification,
    this.focusNode,
    this.validator,
    this.keyboardType,
    this.inputFormatter,
    this.obscureText,
    this.readOnly,
    this.maxlines,
    this.icon,
    this.suffixIcon,
    this.errorMessage,
    this.errorBorder,
    this.border,
    this.onSave,
    this.onTap,
    this.flex,
    this.length,
    this.controller,
  });

// Start Required Properties
  final String label;
  final bool verification;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final int? flex;
  final int? length;
  final TextEditingController? controller;
// End Required Properties

// Start Additional Properties

  // Define Use Which Keyboard Type, e.g Text, Number, Email
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatter;

  // Is Text Form Field is Password Related ?
  final bool? obscureText;

  // Is Text Form Field Read Only ?
  final bool? readOnly;

  // If Need more then one line
  final int? maxlines;

// Icon Properties

  // Icon Use Outside Text Form Field
  final IconData? icon;

  // Icon Inside Text Form Field
  final IconButton? suffixIcon;

// Error Properties

  // Error Hint
  final String? errorMessage;

  // Error Border
  final InputBorder? errorBorder;

  // Input Border if Any
  final InputBorder? border;

  // Default Border If border is Null
  final InputBorder defaultBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(5.0),
    borderSide: BorderSide(
      color: Colors.grey[300]!,
      width: 1.0,
    ),
  );

  // Error Border
  final defaultErrorBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(5.0),
    borderSide: BorderSide(
      color: Colors.red[300]!,
      width: 1.0,
    ),
  );

  // Function
  final Function(String?)? onSave;
  final void Function()? onTap;

  // End Additional Properties

  // Start Building Widget
  @override
  Widget build(BuildContext context) {
    // return Text Form Field
    return Flexible(
      flex: flex ?? 1,
      child: Padding(
        padding: const EdgeInsets.only(right: 4.0),
        child: TextFormField(
          controller: controller,
          focusNode: focusNode,
          validator: validator,
          keyboardType: keyboardType ?? TextInputType.text,
          inputFormatters: keyboardType == TextInputType.number
              ? [FilteringTextInputFormatter.digitsOnly]
              : inputFormatter ?? [],
          onChanged: onSave,
          maxLength: length,
          // if Date Time onTap Popup Date Picker
          onTap: onTap,
          // If Obscure Text is Empty or Null Set Obscure Text to False
          obscureText: obscureText ?? false,
          readOnly: readOnly ?? false,
          maxLines: maxlines ?? 1,
          decoration: InputDecoration(
            // if Icon is Empty Then Null
            prefixIcon: icon != null
                ? Icon(
                    icon,
                    // If Text is Empty Set Colors to Black
                    color: !verification ? Colors.red : Colors.greenAccent,
                  )
                : null,
            suffixIcon: suffixIcon,
            border: border ?? defaultBorder,
            label: Text(label),
            // If errorVerificationFinal == true then send errorText and error Border
            errorText: !verification ? errorMessage : null,
            errorBorder:
                !verification ? errorBorder ?? defaultErrorBorder : null,
            counterText: "",
            helperText: "",
          ),
          // controller: controller,
        ),
      ),
    );
  }
  // End Building Gadget
}
