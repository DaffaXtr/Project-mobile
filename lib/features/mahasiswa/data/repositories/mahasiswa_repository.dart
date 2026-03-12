import '../models/mahasiswa_model.dart';

class MahasiswaRepository {
  /// Mendapatkan daftar mahasiswa
  Future<List<MahasiswaModel>> getMahasiswaList() async {
    // Simulasi network delay
    await Future.delayed(const Duration(seconds: 1));

    // Data dummy mahasiswa
    return [
      MahasiswaModel(
        nama: 'Budi Santoso',
        nim: '2021001',
        email: 'budi.santoso@student.example.com',
        jurusan: 'Teknik Informatika',
        angkatan: '2021',
        status: 'Aktif',
      ),
      MahasiswaModel(
        nama: 'Siti Rahayu',
        nim: '2021002',
        email: 'siti.rahayu@student.example.com',
        jurusan: 'Teknik Informatika',
        angkatan: '2021',
        status: 'Aktif',
      ),
      MahasiswaModel(
        nama: 'Ahmad Fauzi',
        nim: '2020001',
        email: 'ahmad.fauzi@student.example.com',
        jurusan: 'Teknik Informatika',
        angkatan: '2020',
        status: 'Aktif',
      ),
      MahasiswaModel(
        nama: 'Dewi Putri',
        nim: '2020002',
        email: 'dewi.putri@student.example.com',
        jurusan: 'Teknik Informatika',
        angkatan: '2020',
        status: 'Lulus',
      ),
      MahasiswaModel(
        nama: 'Rizky Pratama',
        nim: '2022001',
        email: 'rizky.pratama@student.example.com',
        jurusan: 'Teknik Informatika',
        angkatan: '2022',
        status: 'Aktif',
      ),
      MahasiswaModel(
        nama: 'Nur Halimah',
        nim: '2022002',
        email: 'nur.halimah@student.example.com',
        jurusan: 'Teknik Informatika',
        angkatan: '2022',
        status: 'Aktif',
      ),
    ];
  }
}