import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifelog/core/utils/app_colors.dart';
import 'package:lifelog/features/journal/domain/entities/journal_entry.dart';
import 'package:lifelog/features/journal/presentation/bloc/journal_bloc.dart';
import 'package:lifelog/features/journal/presentation/bloc/journal_event.dart';
import 'package:lifelog/features/journal/presentation/bloc/journal_state.dart';
import 'package:lifelog/features/journal/presentation/widgets/mood_picker.dart';
import 'package:uuid/uuid.dart';

class AddJournalScreen extends StatefulWidget {
  final String userId;

  const AddJournalScreen({super.key, required this.userId});

  @override
  State<AddJournalScreen> createState() => _AddJournalScreenState();
}

class _AddJournalScreenState extends State<AddJournalScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _body = '';
  int _mood = 3;

  void _submit() {
    final id = Uuid().v4();
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      final entry = JournalEntry(
        id: id,
        userId: widget.userId,
        title: _title,
        body: _body,
        mood: _mood,
        createdAt: DateTime.now(),
      );
      context.read<JournalBloc>().add(AddJournalEntry(entry));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Entry'), titleSpacing: 0),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                onSaved: (val) => _title = val ?? '',
                validator: (val) =>
                    val != null && val.isNotEmpty ? null : 'Title required',
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Body'),
                minLines: 3,
                maxLines: 6,
                onSaved: (val) => _body = val ?? '',
                validator: (val) =>
                    val != null && val.isNotEmpty ? null : 'Body required',
              ),
              const SizedBox(height: 10),
              MoodPicker(
                value: _mood,
                onChanged: (val) => setState(() => _mood = val),
              ),
              const SizedBox(height: 16),
              BlocBuilder<JournalBloc, JournalState>(
                builder: (context, state) {
                  if (state is JournalLoading) {
                    return const CircularProgressIndicator();
                  }
                  return CustomElevatedButton(
                    buttonText: 'Save Entry',
                    onPressed: _submit,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    super.key,
    this.onPressed,
    required this.buttonText,
  });
  final void Function()? onPressed;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(
          double.infinity,
          orientation == Orientation.portrait
              ? MediaQuery.of(context).size.height * 0.06
              : MediaQuery.of(context).size.width * 0.06,
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      onPressed: onPressed,
      child: Text(buttonText),
    );
  }
}
