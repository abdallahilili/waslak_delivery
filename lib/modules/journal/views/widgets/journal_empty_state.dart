import 'package:flutter/material.dart';

class JournalEmptyState extends StatelessWidget {
  final VoidCallback onCreatePressed;

  const JournalEmptyState({
    Key? key,
    required this.onCreatePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.book_outlined, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('Aucun journal trouvé'),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onCreatePressed,
            icon: const Icon(Icons.add),
            label: const Text('OUVRIR UN NOUVEAU JOURNAL'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
