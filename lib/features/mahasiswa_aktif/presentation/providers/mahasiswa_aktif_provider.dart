import 'dart:async';
import 'package:flutter_riverpod/legacy.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_project/features/mahasiswa_aktif/data/models/mahasiswa_aktif_model.dart';
import 'package:mobile_project/features/mahasiswa_aktif/data/repositories/mahasiswa_aktif_repository.dart';

final mahasiswaAktifRepositoryProvider =
    Provider<MahasiswaAktifRepository>((ref) {
  return MahasiswaAktifRepository(null);
});

class MahasiswaAktifNotifier
    extends StateNotifier<AsyncValue<List<MahasiswaAktifModel>>> {
  final MahasiswaAktifRepository _repository;

  MahasiswaAktifNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadMahasiswaAktifList();
  }

  Future<void> loadMahasiswaAktifList() async {
    state = const AsyncValue.loading();
    try {
      final data = await _repository.getMahasiswaAktifList();
      state = AsyncValue.data(data);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> refresh() async {
    await loadMahasiswaAktifList();
  }
}

final mahasiswaAktifNotifierProvider =
    StateNotifierProvider.autoDispose<MahasiswaAktifNotifier,
        AsyncValue<List<MahasiswaAktifModel>>>((ref) {
  final repository = ref.watch(mahasiswaAktifRepositoryProvider);
  return MahasiswaAktifNotifier(repository);
});