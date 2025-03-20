import 'package:flutter/foundation.dart';
import 'package:rmsh/core/constants/constants.dart';
import 'package:rmsh/core/errors/exceptions.dart';
import 'package:rmsh/data/models/user_dto.dart';
import 'package:rmsh/core/services/client_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthRemoteSource {
  Future<bool> logout();
  Future<bool> isLogged();
  Future<bool> register(String email);
  Future<UserDto> verifyCode(String email, String code);
  Future<UserDto> getUser();
  Future<bool> saveUser(UserDto user);
}

class AuthRemoteSourceImpl implements AuthRemoteSource {
  const AuthRemoteSourceImpl(this._storage, this._clientHelper);
  final SharedPreferences _storage;
  final ClientHelper _clientHelper;

  @override
  Future<bool> logout() async {
    return await _storage.clear();
  }

  @override
  Future<bool> isLogged() async {
    if (kDebugMode) {
      print("remoteSource isLogged");
    }
    return await _clientHelper.tokenService.ensureRefreshTokenIsValid();
  }

  @override
  Future<UserDto> getUser() async {
    if (_storage.containsKey('refresh')) {
      final email = _storage.getString('email') as String;
      final refresh = _storage.getString('refresh') as String;
      final issuedAt = DateTime.parse(_storage.getString('issuedAt') as String);
      return UserDto(
        email,
        refresh,
        issuedAt,
      );
    }
    throw EmptyResponseException();
  }

  @override
  Future<bool> saveUser(UserDto user) async {
    await _storage.setString('email', user.email);
    await _storage.setString('refresh', user.refreshToken);
    await _storage.setString('issuedAt', user.issuedAt.toIso8601String());
    return true;
  }

  /// Return value Means `NeedProfile?`
  @override
  Future<bool> register(String email) async {
    final res = await _clientHelper.client.post(
      "$API" "$HTTP_REGISTER",
      data: {'email': email},
    );
    if (kDebugMode) {
      print("register code: ${res.statusCode}");
      print("register body: ${res.data}");
    }
    if (res.statusCode == 201) {
      return true;
    } else if (res.statusCode == 200) {
      return false;
    }
    throw EmailRegistrationException();
  }

  /// {
  ///
  /// > "message": "User registered",
  ///
  /// > "refresh": "t.o.k.e.n",
  ///
  /// > "access": "t.o.k.e.n"
  ///
  /// }
  @override
  Future<UserDto> verifyCode(String email, String code) async {
    final res = await _clientHelper.client.post(
      "$API" "$HTTP_VERIFY_CODE",
      data: {'email': email, 'otp_code': code},
    );

    if (kDebugMode) {
      print("verifyCode code: ${res.statusCode}");
      print("verifyCode body: ${res.data}");
    }
    if (res.statusCode == 201 || res.statusCode == 200) {
      final userDto = UserDto.fromJson(
        Map<String, dynamic>.from(res.data)..addAll({'email': email}),
      );
      await _clientHelper.tokenService
          .setLoginSession(res.data['refresh'], res.data['access']);
      return userDto;
    } else if (res.statusCode == 400) {
      throw CodeErrorException();
    }
    throw Exception();
  }
}
