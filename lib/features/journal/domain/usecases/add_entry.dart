import 'package:dartz/dartz.dart';
import 'package:lifelog/core/error/failures.dart';
import 'package:lifelog/core/usecases/usecase.dart';
import '../entities/journal_entry.dart';
import '../repositories/journal_repository.dart';

class AddEntry implements UseCase<JournalEntry, JournalEntry> {
  final JournalRepository repository;

  AddEntry(this.repository);

  @override
  Future<Either<Failure, JournalEntry>> call(JournalEntry entry) {
    return repository.addEntry(entry);
  }
}
