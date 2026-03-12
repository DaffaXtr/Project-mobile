import 'package:mobile_project/features/profile/data/models/profile_model.dart';

class ProfileRepository {
  Future<ProfileModel> getProfile() async {
    await Future.delayed(const Duration(seconds: 1));

    return ProfileModel(
      nama: 'Admin D4TI',
      nip: '198001012010011001',
      email: 'admin.d4ti@example.com',
      jabatan: 'Administrator',
      unitKerja: 'Program Studi D4 Teknik Informatika',
      noTelp: '08123456789',
    );
  }
}