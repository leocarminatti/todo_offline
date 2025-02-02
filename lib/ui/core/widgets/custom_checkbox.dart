import 'package:flutter/material.dart';

class CustomCheckbox extends StatelessWidget {
  const CustomCheckbox({
    super.key,
    this.value,
    this.onChanged,
  });

  final bool? value;
  final void Function(bool?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      visualDensity: VisualDensity(horizontal: -4, vertical: -4),
      activeColor: Colors.blue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      side: WidgetStateBorderSide.resolveWith(
        (states) => BorderSide(width: 1.0, color: Colors.grey),
      ),
      value: value,
      onChanged: onChanged,
    );
  }
}
