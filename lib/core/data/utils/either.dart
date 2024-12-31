abstract class Either<L, R> {
  Either();

  T fold<T>(T Function(L left) leftFn, T Function(R right) rightFn);
}

// Left class to represent failures
class Left<L, R> extends Either<L, R> {
  final L value;

  Left(this.value);

  @override
  T fold<T>(T Function(L left) leftFn, T Function(R right) rightFn) {
    return leftFn(value);
  }
}

// Right class to represent successes
class Right<L, R> extends Either<L, R> {
  final R value;

  Right(this.value);

  @override
  T fold<T>(T Function(L left) leftFn, T Function(R right) rightFn) {
    return rightFn(value);
  }
}

extension EitherExt<L, R> on Either<L, R> {
  R? getOrNull() => fold((l) => null, (r) => r);

  bool get isLeft => fold((l) => true, (r) => false);

  bool get isRight => fold((l) => false, (r) => true);

  R get getOrThrow => fold((l) => throw l.toString(), (r) => r);
}

// Specialization for void results
typedef VoidEither<L> = Either<L, void>;
