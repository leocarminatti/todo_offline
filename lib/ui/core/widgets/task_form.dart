import 'package:flutter/material.dart';

import '../../ui.dart';

class TaskForm extends StatefulWidget {
  final Function(String, String, bool) onSave;

  const TaskForm({super.key, required this.onSave});

  @override
  _TaskMinimalFormState createState() => _TaskMinimalFormState();
}

class _TaskMinimalFormState extends State<TaskForm> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isCompleted = false;

  void _submitForm() {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();

    if (title.isNotEmpty) {
      widget.onSave(title, description, _isCompleted);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomCheckbox(
                value: _isCompleted,
                onChanged: (value) {
                  setState(() {
                    _isCompleted = value ?? false;
                  });
                },
              ),
              Expanded(
                child: TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    hintText: "O que está em sua mente?",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.edit, color: Colors.grey),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    hintText: "Adicione uma nota...",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: _submitForm,
              child: const Text(
                'criar',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
