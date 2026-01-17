import 'package:test/test.dart';
import 'package:twofold/twofold.dart';

void main() {
  group('State inspection (isSuccess / isError)', () {
    test('reflects Success state correctly', () {
      final Twofold<int, String> result = Twofold.success(10);

      expect(result.isSuccess, true);
      expect(result.isError, false);
    });

    test('reflects Error state correctly', () {
      final Twofold<int, String> result = Twofold.error('failed');

      expect(result.isSuccess, false);
      expect(result.isError, true);
    });
  });

  group('Safe accessors (successOrNull / errorOrNull)', () {
    test('successOrNull returns value for Success and null for Error', () {
      final Twofold<int, String> success = Twofold.success(5);
      final Twofold<int, String> error = Twofold.error('oops');

      expect(success.successOrNull, 5);
      expect(error.successOrNull, null);
    });

    test('errorOrNull returns value for Error and null for Success', () {
      final Twofold<int, String> success = Twofold.success(5);
      final Twofold<int, String> error = Twofold.error('oops');

      expect(success.errorOrNull, null);
      expect(error.errorOrNull, 'oops');
    });
  });

  group('Unsafe accessors (successUnsafe / errorUnsafe)', () {
    test('successUnsafe returns value when state is Success', () {
      final Twofold<int, String> result = Twofold.success(42);

      expect(result.successUnsafe, 42);
    });

    test('successUnsafe throws StateError when state is Error', () {
      final Twofold<int, String> result = Twofold.error('boom');

      expect(() => result.successUnsafe, throwsA(isA<StateError>()));
    });

    test('errorUnsafe returns value when state is Error', () {
      final Twofold<int, String> result = Twofold.error('invalid');

      expect(result.errorUnsafe, 'invalid');
    });

    test('errorUnsafe throws StateError when state is Success', () {
      final Twofold<int, String> result = Twofold.success(1);

      expect(() => result.errorUnsafe, throwsA(isA<StateError>()));
    });
  });
}
