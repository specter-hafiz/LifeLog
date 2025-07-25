import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifelog/app.dart';
import 'package:lifelog/core/utils/secure_storage.dart';
import 'package:lifelog/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lifelog/features/auth/presentation/bloc/auth_state.dart';
import 'package:lifelog/features/auth/presentation/bloc/auth_event.dart';
import 'package:lifelog/features/auth/presentation/screens/login_screen.dart';
import 'package:lifelog/features/home/screens/home_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

class SplashScreen extends StatefulWidget {
  static const routeName = '/';

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Check if user is already authenticated
    checkSession();
    Future.delayed(const Duration(milliseconds: 500), () {
      context.read<AuthBloc>().add(
        AuthCheckRequested(),
      ); // Dispatch check event
    });
  }

  Future<void> checkSession() async {
    final session = sl<SupabaseClient>().auth.currentSession;
    print("Checking session...");
    if (session == null) {
      print("⚠️ No session found, checking secure storage...");
      final accessToken = await sl<SharedPrefsStorage>().accessToken();
      if (accessToken != null) {
        print("✅ Access token found in secure storage.");
        // Restore session using access token
        await sl<SupabaseClient>().auth.setSession(accessToken);
      } else {
        print("⚠️ No access token found in secure storage.");
      }
    } else {
      print("✅ Session already exists: ${session.user.email}");
    }

    if (session == null) {
      print("⚠️ No saved session found.");
      // Navigate to SignIn screen
      Navigator.pushReplacementNamed(context, '/signin');
    } else {
      print("✅ Session restored: ${session.user.email}");
      // Navigate to Home screen
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          Navigator.of(context).pushReplacementNamed(
            HomeScreen.routeName,
            arguments: {'userId': state.user.id},
          );
        } else if (state is AuthUnauthenticated || state is AuthFailureState) {
          Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
        }
      },
      child: const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
