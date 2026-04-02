import 'package:dio/dio.dart';
import 'package:mobile_project/core/network/dio_client.dart';
import 'package:mobile_project/features/mahasiswa_aktif/data/models/mahasiswa_aktif_model.dart';

class MahasiswaAktifRepository {
  final DioClient _dioClient;

  MahasiswaAktifRepository(DioClient? dioClient)
      : _dioClient = dioClient ?? DioClient();

  Future<List<MahasiswaAktifModel>> getMahasiswaAktifList() async {
    try {
      final Response response = await _dioClient.dio.get('/posts');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        print(data); // Debug: Lihat data yang sudah di-fetch
        return data.map((json) => MahasiswaAktifModel.fromJson(json)).toList();
      } else {
        throw Exception('Gagal memuat data mahasiswa aktif: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('Error: $e');
      throw Exception('Gagal memuat data mahasiswa aktif: ${e.message}');
    }
  }
}