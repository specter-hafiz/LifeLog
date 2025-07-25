import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifelog/features/auth/presentation/bloc/auth_event.dart';
import 'package:lifelog/features/auth/presentation/bloc/auth_state.dart';
import 'package:lifelog/features/journal/presentation/screens/add_journal_screen.dart';
import '../bloc/auth_bloc.dart';

class AuthForm extends StatefulWidget {
  final bool isLogin;
  const AuthForm({super.key, required this.isLogin});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      final bloc = context.read<AuthBloc>();
      if (widget.isLogin) {
        bloc.add(AuthLoginRequested(email: _email, password: _password));
      } else {
        bloc.add(AuthSignupRequested(email: _email, password: _password));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailureState && mounted) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Email'),
              onSaved: (val) => _email = val ?? '',
              validator: (val) => val != null && val.contains('@')
                  ? null
                  : 'Enter a valid email',
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
              onSaved: (val) => _password = val ?? '',
              validator: (val) =>
                  val != null && val.length >= 6 ? null : 'Min 6 chars',
            ),
            const SizedBox(height: 16),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthLoading) {
                  return const CircularProgressIndicator();
                }

                return CustomElevatedButton(
                  onPressed: _submit,
                  buttonText: widget.isLogin ? 'Login' : 'Sign Up',
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
