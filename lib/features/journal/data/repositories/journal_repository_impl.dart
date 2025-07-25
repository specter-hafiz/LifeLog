import 'package:dartz/dartz.dart';
import 'package:lifelog/core/error/exceptions.dart';
import 'package:lifelog/core/error/failures.dart';
import 'package:lifelog/features/journal/data/source/journal_remote_data_source.dart';
import '../../domain/entities/journal_entry.dart';
import '../../domain/repositories/journal_repository.dart';
import '../models/journal_entry_model.dart';

class JournalRepositoryImpl implements JournalRepository {
  final JournalRemoteDataSource remoteDataSource;

  JournalRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<JournalEntry>>> getEntries(String userId) async {
    try {
      final entries = await remoteDataSource.getEntries(userId);
      return Right(entries);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, JournalEntry>> addEntry(JournalEntry entry) async {
    try {
      final entryModel = JournalEntryModel(
        id: entry.id,
        userId: entry.userId,
        title: entry.title,
        body: entry.body,
        mood: entry.mood,
        createdAt: entry.createdAt,
      );
      final result = await remoteDataSource.addEntry(entryModel);
      return Right(result);
    } on DuplicateEntryException catch (_) {
      return Left(DuplicateEntryFailure());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, JournalEntry?>> getEntryByDate(
    String userId,
    DateTime date,
  ) async {
    try {
      final entry = await remoteDataSource.getEntryByDate(userId, date);
      return Right(entry);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
