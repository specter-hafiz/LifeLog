import 'package:flutter/material.dart';
import '../../domain/entities/journal_entry.dart';
import 'package:intl/intl.dart';

class JournalDetailScreen extends StatelessWidget {
  final JournalEntry entry;

  const JournalDetailScreen({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(entry.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat.yMMMMd().format(entry.createdAt),
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Text(entry.body, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            Text('Mood: ${entry.mood}', style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
