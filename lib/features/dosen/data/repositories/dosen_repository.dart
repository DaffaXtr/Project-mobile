import 'package:dio/dio.dart';
import 'package:mobile_project/core/network/dio_client.dart';
import '/features/dosen/data/models/dosen_model.dart';

class DosenRepository {
  final DioClient _dioClient;

  DosenRepository(DioClient? dioClient)
      : _dioClient = dioClient ?? DioClient();

  /// Get data daftar dosen
  Future<List<DosenModel>> getDosenList() async {
    try {
      final Response response = await _dioClient.dio.get('/users');
      final List<dynamic> data = response.data;
      return data.map((json) => DosenModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception(
        'Gagal memuat data dosen: ${e.response?.statusCode} - ${e.message}',
      );
    }
  }
}