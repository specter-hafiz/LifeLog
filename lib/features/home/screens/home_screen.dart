import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifelog/core/utils/app_colors.dart';
import 'package:lifelog/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lifelog/features/auth/presentation/bloc/auth_event.dart';
import 'package:lifelog/features/auth/presentation/bloc/auth_state.dart';
import 'package:lifelog/features/auth/presentation/screens/login_screen.dart';
import 'package:lifelog/features/journal/domain/entities/journal_entry.dart';
import 'package:lifelog/features/journal/presentation/bloc/journal_bloc.dart';
import 'package:lifelog/features/journal/presentation/bloc/journal_event.dart';
import 'package:lifelog/features/journal/presentation/bloc/journal_state.dart';
import 'package:lifelog/features/journal/presentation/screens/add_journal_screen.dart';
import 'package:lifelog/features/journal/presentation/widgets/journal_entry_card.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  final String userId;

  const HomeScreen({super.key, required this.userId});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  List<JournalEntry> _entries = [];
  bool _isConnected = true;

  @override
  void initState() {
    super.initState();
    context.read<JournalBloc>().add(LoadJournalEntries(widget.userId));
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      results,
    ) {
      final result = results.isNotEmpty
          ? results.first
          : ConnectivityResult.none;
      _updateConnectionStatus(result);
    });
    _checkInitialConnection();
  }

  Future<void> _checkInitialConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    _updateConnectionStatus(connectivityResult.first);
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    final wasConnected = _isConnected;
    final nowConnected = result != ConnectivityResult.none;

    setState(() {
      _isConnected = nowConnected;
    });

    if (!wasConnected && nowConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("You're back online"),
          backgroundColor: Colors.green,
        ),
      );
    } else if (wasConnected && !nowConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No internet connection"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _handleJournalState(BuildContext context, JournalState state) {
    if (state is JournalLoaded) {
      setState(() {
        _entries = state.entries;
      });
    } else if (state is JournalEntryAdded) {
      setState(() {
        _entries.insert(0, state.entry);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Entry added: ${state.entry.title}')),
      );
    } else if (state is JournalEntryExists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Entry for today already exists')),
      );
    } else if (state is JournalFailureState) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${state.message}')));
    }
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<JournalBloc, JournalState>(listener: _handleJournalState),
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthLogoutRequested || state is AuthUnauthenticated) {
              Navigator.pushReplacementNamed(context, LoginScreen.routeName);
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('LifeLog'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                context.read<AuthBloc>().add(AuthLogoutRequested());
              },
            ),
          ],
        ),
        body: !_isConnected
            ? _buildNoInternetView()
            : BlocBuilder<JournalBloc, JournalState>(
                builder: (context, state) {
                  if (state is JournalLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (_entries.isEmpty) {
                    return const Center(child: Text('No entries yet!'));
                  } else {
                    return ListView.builder(
                      itemCount: _entries.length,
                      itemBuilder: (context, i) =>
                          JournalEntryCard(entry: _entries[i]),
                    );
                  }
                },
              ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          backgroundColor: _isConnected
              ? AppColors.primary
              : Colors.grey.shade400,
          foregroundColor: Colors.white,
          onPressed: () {
            if (_isConnected) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => AddJournalScreen(userId: widget.userId),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("You must be online to add a journal entry."),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildNoInternetView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'No internet connection',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            icon: const Icon(Icons.refresh),
            label: const Text("Retry"),
            onPressed: _checkInitialConnection,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
