import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/widgets/code_snippet_card.dart';
import '../../../core/widgets/interactive_demo_box.dart';
import '../../../core/widgets/section_header.dart';
import '../cubit/user_directory_cubit.dart';
import '../cubit/user_directory_state.dart';
import '../data/datasources/user_mock_datasource.dart';
import '../data/repositories/user_repository_impl.dart';

/// Screen teaching the Repository Pattern with Clean Architecture.
///
/// Demonstrates end-to-end data flow:
/// UI -> Cubit -> Repository Interface -> Repository Impl -> DataSource.
class UserDirectoryScreen extends StatefulWidget {
  const UserDirectoryScreen({super.key});

  @override
  State<UserDirectoryScreen> createState() => _UserDirectoryScreenState();
}

class _UserDirectoryScreenState extends State<UserDirectoryScreen> {
  late final UserMockDataSource _dataSource;
  late final UserRepositoryImpl _repository;
  late final UserDirectoryCubit _cubit;

  @override
  void initState() {
    super.initState();
    // Setting up the Clean Architecture Dependency Chain
    _dataSource = UserMockDataSource();
    _repository = UserRepositoryImpl(dataSource: _dataSource);
    _cubit = UserDirectoryCubit(repository: _repository);
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  void _showAddUserDialog() {
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final roleCtrl = TextEditingController(text: 'Flutter Developer');
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add User to Repository'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: emailCtrl,
                decoration: const InputDecoration(labelText: 'Email Address'),
                validator: (v) => v == null || !v.contains('@') ? 'Enter a valid email' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: roleCtrl,
                decoration: const InputDecoration(labelText: 'Job Role'),
                validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.of(ctx).pop();
                _cubit.addUser(
                  name: nameCtrl.text.trim(),
                  email: emailCtrl.text.trim(),
                  role: roleCtrl.text.trim(),
                );
              }
            },
            child: const Text('Save to Repo'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Repository Pattern Studio'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh_rounded),
              tooltip: 'Refresh directory',
              onPressed: () => _cubit.refreshUsers(),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          heroTag: 'repo_fab',
          onPressed: _showAddUserDialog,
          icon: const Icon(Icons.person_add_rounded),
          label: const Text('Add User'),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          children: [
            // Architecture Concept Banner
            Card(
              color: const Color(0xFF0D9488).withAlpha(20),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.account_tree_rounded, color: Color(0xFF0D9488), size: 36),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Clean Architecture Data Flow',
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'UI (Widget) ➔ Cubit ➔ Repository Contract ➔ Data Source (API / DB)',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // SECTION 1: Interactive Error Simulation & Controls
            const SectionHeader(
              title: '1. DataSource Diagnostics & Controls',
              subtitle: 'Toggle artificial network failure to see how Repository gracefully catches errors.',
              icon: Icons.tune_rounded,
              badgeText: 'Live Controls',
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                ),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Simulate Network Outage (Error State)',
                        style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold)),
                    subtitle: const Text('DataSource throws 503 HTTP timeout when enabled',
                        style: TextStyle(fontSize: 12)),
                    value: _dataSource.simulateFailure,
                    activeThumbColor: Colors.red,
                    onChanged: (val) {
                      setState(() {
                        _dataSource.simulateFailure = val;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(val
                              ? 'Simulation set to FAIL. Fetching will trigger Error state!'
                              : 'Simulation restored to NORMAL.'),
                          duration: const Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Simulated Network Latency:', style: TextStyle(fontSize: 13)),
                        Text('${_dataSource.latencyMs} ms',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // SECTION 2: Repository Data Flow Sandbox
            const SectionHeader(
              title: '2. Live Repository Consumer',
              subtitle: 'Observe how the UI cleanly handles Initial, Loading, Success, and Error.',
              icon: Icons.storage_rounded,
              badgeText: 'UI = f(State)',
            ),
            InteractiveDemoBox(
              label: 'User Directory Stream',
              child: BlocConsumer<UserDirectoryCubit, UserDirectoryState>(
                listener: (context, state) {
                  if (state is UserDirectoryLoaded && state.toastNotification != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.toastNotification!),
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  return switch (state) {
                    UserDirectoryInitial() => Container(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            const Icon(Icons.people_outline_rounded, size: 48, color: Colors.grey),
                            const SizedBox(height: 12),
                            const Text(
                              'Directory Idle',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Tap the button below to fetch users via Repository',
                              style: TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () => _cubit.loadUsers(),
                              icon: const Icon(Icons.download_rounded),
                              label: const Text('Load Users via Repository'),
                            ),
                          ],
                        ),
                      ),
                    UserDirectoryLoading(message: final msg) => Container(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            const CircularProgressIndicator(),
                            const SizedBox(height: 14),
                            Text(msg, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                            const SizedBox(height: 4),
                            const Text('Simulating async network roundtrip...',
                                style: TextStyle(color: Colors.grey, fontSize: 11)),
                          ],
                        ),
                      ),
                    UserDirectoryLoaded(users: final users) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '${users.length} Active Profiles',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              const Spacer(),
                              TextButton.icon(
                                onPressed: () => _cubit.loadUsers(),
                                icon: const Icon(Icons.refresh, size: 16),
                                label: const Text('Reload'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          if (users.isEmpty)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.all(24),
                                child: Text('No users in directory. Tap "Add User" below.'),
                              ),
                            )
                          else
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: users.length,
                              separatorBuilder: (_, _) => const Divider(height: 1),
                              itemBuilder: (context, index) {
                                final user = users[index];
                                return ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: theme.colorScheme.primary.withAlpha(40),
                                    foregroundColor: theme.colorScheme.primary,
                                    child: Text(user.avatarLetter,
                                        style: const TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                  title: Text(user.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                                  subtitle: Text('${user.role}\n${user.email}',
                                      style: const TextStyle(fontSize: 12, height: 1.3)),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                                    tooltip: 'Delete user',
                                    onPressed: () => _cubit.deleteUser(user.id),
                                  ),
                                  isThreeLine: true,
                                );
                              },
                            ),
                        ],
                      ),
                    UserDirectoryError(message: final err) => Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.red.withAlpha(20),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.red.withAlpha(60)),
                        ),
                        child: Column(
                          children: [
                            const Icon(Icons.error_outline_rounded, color: Colors.red, size: 40),
                            const SizedBox(height: 10),
                            const Text(
                              'Repository Operation Failed',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.red),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              err,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 12),
                            ),
                            const SizedBox(height: 14),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade700),
                              onPressed: () => _cubit.loadUsers(),
                              icon: const Icon(Icons.replay_rounded, color: Colors.white),
                              label: const Text('Retry Request', style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      ),
                  };
                },
              ),
            ),

            // SECTION 3: Code Architecture Deep Dive
            const SectionHeader(
              title: '3. Architectural Anatomy',
              subtitle: 'How abstract interfaces enforce clean separation between UI and Data.',
              icon: Icons.code_rounded,
            ),
            const CodeSnippetCard(
              title: 'Abstract Repository Contract (Domain)',
              code: '''abstract class UserRepository {
  Future<List<UserProfile>> getUsers();
  Future<UserProfile> addUser({required String name, required String email, required String role});
  Future<void> deleteUser(String id);
}''',
              explanation:
                  'The domain interface defines what data operations exist without knowing anything about Dio, HTTP, or SQLite databases.',
            ),
            const CodeSnippetCard(
              title: 'Repository Implementation (Data Layer)',
              code: '''class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource dataSource;

  UserRepositoryImpl({required this.dataSource});

  @override
  Future<List<UserProfile>> getUsers() async {
    try {
      final rawList = await dataSource.fetchRawUsers();
      return rawList.map((json) => UserProfile.fromJson(json)).toList();
    } catch (e) {
      throw UserOperationException('Failed to retrieve users: \$e');
    }
  }
}''',
              explanation:
                  'The implementation maps raw JSON into domain models and encapsulates low-level protocol errors into clean domain exceptions.',
            ),
            const SizedBox(height: 80), // Fab clearance
          ],
        ),
      ),
    );
  }
}
