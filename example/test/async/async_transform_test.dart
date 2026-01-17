import 'package:test/test.dart';
import 'package:twofold/twofold.dart';

Future<Twofold<int, String>> success() async => Twofold.success(5);

Future<Twofold<int, String>> failure() async => Twofold.error('error');

void main() {
  group('mapSuccess', () {
    test('transforms success value', () async {
      final result = await success().mapSuccess((v) => v * 2);
      expect(result.successOrNull, 10);
    });

    test('skips transformation on error', () async {
      final result = await failure().mapSuccess((v) => v * 2);
      expect(result.isError, true);
    });
  });

  group('mapError', () {
    test('transforms error value', () async {
      final result = await failure().mapError((e) => 'wrapped: $e');

      expect(result.errorOrNull, 'wrapped: error');
    });
  });

  group('flatMapSuccess', () {
    test('chains async success', () async {
      final result = await success().flatMapSuccess(
        (v) async => Twofold.success(v.toString()),
      );

      expect(result.successOrNull, '5');
    });

    test('propagates error without calling transform', () async {
      bool called = false;

      final result = await failure().flatMapSuccess((v) async {
        called = true;
        return Twofold.success(v);
      });

      expect(result.isError, true);
      expect(called, false);
    });
  });

  group('when', () {
    test('returns value when handled', () async {
      final value = await success().when(onSuccess: (v) => v + 1);

      expect(value, 6);
    });

    test('returns null when no callback matches', () async {
      final value = await success().when(onError: (_) => 'error');

      expect(value, null);
    });
  });

  group('fallback & swap', () {
    test('getOrElse returns fallback on error', () async {
      final value = await failure().getOrElse(0);
      expect(value, 0);
    });

    test('swap converts error to success', () async {
      final swapped = await failure().swap();
      expect(swapped.isSuccess, true);
      expect(swapped.successOrNull, 'error');
    });
  });
}
