import 'package:rmsh/core/errors/failures.dart';

String mapFailuresToStrings(Failure f) {
  switch (f.runtimeType) {
    case const (EmailRegistrationFailure):
      return '';
    case const (CodeErrorFailure):
      return '';
    case const (ProfileNotFoundFailure):
      return '';
    case const (ProfileSubmitionFailure):
      return '';
    case const (EmptyResponseFailure):
      return '';
    case const (EndOfFileFailure):
      return '';
    case const (ItemNotFoundFailure):
      return '';
    case const (DuplicateActionFailure):
      return '';
    case const (OfflineFaliure):
      return '';
    case const (ServerDownFailure):
      return '';
    default:
      return '';
  }
}
