import 'package:get_it/get_it.dart';
import 'package:lifelog/features/journal/data/source/journal_remote_data_source.dart';
import 'data/repositories/journal_repository_impl.dart';
import 'domain/repositories/journal_repository.dart';
import 'domain/usecases/get_entries.dart';
import 'domain/usecases/add_entry.dart';
import 'domain/usecases/get_entry_by_date.dart';
import 'presentation/bloc/journal_bloc.dart';

Future<void> initJournal(GetIt sl) async {
  // Data sources
  sl.registerLazySingleton<JournalRemoteDataSource>(
    () => JournalRemoteDataSourceImpl(client: sl()),
  );

  // Repository
  sl.registerLazySingleton<JournalRepository>(
    () => JournalRepositoryImpl(remoteDataSource: sl()),
  );

  // Usecases
  sl.registerLazySingleton(() => GetEntries(sl()));
  sl.registerLazySingleton(() => AddEntry(sl()));
  sl.registerLazySingleton(() => GetEntryByDate(sl()));

  // Bloc
  sl.registerFactory(
    () => JournalBloc(getEntries: sl(), addEntry: sl(), getEntryByDate: sl()),
  );
}
