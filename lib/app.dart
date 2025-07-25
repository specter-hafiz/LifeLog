import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:lifelog/features/auth/presentation/screens/login_screen.dart';
import 'package:lifelog/features/auth/presentation/screens/signup_screen.dart';
import 'package:lifelog/features/auth/presentation/screens/splash_screen.dart';
import 'package:lifelog/features/home/screens/home_screen.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/journal/presentation/bloc/journal_bloc.dart';

final sl = GetIt.instance;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => sl<AuthBloc>()),
        BlocProvider<JournalBloc>(create: (_) => sl<JournalBloc>()),
      ],
      child: MaterialApp(
        title: 'LifeLog',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: SplashScreen.routeName,
        routes: {
          SplashScreen.routeName: (_) => const SplashScreen(),
          LoginScreen.routeName: (_) => const LoginScreen(),
          SignupScreen.routeName: (_) => const SignupScreen(),
          // HomePage: handled via onGenerateRoute for passing userId
        },
        onGenerateRoute: (settings) {
          if (settings.name == HomeScreen.routeName) {
            final args = settings.arguments as Map<String, dynamic>?;
            final userId = args?['userId'] as String?;
            if (userId != null) {
              return MaterialPageRoute(
                builder: (_) => HomeScreen(userId: userId),
              );
            }
          }
          return null;
        },
      ),
    );
  }
}
