import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_project/features/mahasiswa_aktif/data/models/mahasiswa_aktif_model.dart';
import 'package:mobile_project/features/mahasiswa_aktif/presentation/providers/mahasiswa_aktif_provider.dart';
import 'package:mobile_project/features/mahasiswa_aktif/presentation/widgets/mahasiswa_aktif_widget.dart';

class MahasiswaAktifPage extends ConsumerWidget {
  const MahasiswaAktifPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Langsung watch provider yang sudah didefinisikan
    final state = ref.watch(mahasiswaAktifNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mahasiswa Aktif'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => ref.invalidate(mahasiswaAktifNotifierProvider),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: state.when(
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
                onPressed: () => ref
                    .read(mahasiswaAktifNotifierProvider.notifier)
                    .refresh(),
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
        data: (list) => _MahasiswaAktifListView(
          list: list,
          onRefresh: () async =>
              ref.invalidate(mahasiswaAktifNotifierProvider),
        ),
      ),
    );
  }
}

class _MahasiswaAktifListView extends StatelessWidget {
  final List<MahasiswaAktifModel> list;
  final Future<void> Function() onRefresh;

  const _MahasiswaAktifListView({required this.list, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: list.isEmpty
          ? const Center(child: Text('Tidak ada data mahasiswa aktif'))
          : Column(
              children: [
                // Summary header
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Mahasiswa Aktif',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${list.length} Mahasiswa',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final gradients = [
                        [const Color(0xFF667eea), const Color(0xFF764ba2)],
                        [const Color(0xFFf093fb), const Color(0xFFf5576c)],
                        [const Color(0xFF4facfe), const Color(0xFF00f2fe)],
                        [const Color(0xFF43e97b), const Color(0xFF38f9d7)],
                      ];
                      return MahasiswaAktifCard(
                        mahasiswaAktif: list[index],
                        gradientColors: gradients[index % gradients.length],
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}