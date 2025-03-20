import 'package:dartz/dartz.dart';
import 'package:rmsh/core/errors/failures.dart';
import 'package:rmsh/domain/contracts/auth_repo.dart';

class AuthUsecases {
  const AuthUsecases(this._repo);
  final AuthRepo _repo;

  Future<Either<Failure, bool>> isLogged() async => await _repo.isLogged();

  Future<Either<Failure, bool>> register(String email) async =>
      await _repo.register(email);

  Future<Either<Failure, bool>> verifyCode(String email, String code) async =>
      await _repo.verifyCode(email, code);

  Future<Either<Failure, bool>> logout() async => await _repo.logout();
}
