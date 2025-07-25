import 'package:get_it/get_it.dart';
import 'package:lifelog/core/utils/secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'data/auth_remote_data_source.dart';
import 'data/repositories/auth_repo_impl.dart';
import 'domain/usecases/get_current_user.dart';
import 'domain/usecases/login_usecase.dart';
import 'domain/usecases/logout_usecase.dart';
import 'domain/usecases/signup_usecase.dart';
import 'domain/repositories/auth_repository.dart';
import 'presentation/bloc/auth_bloc.dart';
import '../../core/utils/constants.dart';

Future<void> initAuth(GetIt sl) async {
  // ✅ Step 1: Register SecureStorage FIRST
  sl.registerLazySingleton<SharedPrefsStorage>(() => SharedPrefsStorage());

  // ✅ Step 2: Now you can use SecureStorage to configure SupabaseClient
  final supabase = await Supabase.initialize(
    url: Constants.supabaseUrl,
    anonKey: Constants.supabaseAnonKey,
    authOptions: FlutterAuthClientOptions(
      localStorage: sl<SharedPrefsStorage>(),
    ),
    realtimeClientOptions: const RealtimeClientOptions(
      logLevel: RealtimeLogLevel.info,
    ),
  );
  sl.registerLazySingleton<SupabaseClient>(() => supabase.client);
  sl<SupabaseClient>().auth.onAuthStateChange.listen((data) {
    print('Auth event: ${data.event}');
    print('Session: ${data.session}');
  });

  // ✅ Step 3: Register Data Source
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(client: sl()),
  );

  // ✅ Step 4: Register Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // ✅ Step 5: Register Use Cases
  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton(() => Signup(sl()));
  sl.registerLazySingleton(() => Logout(sl()));
  sl.registerLazySingleton(() => GetCurrentUser(sl()));

  // ✅ Step 6: Register BLoC
  sl.registerFactory(
    () => AuthBloc(
      loginUsecase: sl(),
      signupUsecase: sl(),
      logoutUsecase: sl(),
      getCurrentUserUsecase: sl(),
    ),
  );
}
