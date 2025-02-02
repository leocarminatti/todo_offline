import 'package:flutter/material.dart';

import '../../../domain/domain.dart';
import '../../ui.dart';

class TaskCard extends StatefulWidget {
  final Task task;
  final Function(bool?)? onCheck;

  const TaskCard({
    super.key,
    required this.task,
    this.onCheck,
  });

  @override
  _TaskCardState createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  bool isExpanded = false;

  void toggleExpand() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            CustomCheckbox(
              value: widget.task.isChecked,
              onChanged: (value) => widget.onCheck?.call(value),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.task.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (isExpanded)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      widget.task.description,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ),
              ],
            ),
            const Spacer(),
            IconButton(
              icon: Icon(Icons.more_horiz),
              onPressed: toggleExpand,
            ),
          ],
        ),
      ),
    );
  }
}
