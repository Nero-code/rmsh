import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:rmsh/core/errors/exceptions.dart';
import 'package:rmsh/core/errors/failures.dart';
import 'package:rmsh/data/models/profile_dto.dart';
import 'package:rmsh/data/sources/profile_remote.dart';
import 'package:rmsh/domain/classes/profile.dart';
import 'package:rmsh/domain/contracts/profile_repo.dart';

class ProfileRepoImple implements ProfileRepo {
  const ProfileRepoImple(this._remoteSource, this._internet);

  final ProfileRemoteSource _remoteSource;
  final InternetConnectionChecker _internet;

  @override
  Future<Either<Failure, bool>> hasProfile() async {
    if (await _internet.hasConnection) {
      try {
        await _remoteSource.getProfile();
        return const Right(true);
      } on EmptyResponseException {
        return const Right(false);
      } on ServerDownException {
        return const Left(ServerDownFailure());
      } catch (e) {
        return const Left(Failure());
      }
    }
    return const Left(OfflineFaliure());
  }

  @override
  Future<Either<Failure, Profile>> getProfile() async {
    if (await _internet.hasConnection) {
      try {
        final res = await _remoteSource.getProfile();
        if (kDebugMode) {
          print("Profile is : $res");
        }
        return Right(res);
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
        return const Left(Failure());
      }
    }
    return const Left(OfflineFaliure());
  }

  @override
  Future<Either<Failure, Unit>> submitProfile(Profile p, bool isCreate) async {
    if (await _internet.hasConnection) {
      try {
        _remoteSource.submitProfile(ProfileDto.fromEntity(p), isCreate);
        return const Right(unit);
      } catch (e) {
        return const Left(Failure());
      }
    }
    return const Left(OfflineFaliure());
  }
}
