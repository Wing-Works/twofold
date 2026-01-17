import 'package:test/test.dart';
import 'package:twofold/twofold.dart';

void main() {
  group('when – handling both states', () {
    test('executes onSuccess for Success', () {
      final Twofold<int, String> result = Twofold.success(10);

      final output = result.when<String>(
        onSuccess: (value) => 'success $value',
        onError: (err) => 'error $err',
      );

      expect(output, 'success 10');
    });

    test('executes onError for Error', () {
      final Twofold<int, String> result = Twofold.error('failed');

      final output = result.when<String>(
        onSuccess: (value) => 'success $value',
        onError: (err) => 'error $err',
      );

      expect(output, 'error failed');
    });
  });

  group('when – side effects', () {
    test('returns null when used only for side effects', () {
      final Twofold<int, String> result = Twofold.success(1);

      final value = result.when(
        onSuccess: (value) {
          // side effect
        },
      );

      expect(value, null);
    });
  });

  group('when – partial handling', () {
    test('returns null when success is unhandled', () {
      final Twofold<int, String> result = Twofold.success(5);

      final value = result.when<String>(onError: (err) => 'error');

      expect(value, null);
    });

    test('returns null when error is unhandled', () {
      final Twofold<int, String> result = Twofold.error('oops');

      final value = result.when<String>(onSuccess: (value) => 'success');

      expect(value, null);
    });
  });

  group('when – no callbacks', () {
    test('returns null when no callbacks are provided', () {
      final Twofold<int, String> result = Twofold.success(100);

      final value = result.when();

      expect(value, null);
    });
  });
}
