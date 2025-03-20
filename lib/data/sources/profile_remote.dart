import 'package:rmsh/core/constants/constants.dart';
import 'package:rmsh/data/models/profile_dto.dart';
import 'package:rmsh/core/services/client_helper.dart';

abstract class ProfileRemoteSource {
  //  PROFILE
  // Future<bool> hasProfile();
  Future<ProfileDto> getProfile();
  Future<void> submitProfile(ProfileDto p, bool isCreate);
}

class ProfileRemoteSourceImpl implements ProfileRemoteSource {
  const ProfileRemoteSourceImpl({required ClientHelper clientHelper})
      : _clientHelper = clientHelper;
  final ClientHelper _clientHelper;

  @override
  Future<ProfileDto> getProfile() async {
    print("getProfile");
    return await _clientHelper.getHandler(
      HTTP_PROFILE,
      (json) => ProfileDto.fromJson(json),
    );
  }

  @override
  Future<void> submitProfile(ProfileDto p, bool isCreate) async {
    print("PROFILE IS CREATE => $isCreate");
    if (isCreate) {
      await _clientHelper.postHandler(HTTP_PROFILE, p.toJson());
    } else {
      await _clientHelper.putHandler(HTTP_PROFILE, p.toJson());
    }
  }

  // @override
  // Future<bool> hasProfile() async {}
}
