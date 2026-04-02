import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_project/core/widgets/common_widgets.dart';
import 'package:mobile_project/features/dosen/presentation/providers/dosen_provider.dart';
import 'package:mobile_project/features/dosen/data/models/dosen_model.dart';
import 'package:mobile_project/features/dosen/presentation/widgets/dosen_widget.dart';

class DosenPage extends ConsumerWidget {
  const DosenPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dosenState = ref.watch(dosenNotifierProvider);
    final savedUsers = ref.watch(savedUsersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Dosen'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => ref.invalidate(dosenNotifierProvider),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Column(
        children: [
          // — Section1: Data Tersimpan di Local Storage ——
          savedUsers.when(
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
            data: (users) {
              if (users.isEmpty) return const SizedBox.shrink();

              return Container(
                color: Colors.green.shade50,
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.storage_rounded, size: 16, color: Colors.green),
                        const SizedBox(width: 8),
                        const Text(
                          'Data Tersimpan di Local Storage',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final user = users[index];
                          return Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.green.shade100,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.green.shade300),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user['username'] ?? '-',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'ID: ${user['user_id']}',
                                  style: const TextStyle(fontSize: 10),
                                ),
                                const SizedBox(height: 8),
                                GestureDetector(
                                  onTap: () {
                                    ref
                                        .read(dosenNotifierProvider.notifier)
                                        .removeSavedUser(user['user_id'] ?? '');
                                    ref.invalidate(savedUsersProvider);
                                  },
                                  child: Icon(
                                    Icons.close,
                                    size: 14,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 36,
                      child: TextButton.icon(
                        onPressed: () async {
                          await ref
                              .read(dosenNotifierProvider.notifier)
                              .clearSavedUsers();
                          ref.invalidate(savedUsersProvider);
                        },
                        icon: const Icon(Icons.delete_sweep_outlined, size: 16),
                        label: const Text('Hapus Semua'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // — Section Title: Daftar Dosen ——
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Text(
              'Daftar Dosen',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),

          // — Dosen List ——
          Expanded(
            child: dosenState.when(
              loading: () => const LoadingWidget(),
              error: (error, stack) => CustomErrorWidget(
                message: 'Gagal memuat data dosen: ${error.toString()}',
                onRetry: () {
                  ref.refresh(dosenNotifierProvider);
                },
              ),
              data: (dosenList) {
                return DosenListView(
                  dosenList: dosenList,
                  onRefresh: () async {
                    ref.invalidate(dosenNotifierProvider);
                  },
                  useModernCard: true,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DosenListView extends StatelessWidget {
  final List<DosenModel> dosenList;
  final Future<void> Function() onRefresh;
  final bool useModernCard;

  const DosenListView({
    super.key,
    required this.dosenList,
    required this.onRefresh,
    required this.useModernCard,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: dosenList.isEmpty
          ? const Center(child: Text('Tidak ada data dosen'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: dosenList.length,
              itemBuilder: (context, index) {
                final dosen = dosenList[index];

                if (useModernCard) {
                  return _DosenListWithSave(
                    dosen: dosen,
                    onRefresh: onRefresh,
                  );
                }

                return ListTile(
                  title: Text(dosen.name),
                  subtitle: Text(dosen.id.toString()),
                  leading: const Icon(Icons.person),
                );
              },
            ),
    );
  }
}

// — Widget: List dosen dengan tombol save ——
class _DosenListWithSave extends ConsumerWidget {
  final DosenModel dosen;
  final VoidCallback onRefresh;

  const _DosenListWithSave({
    required this.dosen,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ModernDosenCard(
      dosen: dosen,
      onTap: () async {
        await ref
            .read(dosenNotifierProvider.notifier)
            .saveSelectedDosen(dosen);
        // Invalidate to trigger rebuild of savedUsersProvider
        ref.invalidate(savedUsersProvider);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${dosen.name} berhasil disimpan ke local storage'),
            ),
          );
        }
      },
    );
  }
}