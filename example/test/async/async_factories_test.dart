import 'package:test/test.dart';
import 'package:twofold/twofold.dart';

void main() {
  group('fromCondition', () {
    test('executes success branch only', () async {
      bool successCalled = false;
      bool errorCalled = false;

      final result = await TwofoldFuture.fromCondition(
        true,
        success: () async {
          successCalled = true;
          return 1;
        },
        error: () async {
          errorCalled = true;
          return 'error';
        },
      );

      expect(result.isSuccess, true);
      expect(successCalled, true);
      expect(errorCalled, false);
    });

    test('executes error branch only', () async {
      bool successCalled = false;
      bool errorCalled = false;

      final result = await TwofoldFuture.fromCondition(
        false,
        success: () async {
          successCalled = true;
          return 1;
        },
        error: () async {
          errorCalled = true;
          return 'error';
        },
      );

      expect(result.isError, true);
      expect(successCalled, false);
      expect(errorCalled, true);
    });
  });

  group('tryCatch', () {
    test('returns Success when no exception occurs', () async {
      final result = await TwofoldFuture.tryCatch<int, String>(
        () async => 10,
        onError: (e, _) => 'failed',
      );

      expect(result.isSuccess, true);
      expect(result.successOrNull, 10);
    });

    test('captures synchronous exception', () async {
      final result = await TwofoldFuture.tryCatch<int, String>(
        () async => throw Exception('boom'),
        onError: (e, _) => e.toString(),
      );

      expect(result.isError, true);
    });

    test('captures asynchronous exception', () async {
      final result = await TwofoldFuture.tryCatch<int, String>(() async {
        await Future<void>.delayed(Duration.zero);
        throw StateError('async boom');
      }, onError: (e, _) => e.toString());

      expect(result.isError, true);
      expect(result.errorOrNull, contains('async boom'));
    });
  });
}
