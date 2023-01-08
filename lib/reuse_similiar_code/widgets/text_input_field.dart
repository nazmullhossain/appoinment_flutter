import 'package:flutter/material.dart';

class TextInputField extends StatelessWidget {
  String? Function(String?)? validateFunction;
  ValueChanged<String?>? onValueChanged;
  TextInputType? keyboard;

  String? label;
  bool? readPermit = false;
  IconData? icon;

  int? maxLine;
  TextEditingController? textController = TextEditingController();

  TextInputField({
    this.icon,
    this.keyboard,
    this.label,
    this.onValueChanged,
    this.readPermit,
    this.textController,
    this.validateFunction,
    this.maxLine,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboard,
      autofocus: false,
      controller: textController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validateFunction,
      readOnly: readPermit as bool,
      onChanged: onValueChanged,
      maxLines: maxLine,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        fillColor: Colors.grey[50],
        filled: true,
        labelText: label,
      ),
    );
  }
}
