import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:rmsh/core/errors/failures.dart';
import 'package:rmsh/data/sources/auth_remote.dart';
// import 'package:rmsh/data/sources/remote_source.dart';
import 'package:rmsh/domain/contracts/auth_repo.dart';

class AuthRepoImple implements AuthRepo {
  const AuthRepoImple({
    required AuthRemoteSource remoteSource,
    required InternetConnectionChecker internet,
  })  : _remoteSource = remoteSource,
        _internet = internet;
  final AuthRemoteSource _remoteSource;
  final InternetConnectionChecker _internet;
  @override
  Future<Either<Failure, bool>> isLogged() async {
    if (kDebugMode) {
      print('IsLogged');
    }
    if (await _internet.hasConnection) {
      try {
        final res = await _remoteSource.isLogged();
        return Right(res);
      } catch (e) {
        return Left(Failure(e.toString()));
      }
    }
    return const Left(OfflineFaliure());
  }

  @override
  Future<Either<Failure, bool>> register(String email) async {
    if (await _internet.hasConnection) {
      try {
        final res = await _remoteSource.register(email);
        return Right(res);
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
        return Left(Failure(e.toString()));
      }
    }
    return const Left(OfflineFaliure());
  }

  /// {
  ///
  /// >"message": "User registered",
  ///
  /// >"refresh": "t.o.k.e.n",
  ///
  /// >"access": "t.o.k.e.n"
  ///
  /// }
  @override
  Future<Either<Failure, bool>> verifyCode(String email, String code) async {
    if (await _internet.hasConnection) {
      try {
        final res = await _remoteSource.verifyCode(email, code);
        await _remoteSource.saveUser(res);
        return const Right(true);
      } catch (e) {
        return Left(Failure(e.toString()));
      }
    }
    return const Left(OfflineFaliure());
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      return Right(await _remoteSource.logout());
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return const Left(Failure());
    }
  }
}
