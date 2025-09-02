/// Create an iterator that returns elements starting from the first iterable object until it is exhausted,
/// and then continues to iterate over the next iterable object until all iterable objects are exhausted.
/// This combines multiple data sources into a single iterator.
/// Reference: https://docs.python.org/3/library/itertools.html#itertools.chain
Iterable<T> chain<T>(Iterable<Iterable<T>> iterators) sync* {
  for (var it in iterators) {
    yield* it;
  }
}

/// Combinations is used to generate all possible combinations of a given iterable object.
/// You need to specify the length of the combination. This is C(n, k) in permutations and combinations.
/// C(n, k) represents the number of combinations of k elements from n elements.
/// Reference: https://docs.python.org/3/library/itertools.html#itertools.combinations
Iterable<List<T>> combinations<T>(List<T> iterable, int r) sync* {
  final n = iterable.length;
  if (r > n || r < 0) return;

  final indices = List<int>.generate(r, (i) => i);

  while (true) {
    yield [for (var i in indices) iterable[i]];
    int i;
    for (i = r - 1; i >= 0; i--) {
      if (indices[i] != i + n - r) break;
    }
    if (i < 0) return;
    indices[i]++;
    for (int j = i + 1; j < r; j++) {
      indices[j] = indices[j - 1] + 1;
    }
  }
}

/// Infinite Iterator.
/// Reference: https://docs.python.org/3/library/itertools.html#itertools.count
Iterable<int> count([int start = 0, int step = 1]) sync* {
  var value = start;
  while (true) {
    yield value;
    value += step;
  }
}