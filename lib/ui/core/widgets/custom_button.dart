import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    this.icon,
    this.color = Colors.blueAccent,
    this.onPressed,
  });

  final String text;
  final IconData? icon;
  final Color? color;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(color!.withAlpha(30)),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: color),
            const SizedBox(width: 8),
          ],
          Text(
            text,
            style: TextStyle(color: color),
          ),
        ],
      ),
    );
  }
}
