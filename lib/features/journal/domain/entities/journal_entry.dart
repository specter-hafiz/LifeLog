import 'package:equatable/equatable.dart';

class JournalEntry extends Equatable {
  final String id;
  final String userId;
  final String title;
  final String body;
  final int mood;
  final DateTime createdAt;

  const JournalEntry({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.mood,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, userId, title, body, mood, createdAt];
}
