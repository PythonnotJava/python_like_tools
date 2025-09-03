import 'dart:collection';

/// A Counter counts hashable elements. Similar to Python's collections.Counter.
/// Elements are stored as keys and their counts as values.
/// Reference: https://docs.python.org/3/library/collections.html#collections.Counter
class Counter<K> extends MapBase<K, int> {
  final Map<K, int> _map = {};

  /// Creates a Counter.
  /// Can initialize from an Iterable of elements or a Map of counts.
  /// If [source] is null, creates an empty Counter.
  Counter([dynamic source]) {
    if (source == null) return;
    if (source is Iterable<K>) {
      updateFromIterable(source);
    } else if (source is Map<K, int>) {
      updateFromMap(source);
    } else {
      throw ArgumentError("Counter expects Iterable<K> or Map<K,int>");
    }
  }

  /// Gets the count of [key]. Returns 0 if key is not present.
  @override
  int operator [](Object? key) => _map[key] ?? 0;

  /// Sets the count of [key] to [value].
  /// If [value] is 0, the key is removed from the counter.
  @override
  void operator []=(K key, int value) {
    if (value == 0) {
      _map.remove(key);
    } else {
      _map[key] = value;
    }
  }

  /// Clears all counts.
  @override
  void clear() => _map.clear();

  /// Returns all keys in the counter.
  @override
  Iterable<K> get keys => _map.keys;

  /// Removes [key] and returns its count, or null if not present.
  @override
  int? remove(Object? key) => _map.remove(key);

  /// Returns the sum of all counts.
  int total() => _map.values.fold(0, (a, b) => a + b);

  /// Returns a list of entries sorted by count, descending.
  /// If [n] is provided, returns only the top [n] entries.
  List<MapEntry<K, int>> mostCommon([int? n]) {
    final sorted = _map.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return n == null ? sorted : sorted.take(n).toList();
  }

  /// Returns an Iterable of elements, repeating each as many times as its count.
  Iterable<K> elements() sync* {
    for (final entry in _map.entries) {
      for (var i = 0; i < entry.value; i++) {
        yield entry.key;
      }
    }
  }

  /// Adds counts from an iterable of elements.
  void updateFromIterable(Iterable<K> iterable) {
    for (final elem in iterable) {
      _map.update(elem, (v) => v + 1, ifAbsent: () => 1);
    }
  }

  /// Adds counts from another map of element counts.
  void updateFromMap(Map<K, int> other) {
    for (final entry in other.entries) {
      _map.update(entry.key, (v) => v + entry.value,
          ifAbsent: () => entry.value);
    }
  }

  /// Subtracts counts from an iterable of elements.
  /// Keys with zero or negative counts are removed.
  void subtract(Iterable<K> iterable) {
    for (final elem in iterable) {
      final newValue = (_map[elem] ?? 0) - 1;
      if (newValue <= 0) {
        _map.remove(elem);
      } else {
        _map[elem] = newValue;
      }
    }
  }

  /// Subtracts counts from another map of element counts.
  /// Keys with zero or negative counts are removed.
  void subtractFromMap(Map<K, int> other) {
    for (final entry in other.entries) {
      final newValue = (_map[entry.key] ?? 0) - entry.value;
      if (newValue <= 0) {
        _map.remove(entry.key);
      } else {
        _map[entry.key] = newValue;
      }
    }
  }

  /// Returns a shallow copy of the Counter.
  Counter<K> copy() => Counter<K>(Map<K, int>.from(_map));

  /// Returns a string representation of the Counter.
  @override
  String toString() => "Counter($_map)";
}
