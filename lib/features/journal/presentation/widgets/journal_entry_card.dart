import 'package:flutter/material.dart';
import 'package:lifelog/core/utils/app_colors.dart';
import 'package:lifelog/features/journal/presentation/screens/journal_detail_screen.dart';
import '../../domain/entities/journal_entry.dart';
import 'package:intl/intl.dart';

class JournalEntryCard extends StatelessWidget {
  final JournalEntry entry;

  const JournalEntryCard({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.primary,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(
          entry.title,
          maxLines: 1,

          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          DateFormat.yMMMMd().format(entry.createdAt),
          style: TextStyle(color: Colors.white70),
        ),
        trailing: Text(
          'Mood: ${entry.mood}',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => JournalDetailScreen(entry: entry),
            ),
          );
        },
      ),
    );
  }
}
