import 'package:dio/dio.dart';
import 'package:mobile_project/core/network/dio_client.dart';
import '../models/mahasiswa_model.dart';

class MahasiswaRepository {
  final DioClient _dioClient;

  MahasiswaRepository(DioClient? dioClient)
      : _dioClient = dioClient ?? DioClient();

  /// Mendapatkan daftar mahasiswa dari API (Comments)
  Future<List<MahasiswaModel>> getMahasiswaList() async {
    try {
      final Response response = await _dioClient.dio.get('/comments');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        print(data); // Debug: Lihat data yang sudah di-fetch
        return data.map((json) => MahasiswaModel.fromJson(json)).toList();
      } else {
        throw Exception('Gagal memuat data mahasiswa: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('Error: $e');
      throw Exception('Gagal memuat data mahasiswa: ${e.message}');
    }
  }
}