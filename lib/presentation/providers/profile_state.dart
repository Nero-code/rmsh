import 'package:flutter/material.dart';
import 'package:rmsh/core/errors/failures.dart';
import 'package:rmsh/domain/classes/profile.dart';
import 'package:rmsh/domain/commands/profile_usecases.dart';

class ProfileState with ChangeNotifier {
  ProfileState(this._profileUsecases);
  final ProfileUsecases _profileUsecases;

  Failure? profileError;
  Profile? currentProfile;
  Future<void> hasProfile() async {
    isLoading = true;
    notifyListeners();

    final either = await _profileUsecases.getProfile();
    either.fold(
      (failure) => profileError,
      (success) => currentProfile = success,
    );

    isLoading = false;
    notifyListeners();
  }

  bool isLoading = false;
  Future<void> createProfile(Profile p) async {
    isLoading = true;
    notifyListeners();

    final either = await _profileUsecases.submitProfile(p, true);
    either.fold(
      (failure) => profileError = failure,
      (success) => currentProfile = p,
    );

    isLoading = false;
    notifyListeners();
  }

  Future<void> updateProfile(Profile p) async {
    isLoading = true;
    notifyListeners();

    final either = await _profileUsecases.submitProfile(p, false);
    either.fold(
      (l) => profileError = l,
      (r) => currentProfile = p,
    );

    isLoading = false;
    notifyListeners();
  }

  void resetError() {
    profileError = null;
  }
}
