import 'package:equatable/equatable.dart';
import 'package:lifelog/features/journal/domain/entities/journal_entry.dart';

abstract class JournalEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadJournalEntries extends JournalEvent {
  final String userId;

  LoadJournalEntries(this.userId);

  @override
  List<Object?> get props => [userId];
}

class AddJournalEntry extends JournalEvent {
  final JournalEntry entry;

  AddJournalEntry(this.entry);

  @override
  List<Object?> get props => [entry];
}

class CheckEntryForDate extends JournalEvent {
  final String userId;
  final DateTime date;

  CheckEntryForDate({required this.userId, required this.date});

  @override
  List<Object?> get props => [userId, date];
}
