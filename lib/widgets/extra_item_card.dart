// Extra Item Card Widget (extra_item_card.dart)
import 'package:flutter/material.dart';

class ExtraItemCard extends StatelessWidget {
  final String name;
  final String unit;
  final TextEditingController controller;
  final VoidCallback onDelete;

  const ExtraItemCard({
    super.key,
    required this.name,
    required this.unit,
    required this.controller,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                name,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: unit,
                  border: const OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
