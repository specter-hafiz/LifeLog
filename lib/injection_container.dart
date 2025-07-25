import 'package:get_it/get_it.dart';
import 'features/auth/auth_injection.dart';
import 'features/journal/journal_injection.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Auth feature injection
  await initAuth(sl);

  // Journal feature injection
  await initJournal(sl);

  // Other features (home, etc.) can be added here
}
