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
      body: mahasiswaState.when(
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
          onRefresh: () async => ref.invalidate(mahasiswaNotifierProvider),
        ),
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
                return MahasiswaCard(
                  mahasiswa: mahasiswaList[index],
                  gradientColors: gradients[index % gradients.length],
                );
              },
            ),
    );
  }
}