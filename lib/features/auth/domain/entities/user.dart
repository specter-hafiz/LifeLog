import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;

  const User({required this.id, required this.email});

  static const empty = User(id: '', email: '');

  @override
  List<Object?> get props => [id, email];
}
