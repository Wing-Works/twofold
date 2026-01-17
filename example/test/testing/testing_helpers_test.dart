import 'package:test/test.dart';
import 'package:twofold/twofold.dart';

Twofold<int, String> success() => Twofold.success(10);

Twofold<int, String> failure() => Twofold.error('boom');

void main() {
  group('expectSuccess', () {
    test('passes when result is Success', () {
      expectSuccess(success(), (value) {
        expect(value, 10);
      });
    });

    test('throws AssertionError when result is Error', () {
      expect(
        () => expectSuccess(failure(), (_) {}),
        throwsA(isA<AssertionError>()),
      );
    });
  });

  group('expectError', () {
    test('passes when result is Error', () {
      expectError(failure(), (error) {
        expect(error, 'boom');
      });
    });

    test('throws AssertionError when result is Success', () {
      expect(
        () => expectError(success(), (_) {}),
        throwsA(isA<AssertionError>()),
      );
    });
  });
}
