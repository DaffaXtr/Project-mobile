import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_project/features/mahasiswa/data/models/mahasiswa_model.dart';
import 'package:mobile_project/features/mahasiswa/presentation/providers/mahasiswa_provider.dart';
import 'package:mobile_project/features/mahasiswa/presentation/widgets/mahasiswa_widget.dart';

class MahasiswaPage extends ConsumerWidget {
  const MahasiswaPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mahasiswaState = ref.watch(mahasiswaNotifierProvider);
    final savedUsers = ref.watch(savedUsersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Mahasiswa'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => ref.invalidate(mahasiswaNotifierProvider),
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
                color: Colors.blue.shade50,
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.storage_rounded, size: 16, color: Colors.blue),
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
                              color: Colors.blue.shade100,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.blue.shade300),
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
                                        .read(mahasiswaNotifierProvider.notifier)
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
                              .read(mahasiswaNotifierProvider.notifier)
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

          // — Section Title: Daftar Mahasiswa ——
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Text(
              'Daftar Mahasiswa',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),

          // — Mahasiswa List ——
          Expanded(
            child: mahasiswaState.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('Gagal memuat data: ${error.toString()}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          ref.read(mahasiswaNotifierProvider.notifier).refresh(),
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
              data: (mahasiswaList) => _MahasiswaListView(
                mahasiswaList: mahasiswaList,
                onRefresh: () async =>
                    ref.invalidate(mahasiswaNotifierProvider),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MahasiswaListView extends StatelessWidget {
  final List<MahasiswaModel> mahasiswaList;
  final Future<void> Function() onRefresh;

  const _MahasiswaListView({
    required this.mahasiswaList,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: mahasiswaList.isEmpty
          ? const Center(child: Text('Tidak ada data mahasiswa'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: mahasiswaList.length,
              itemBuilder: (context, index) {
                final gradients = [
                  [const Color(0xFF667eea), const Color(0xFF764ba2)],
                  [const Color(0xFFf093fb), const Color(0xFFf5576c)],
                  [const Color(0xFF4facfe), const Color(0xFF00f2fe)],
                  [const Color(0xFF43e97b), const Color(0xFF38f9d7)],
                ];
                return _MahasiswaCardWithSave(
                  mahasiswa: mahasiswaList[index],
                  gradientColors: gradients[index % gradients.length],
                );
              },
            ),
    );
  }
}

// — Widget: Mahasiswa Card dengan tombol save ——
class _MahasiswaCardWithSave extends ConsumerWidget {
  final MahasiswaModel mahasiswa;
  final List<Color> gradientColors;

  const _MahasiswaCardWithSave({
    required this.mahasiswa,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MahasiswaCard(
      mahasiswa: mahasiswa,
      gradientColors: gradientColors,
      onTap: () async {
        await ref
            .read(mahasiswaNotifierProvider.notifier)
            .saveSelectedMahasiswa(mahasiswa);
        // Invalidate to trigger rebuild of savedUsersProvider
        ref.invalidate(savedUsersProvider);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${mahasiswa.name} berhasil disimpan ke local storage'),
            ),
          );
        }
      },
    );
  }
}