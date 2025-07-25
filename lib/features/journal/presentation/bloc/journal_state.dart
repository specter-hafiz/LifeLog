import 'package:equatable/equatable.dart';
import 'package:lifelog/features/journal/domain/entities/journal_entry.dart';

abstract class JournalState extends Equatable {
  @override
  List<Object?> get props => [];
}

class JournalInitial extends JournalState {}

class JournalLoading extends JournalState {}

class JournalEntryExists extends JournalState {}

class JournalLoaded extends JournalState {
  final List<JournalEntry> entries;

  JournalLoaded(this.entries);

  @override
  List<Object?> get props => [entries];
}

class JournalEntryAdded extends JournalState {
  final JournalEntry entry;

  JournalEntryAdded(this.entry);

  @override
  List<Object?> get props => [entry];
}

class JournalEntryForDateChecked extends JournalState {
  final JournalEntry? entry;

  JournalEntryForDateChecked(this.entry);

  @override
  List<Object?> get props => [entry];
}

class JournalFailureState extends JournalState {
  final String message;

  JournalFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
