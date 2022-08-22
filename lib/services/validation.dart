abstract class StringValidator {
  bool isValid(String value);
}

class NotEmptyStringValidator implements StringValidator {
  @override
  bool isValid(String value) {
    // if (value == null) {
    //   return false;
    // }
    return value.isNotEmpty;
  }
}

class EmailAndPasswordValidators {
  final StringValidator emailValidator = NotEmptyStringValidator();
  final StringValidator passwordValidator = NotEmptyStringValidator();
}
