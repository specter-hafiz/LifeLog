import 'package:bloc/bloc.dart';
import 'package:lifelog/core/error/failures.dart';
import 'package:lifelog/features/journal/domain/usecases/add_entry.dart';
import 'package:lifelog/features/journal/domain/usecases/get_entries.dart';
import 'package:lifelog/features/journal/domain/usecases/get_entry_by_date.dart';
import 'package:lifelog/features/journal/presentation/bloc/journal_event.dart';
import 'package:lifelog/features/journal/presentation/bloc/journal_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class JournalBloc extends Bloc<JournalEvent, JournalState> {
  final GetEntries getEntries;
  final AddEntry addEntry;
  final GetEntryByDate getEntryByDate;

  JournalBloc({
    required this.getEntries,
    required this.addEntry,
    required this.getEntryByDate,
  }) : super(JournalInitial()) {
    on<LoadJournalEntries>(_onLoadEntries);
    on<AddJournalEntry>(_onAddEntry);
    on<CheckEntryForDate>(_onCheckEntryForDate);
  }

  Future<void> _onLoadEntries(
    LoadJournalEntries event,
    Emitter<JournalState> emit,
  ) async {
    emit(JournalLoading());
    final result = await getEntries(event.userId);
    result.fold(
      (failure) => emit(JournalFailureState(failure.toString())),
      (entries) => emit(JournalLoaded(entries)),
    );
  }

  Future<void> _onAddEntry(
    AddJournalEntry event,
    Emitter<JournalState> emit,
  ) async {
    emit(JournalLoading());

    final addResult = await addEntry(event.entry);

    if (addResult.isLeft()) {
      // Only emit failure and return — don't proceed
      final failure = addResult.swap().getOrElse(
        () => AuthFailure('Unknown error'),
      );
      print("Failure: $failure");
      if (failure is FunctionException) {
        emit(JournalEntryExists()); // This will trigger your SnackBar
      } else {
        emit(JournalEntryExists());
      }
      return;
    }

    // Success: fetch entries
    final fetchResult = await getEntries(event.entry.userId);
    fetchResult.fold(
      (failure) => emit(JournalFailureState(failure.toString())),
      (entries) => emit(JournalLoaded(entries)),
    );
  }

  Future<void> _onCheckEntryForDate(
    CheckEntryForDate event,
    Emitter<JournalState> emit,
  ) async {
    emit(JournalLoading());
    final result = await getEntryByDate(
      GetEntryByDateParams(userId: event.userId, date: event.date),
    );
    result.fold(
      (failure) => emit(JournalFailureState(failure.toString())),
      (entry) => emit(JournalEntryForDateChecked(entry)),
    );
  }
}
