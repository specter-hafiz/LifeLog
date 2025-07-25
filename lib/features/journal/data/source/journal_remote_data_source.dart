import 'dart:convert';

import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/journal_entry_model.dart';

abstract class JournalRemoteDataSource {
  Future<List<JournalEntryModel>> getEntries(String userId);
  Future<JournalEntryModel> addEntry(JournalEntryModel entry);
  Future<JournalEntryModel?> getEntryByDate(String userId, DateTime date);
}

class JournalRemoteDataSourceImpl implements JournalRemoteDataSource {
  final SupabaseClient client;
  final String table = 'journal_entries';

  JournalRemoteDataSourceImpl({required this.client});

  @override
  Future<List<JournalEntryModel>> getEntries(String userId) async {
    final response = await client
        .from(table)
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    return (response as List)
        .map((e) => JournalEntryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<JournalEntryModel> addEntry(JournalEntryModel entry) async {
    // This should call an edge function instead of direct insert in production
    final response = await Supabase.instance.client.functions.invoke(
      'create_journal_entry',
      body: {
        'user_id': entry.userId,
        'title': entry.title,
        'body': entry.body,
        'mood': entry.mood,
        'created_at': entry.createdAt.toIso8601String(),
      },
    );

    final data = json.decode(response.data as String);
    print('Response from edge function: $data');
    if (response.status == 409) {
      // Handle duplicate entry case
      throw FunctionException(
        status: 409,
        details: data,
        reasonPhrase: 'Entry already exists',
      );
    }

    if (response.status != 200) {
      // Handle specific error cases based on the response
      throw Exception(data['error'] ?? 'Unknown error occurred');
    }

    return JournalEntryModel.fromJson(data);
  }

  @override
  Future<JournalEntryModel?> getEntryByDate(
    String userId,
    DateTime date,
  ) async {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));
    final response = await client
        .from(table)
        .select()
        .eq('user_id', userId)
        .gte('created_at', start.toIso8601String())
        .lt('created_at', end.toIso8601String());
    if ((response as List).isEmpty) return null;
    return JournalEntryModel.fromJson(response.first);
  }
}
