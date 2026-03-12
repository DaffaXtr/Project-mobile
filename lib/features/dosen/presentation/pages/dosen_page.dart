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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Dosen'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              ref.invalidate(dosenNotifierProvider);
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: dosenState.when(
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
                  return ModernDosenCard(
                    dosen: dosen,
                  );
                }

                return ListTile(
                  title: Text(dosen.nama),
                  subtitle: Text(dosen.nip),
                  leading: const Icon(Icons.person),
                );
              },
            ),
    );
  }
}