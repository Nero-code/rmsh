import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rmsh/core/constants/constants.dart';
import 'package:rmsh/data/models/user_dto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenService {
  TokenService({required SharedPreferences storage, required Dio client})
      : _client = client,
        _storage = storage;

  late final Dio _client;
  final SharedPreferences _storage;
  // late String? _refreshToken;
  Session? _session;

  Future<Session?> get session async {
    print("getting Session...");
    await _createSession();
    return _session;
  }

  // bool get isLoggedIn => _refreshToken != null;
  // void setToken(String token) {
  //   _refreshToken = token;
  // }

  Future<void> setLoginSession(String token, String access) async {
    _session = Session(accessToken: access, createdAt: DateTime.now());
    print("setLoginSession => ${_session != null}");
  }

  Future<bool> _createSession() async {
    print("createSession");
    if (!_storage.containsKey('refresh')) return false;

    print("createSession => found a token");
    print("createSession => session hasExpired(${_session?.hasExpired})");

    final refreshToken = _storage.getString('refresh') as String;
    if (_session == null || _session!.hasExpired) {
      try {
        final res = await _client.post(
          "$API$HTTP_ACCESS_TOKEN",
          data: {'refresh': refreshToken},
        );
        print("result Code : ${res.statusCode}");
        print("result body : ${res.data}");
        if (res.statusCode == 200 || res.statusCode == 201) {
          _session = Session(
            accessToken: res.data['access'],
            createdAt: DateTime.now(),
          );
          print("createSession => New Session Available (Done)!");
          return true;
        }
        return false;
      } catch (e) {
        print("createSession => Error!");
        print(e);
        return false;
      }
    }
    return true;
  }

  Future<bool> ensureRefreshTokenIsValid() async {
    print("ensureTokenIsValid");
    // if no token, then use is not logged in
    if (!_storage.containsKey('refresh')) return false;
    print("ensureTokenIsValid => found a token");
    final refreshToken = _storage.getString('refresh') as String;
    final issuedAt = DateTime.parse(_storage.getString('issuedAt') as String);

    //  if token time-to-live < 15 days then it's up-to-date
    if (issuedAt.difference(DateTime.now()).inDays < 15) return true;
    if (issuedAt.difference(DateTime.now()).inDays > 30) {
      _storage.clear();
      return false;
    }
    if (_session == null) return true;

    try {
      final res = await _client.post("$API" "$HTTP_REFRESH_TOKEN",
          options: Options(
              headers: {'Authorization': "Bearer ${_session!.accessToken}"}),
          data: {
            "refresh": refreshToken,
            "device_token": await FirebaseMessaging.instance.getToken()
          });
      if (res.statusCode == 200 || res.statusCode == 201) {
        final userDto = UserDto.fromJson(res.data);
        await _storage.setString('refresh', userDto.refreshToken);
        await _storage.setString(
            'issuedAt', userDto.issuedAt.toIso8601String());
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}

class Session {
  const Session({required String accessToken, required DateTime createdAt})
      : _createdAt = createdAt,
        _accessToken = accessToken;
  final String _accessToken;
  final DateTime _createdAt;

  String get accessToken => _accessToken;

  bool get hasExpired => DateTime.now().difference(_createdAt).inHours > 20;
}
