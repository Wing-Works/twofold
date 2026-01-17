import 'package:test/test.dart';
import 'package:twofold/twofold.dart';

void main() {
  group('mapSuccess', () {
    test('transforms value when Success', () {
      final Twofold<int, String> result = Twofold.success(10);

      final transformed = result.mapSuccess((v) => v * 2);

      expect(transformed.isSuccess, true);
      expect(transformed.successOrNull, 20);
    });

    test('preserves error when Error', () {
      final Twofold<int, String> result = Twofold.error('fail');

      final transformed = result.mapSuccess((v) => v * 2);

      expect(transformed.isError, true);
      expect(transformed.errorOrNull, 'fail');
    });
  });

  group('mapError', () {
    test('transforms error when Error', () {
      final Twofold<int, String> result = Twofold.error('404');

      final transformed = result.mapError((e) => 'Error $e');

      expect(transformed.isError, true);
      expect(transformed.errorOrNull, 'Error 404');
    });

    test('preserves success when Success', () {
      final Twofold<int, String> result = Twofold.success(5);

      final transformed = result.mapError((e) => 'Error $e');

      expect(transformed.isSuccess, true);
      expect(transformed.successOrNull, 5);
    });
  });

  group('flatMapSuccess', () {
    Twofold<int, String> parse(String input) {
      final parsed = int.tryParse(input);
      return parsed != null
          ? Twofold.success(parsed)
          : Twofold.error('invalid');
    }

    test('chains operation when Success', () {
      final Twofold<String, String> result = Twofold.success('10');

      final chained = result.flatMapSuccess(parse);

      expect(chained.isSuccess, true);
      expect(chained.successOrNull, 10);
    });

    test('skips chaining when Error', () {
      final Twofold<String, String> result = Twofold.error('network');

      final chained = result.flatMapSuccess(parse);

      expect(chained.isError, true);
      expect(chained.errorOrNull, 'network');
    });
  });
}
