import 'package:dartz/dartz.dart';
import 'package:lifelog/core/error/failures.dart';
import 'package:lifelog/core/usecases/usecase.dart';
import '../entities/journal_entry.dart';
import '../repositories/journal_repository.dart';

class GetEntryByDate implements UseCase<JournalEntry?, GetEntryByDateParams> {
  final JournalRepository repository;

  GetEntryByDate(this.repository);

  @override
  Future<Either<Failure, JournalEntry?>> call(GetEntryByDateParams params) {
    return repository.getEntryByDate(params.userId, params.date);
  }
}

class GetEntryByDateParams {
  final String userId;
  final DateTime date;

  GetEntryByDateParams({required this.userId, required this.date});
}
