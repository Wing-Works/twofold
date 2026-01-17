import 'package:test/test.dart';
import 'package:twofold/twofold.dart';

void main() {
  group('getOrElse', () {
    test('returns value when Success', () {
      final Twofold<int, String> result = Twofold.success(10);

      final value = result.getOrElse(0);

      expect(value, 10);
    });

    test('returns fallback when Error', () {
      final Twofold<int, String> result = Twofold.error('fail');

      final value = result.getOrElse(0);

      expect(value, 0);
    });
  });

  group('getOrElseGet', () {
    test('does not call fallback when Success', () {
      var called = false;

      int fallback() {
        called = true;
        return 99;
      }

      final Twofold<int, String> result = Twofold.success(5);

      final value = result.getOrElseGet(fallback);

      expect(value, 5);
      expect(called, false);
    });

    test('calls fallback when Error', () {
      var called = false;

      int fallback() {
        called = true;
        return 99;
      }

      final Twofold<int, String> result = Twofold.error('error');

      final value = result.getOrElseGet(fallback);

      expect(value, 99);
      expect(called, true);
    });
  });

  group('swap', () {
    test('converts Success to Error', () {
      final Twofold<int, String> result = Twofold.success(1);

      final swapped = result.swap();

      expect(swapped.isError, true);
      expect(swapped.errorOrNull, 1);
    });

    test('converts Error to Success', () {
      final Twofold<int, String> result = Twofold.error('oops');

      final swapped = result.swap();

      expect(swapped.isSuccess, true);
      expect(swapped.successOrNull, 'oops');
    });
  });
}
