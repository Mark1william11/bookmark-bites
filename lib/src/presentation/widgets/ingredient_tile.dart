import 'package:flutter/material.dart';

class IngredientTile extends StatelessWidget {
  const IngredientTile({
    super.key,
    required this.measure,
    required this.name,
  });

  final String measure;
  final String name;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Align items to the top
        children: [
          Container(
            // THE FIX: Removed the fixed width. Now it will resize based on content + padding.
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
            constraints: const BoxConstraints(
              minWidth: 60, // Ensure a minimum width for alignment
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: theme.colorScheme.primary.withOpacity(0.5)),
            ),
            child: Text(
              measure,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
              // THE FIX: Let the text wrap instead of showing ellipsis.
              // maxLines is implicitly > 1 now.
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4.0), // Align text better with the box
              child: Text(
                name,
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}