import 'package:dartz/dartz.dart';
import 'package:rmsh/core/errors/failures.dart';
import 'package:rmsh/domain/classes/profile.dart';
import 'package:rmsh/domain/contracts/profile_repo.dart';

class ProfileUsecases {
  const ProfileUsecases(this._repo);
  final ProfileRepo _repo;

  Future<Either<Failure, bool>> hasProfile() async => await _repo.hasProfile();

  Future<Either<Failure, Profile>> getProfile() async =>
      await _repo.getProfile();

  Future<Either<Failure, Unit>> submitProfile(Profile p, bool isCreate) async =>
      await _repo.submitProfile(p, isCreate);
}
