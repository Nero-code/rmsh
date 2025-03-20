import 'package:dartz/dartz.dart';
import 'package:rmsh/core/errors/failures.dart';
import 'package:rmsh/domain/classes/profile.dart';

abstract class ProfileRepo {
  Future<Either<Failure, bool>> hasProfile();
  Future<Either<Failure, Profile>> getProfile();
  Future<Either<Failure, Unit>> submitProfile(Profile p, bool isCreate);
}
