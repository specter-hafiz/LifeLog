import 'package:dartz/dartz.dart';
import 'package:lifelog/core/error/failures.dart';
import '../entities/journal_entry.dart';

abstract class JournalRepository {
  Future<Either<Failure, List<JournalEntry>>> getEntries(String userId);
  Future<Either<Failure, JournalEntry>> addEntry(JournalEntry entry);
  Future<Either<Failure, JournalEntry?>> getEntryByDate(
    String userId,
    DateTime date,
  );
}
