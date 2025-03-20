import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:rmsh/core/errors/failures.dart';
import 'package:rmsh/domain/commands/auth_usecases.dart';
import 'package:rmsh/domain/commands/profile_usecases.dart';

class AuthState with ChangeNotifier {
  AuthState(this._authUsecases, this._profileUsecases);

  final AuthUsecases _authUsecases;
  final ProfileUsecases _profileUsecases;

  bool isLoading = false, isCodeSent = false, proccessDone = false;
  bool? hasExistingProfile;

  Failure? loginCheckFailure;
  Future<bool> isLogged() async {
    final either = await _authUsecases.isLogged();
    final res = either.fold<bool>(
      (failure) {
        loginCheckFailure = failure;
        return false;
      },
      (success) => success,
    );
    return res;
  }

  Future<Either<Failure, bool>> hasProfile() async {
    isLoading = true;
    notifyListeners();

    final either = await _profileUsecases.hasProfile();

    isLoading = false;
    notifyListeners();

    return either;
  }

  Failure? registerFailure;

  void verifyEmail(String email) async {
    isLoading = true;
    notifyListeners();

    final either = await _authUsecases.register(email);
    either.fold(
      (failure) => registerFailure = failure,
      (success) => isCodeSent = true,
    );

    isLoading = false;
    notifyListeners();
  }

  void verifyCode(String email, String code) async {
    isLoading = true;
    notifyListeners();

    final either = await _authUsecases.verifyCode(email, code);
    either.fold(
      (failure) => registerFailure = failure,
      (success) => proccessDone = true,
    );

    isLoading = false;
    notifyListeners();
  }

  void resetFailure() {
    registerFailure = null;
  }

  Future<bool> logout() async {
    isLoading = true;
    notifyListeners();

    final either = await _authUsecases.logout();
    final res = either.fold(
      (l) => false,
      (r) => r,
    );

    isLoading = false;
    notifyListeners();

    return res;
  }
}
