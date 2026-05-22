import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../providers/pin_provider.dart';

class PinDialog extends StatefulWidget {
  final LatLng position;

  const PinDialog({super.key, required this.position});

  @override
  State<PinDialog> createState() => _PinDialogState();
}

class _PinDialogState extends State<PinDialog> {
  final _commentController = TextEditingController();
  String _selectedCategory = 'general';

  final List<Map<String, dynamic>> _categories = [
    {'value': 'general', 'label': 'General', 'icon': Icons.chat_bubble},
    {'value': 'warning', 'label': 'Warning', 'icon': Icons.warning},
    {
      'value': 'recommendation',
      'label': 'Recommendation',
      'icon': Icons.thumb_up,
    },
    {'value': 'question', 'label': 'Question', 'icon': Icons.help},
  ];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Drop a Whisper 📌'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Selector de categoría
          DropdownButtonFormField<String>(
            initialValue: _selectedCategory,
            decoration: const InputDecoration(
              labelText: 'Category',
              border: OutlineInputBorder(),
            ),
            items: _categories.map((cat) {
              return DropdownMenuItem<String>(
                value: cat['value'],
                child: Row(
                  children: [
                    Icon(cat['icon'], size: 18),
                    const SizedBox(width: 8),
                    Text(cat['label']),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() => _selectedCategory = value!);
            },
          ),
          const SizedBox(height: 16),
          // Campo de comentario
          TextField(
            controller: _commentController,
            maxLines: 3,
            maxLength: 200,
            decoration: const InputDecoration(
              labelText: 'Your whisper...',
              border: OutlineInputBorder(),
              hintText: 'Say something anonymous...',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_commentController.text.trim().isEmpty) return;

            await context.read<PinProvider>().createPin(
              lat: widget.position.latitude,
              lng: widget.position.longitude,
              comment: _commentController.text.trim(),
              category: _selectedCategory,
            );

            if (context.mounted) Navigator.pop(context);
          },
          child: const Text('Whisper! 🤫'),
        ),
      ],
    );
  }
}
