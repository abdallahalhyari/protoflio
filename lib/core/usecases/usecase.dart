/// Base contract for synchronous domain use cases.
abstract class UseCase<T, Params> {
  T call(Params params);
}

/// Base contract for asynchronous domain use cases.
abstract class FutureUseCase<T, Params> {
  Future<T> call(Params params);
}

/// Represents a parameterless invocation for use cases.
class NoParams {
  const NoParams();
}
