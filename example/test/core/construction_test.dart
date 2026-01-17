import 'package:test/test.dart';
import 'package:twofold/twofold.dart';

void main() {
  group('Twofold construction', () {
    test('Twofold.success creates Success', () {
      final Twofold<int, String> result = Twofold.success(10);

      expect(result.isSuccess, true);
      expect(result.successOrNull, 10);
      expect(result.errorOrNull, null);
    });

    test('Twofold.error creates Error', () {
      final Twofold<int, String> result = Twofold.error('fail');

      expect(result.isError, true);
      expect(result.errorOrNull, 'fail');
      expect(result.successOrNull, null);
    });
  });

  group('Twofold.fromCondition', () {
    test('returns Success when condition is true', () {
      var successCalled = false;
      var errorCalled = false;

      final result = Twofold.fromCondition<int, String>(
        true,
        success: () {
          successCalled = true;
          return 1;
        },
        error: () {
          errorCalled = true;
          return 'error';
        },
      );

      expect(result.isSuccess, true);
      expect(successCalled, true);
      expect(errorCalled, false);
    });

    test('returns Error when condition is false', () {
      var successCalled = false;
      var errorCalled = false;

      final result = Twofold.fromCondition<int, String>(
        false,
        success: () {
          successCalled = true;
          return 1;
        },
        error: () {
          errorCalled = true;
          return 'error';
        },
      );

      expect(result.isError, true);
      expect(successCalled, false);
      expect(errorCalled, true);
    });
  });

  group('Twofold.tryCatch', () {
    test('returns Success when no exception is thrown', () {
      final result = Twofold.tryCatch<int, String>(
        () => 5 * 2,
        onError: (e, _) => 'error',
      );

      expect(result.isSuccess, true);
      expect(result.successOrNull, 10);
    });

    test('returns Error when exception is thrown', () {
      final result = Twofold.tryCatch<int, String>(
        () => int.parse('abc'),
        onError: (e, _) => 'invalid number',
      );

      expect(result.isError, true);
      expect(result.errorOrNull, 'invalid number');
    });
  });
}
