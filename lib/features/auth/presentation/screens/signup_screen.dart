import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifelog/core/utils/app_colors.dart';
import 'package:lifelog/features/auth/presentation/bloc/auth_state.dart';
import 'package:lifelog/features/auth/presentation/widgets/auth_form.dart';
import 'package:lifelog/features/home/screens/home_screen.dart';
import '../bloc/auth_bloc.dart';

class SignupScreen extends StatelessWidget {
  static const routeName = '/signup';

  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          Navigator.of(context).pushReplacementNamed(
            HomeScreen.routeName,
            arguments: {'userId': state.user.id},
          );
        } else if (state is AuthFailureState) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.22),
                Center(
                  child: Column(
                    children: [
                      LifeLogImage(),
                      Text(
                        'LifeLog',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                Text(
                  'Sign Up',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
                ),
                AuthForm(isLogin: false),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Already have an account? Log in',
                      style: TextStyle(color: AppColors.secondary),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LifeLogImage extends StatelessWidget {
  const LifeLogImage({super.key});

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return Image(
      image: AssetImage('assets/icon/lifelog.png'),
      width: orientation == Orientation.portrait
          ? MediaQuery.of(context).size.width * 0.3
          : MediaQuery.of(context).size.height * 0.15,
      height: orientation == Orientation.portrait
          ? MediaQuery.of(context).size.width * 0.3
          : MediaQuery.of(context).size.height * 0.15,
    );
  }
}
