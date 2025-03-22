// ignore: depend_on_referenced_packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

class Failure {
  const Failure([this.msg]);
  final String? msg;
}

class OfflineFaliure extends Failure {
  const OfflineFaliure([super.msg]);
}

class ServerDownFailure extends Failure {
  const ServerDownFailure([super.msg]);
}

//  AUTH FAILURES
class EmailRegistrationFailure extends Failure {
  const EmailRegistrationFailure([super.msg]);
}

class CodeErrorFailure extends Failure {
  const CodeErrorFailure([super.msg]);
}

//  PROFILE FAILURES
class ProfileNotFoundFailure extends Failure {
  const ProfileNotFoundFailure([super.msg]);
}

class ProfileSubmitionFailure extends Failure {
  const ProfileSubmitionFailure([super.msg]);
}

class UserNotFoundFailure extends Failure {
  const UserNotFoundFailure([super.msg]);
}

//  DATA FAILURES
class EmptyResponseFailure extends Failure {
  const EmptyResponseFailure([super.msg]);
}

class ItemNotFoundFailure extends Failure {
  const ItemNotFoundFailure([super.msg]);
}

class SessionGenerationFailure extends Failure {
  const SessionGenerationFailure([super.msg]);
}

class DuplicateActionFailure extends Failure {
  const DuplicateActionFailure([super.msg]);
}

class CouponNotValidFailure extends Failure {
  const CouponNotValidFailure([super.msg]);
}

@freezed
abstract class AuthFailures with _$AuthFailures {
  const factory AuthFailures.emailNotValid() = _EmailNotValidFailure;
  const factory AuthFailures.codeNotValid() = _CodeNotValid;
  const factory AuthFailures.unautherticated() = _UnAuthenticated;
  // const factory AuthFailures.offline() = _Offine;
}

void a() {
  const a = AuthFailures.emailNotValid();

  a.when(
    emailNotValid: () {},
    codeNotValid: () {},
    unautherticated: () {},
  );
  a.maybeWhen(orElse: () {});

  a.map(
    emailNotValid: (f) {},
    codeNotValid: (f) {},
    unautherticated: (f) {},
  );
  a.maybeMap(
    orElse: () {},
  );
}
