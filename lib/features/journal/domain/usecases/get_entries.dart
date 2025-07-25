import 'package:dartz/dartz.dart';
import 'package:lifelog/core/error/failures.dart';
import 'package:lifelog/core/usecases/usecase.dart';
import '../entities/journal_entry.dart';
import '../repositories/journal_repository.dart';

class GetEntries implements UseCase<List<JournalEntry>, String> {
  final JournalRepository repository;

  GetEntries(this.repository);

  @override
  Future<Either<Failure, List<JournalEntry>>> call(String userId) {
    return repository.getEntries(userId);
  }
}
