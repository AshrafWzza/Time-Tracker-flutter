import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker_flutter/services/validation.dart';

void main() {
  test('non empty string', () {
    final validation = NotEmptyStringValidator();
    expect(validation.isValid('test'), true);
  });
  test('empty string', () {
    final validation = NotEmptyStringValidator();
    expect(validation.isValid(''), false);
  });
  //no need to check null because of Null Safety
  /* test('null', () {
    final validation = NotEmptyStringValidator();
    expect(validation.isValid(null), false);
  });*/
}
