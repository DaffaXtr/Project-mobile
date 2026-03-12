import 'package:mobile_project/features/mahasiswa_aktif/data/models/mahasiswa_aktif_model.dart';

class MahasiswaAktifRepository {
  Future<List<MahasiswaAktifModel>> getMahasiswaAktifList() async {
    await Future.delayed(const Duration(seconds: 1));

    return [
      MahasiswaAktifModel(
        nama: 'Budi Santoso',
        nim: '2021001',
        email: 'budi.santoso@student.example.com',
        jurusan: 'Teknik Informatika',
        angkatan: '2021',
        semester: '6',
        ipk: 3.75,
      ),
      MahasiswaAktifModel(
        nama: 'Siti Rahayu',
        nim: '2021002',
        email: 'siti.rahayu@student.example.com',
        jurusan: 'Teknik Informatika',
        angkatan: '2021',
        semester: '6',
        ipk: 3.90,
      ),
      MahasiswaAktifModel(
        nama: 'Rizky Pratama',
        nim: '2022001',
        email: 'rizky.pratama@student.example.com',
        jurusan: 'Teknik Informatika',
        angkatan: '2022',
        semester: '4',
        ipk: 3.60,
      ),
      MahasiswaAktifModel(
        nama: 'Nur Halimah',
        nim: '2022002',
        email: 'nur.halimah@student.example.com',
        jurusan: 'Teknik Informatika',
        angkatan: '2022',
        semester: '4',
        ipk: 3.82,
      ),
      MahasiswaAktifModel(
        nama: 'Fajar Hidayat',
        nim: '2023001',
        email: 'fajar.hidayat@student.example.com',
        jurusan: 'Teknik Informatika',
        angkatan: '2023',
        semester: '2',
        ipk: 3.50,
      ),
    ];
  }
}