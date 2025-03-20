import 'package:dartz/dartz.dart';
import 'package:rmsh/core/errors/failures.dart';

abstract class AuthRepo {
  Future<Either<Failure, bool>> isLogged();
  Future<Either<Failure, bool>> register(String email);
  Future<Either<Failure, bool>> verifyCode(String email, String code);
  Future<Either<Failure, bool>> logout();
}
