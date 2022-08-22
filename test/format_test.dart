import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:time_tracker_flutter/home/job_entries/format.dart';

void main() {
  group('Hours', () {
    test('positive', () {
      expect(Format.hours(10), '10h');
    });
    test('negative', () {
      expect(Format.hours(-10), '0h');
    });
    test('zero', () {
      expect(Format.hours(0), '0h');
    });
    test('decimal', () {
      expect(Format.hours(5.5), '5.5h');
    });
  });
  // Use setUp to set Date Locale to en_GB instead of US
  group('Date - GB Locale', () {
    setUp(() async {
      Intl.defaultLocale = 'en_GB';
      await initializeDateFormatting(Intl.defaultLocale!);
    });
    test('2020-08-22', () {
      expect(Format.date(DateTime(2020, 8, 22)), '22 Aug 2020');
    });
  });

  /// Can Use any locale AR-> Arabic IT->Italy

  group('DayOfWeek - AR Locale', () {
    setUp(() async {
      Intl.defaultLocale = 'ar_AR';
      await initializeDateFormatting(Intl.defaultLocale!);
    });
    test('الأحد', () {
      expect(Format.dayOfWeek(DateTime(2021, 8, 22)), 'الأحد');
    });
  });
  group('DayOfWeek - IT Locale', () {
    setUp(() async {
      Intl.defaultLocale = 'it_IT';
      await initializeDateFormatting(Intl.defaultLocale!);
    });
    test('Domenica', () {
      expect(Format.dayOfWeek(DateTime(2021, 8, 22)), 'dom');
    });
  });
  group('Currency - US locale', () {
    setUp(() {
      Intl.defaultLocale = 'en_us';
    });
    test('positive', () {
      expect(Format.currency(10), '\$10');
    });
    test('negative', () {
      expect(Format.currency(-10), '-\$10');
    });
    test('zero', () {
      expect(Format.currency(0), '');
    });
    // 6 not 5.5 because ---Integer final formatter = NumberFormat.simpleCurrency(decimalDigits: 0);
    test('decimal', () {
      expect(Format.currency(5.5), '\$6');
    });
  });
}
