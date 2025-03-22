import 'package:rmsh/core/errors/failures.dart';

String mapFailuresToStrings(Failure f) {
  switch (f.runtimeType) {
    case const (EmailRegistrationFailure):
      return 'الرجاء ادخال عنوان بريد الكتروني صحيح';
    case const (CodeErrorFailure):
      return 'الكود خاطئ, حاول مرة اخرى';

    case const (ProfileSubmitionFailure):
      return '';
    case const (EmptyResponseFailure):
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
