/// A double-ended queue (deque) similar to Python's collections.deque.
/// Reference: https://docs.python.org/3/library/collections.html#collections.deque
/// Mixing in some Dart's own style.
class Deque<T> extends Iterable<T> {
  final int? maxlen;
  final List<T> _data = [];

  Deque({Iterable<T> iterable = const [], this.maxlen}) {
    for (var item in iterable) {
      append(item);
    }
  }

  /// Add an element to the right side.
  void append(T value) {
    if (maxlen != null && _data.length >= maxlen!) {
      _data.removeAt(0);
    }
    _data.add(value);
  }

  /// Add an element to the left side.
  void appendleft(T value) {
    if (maxlen != null && _data.length >= maxlen!) {
      _data.removeLast();
    }
    _data.insert(0, value);
  }

  /// Remove and return the rightmost element.
  T pop() {
    if (_data.isEmpty) throw StateError("pop from an empty deque");
    return _data.removeLast();
  }

  /// Remove and return the leftmost element.
  T popleft() {
    if (_data.isEmpty) throw StateError("pop from an empty deque");
    return _data.removeAt(0);
  }

  /// Extend the right side with elements from iterable.
  void extend(Iterable<T> iterable) {
    for (var item in iterable) {
      append(item);
    }
  }

  /// Extend the left side with elements from iterable.
  void extendleft(Iterable<T> iterable) {
    for (var item in iterable) {
      appendleft(item);
    }
  }

  /// Rotate n steps to the right (negative for left).
  void rotate([int n = 1]) {
    final len = _data.length;
    if (len <= 1) return;
    var k = n % len;
    if (k < 0) k += len;
    if (k == 0) return;
    final tail = _data.sublist(len - k);
    _data.removeRange(len - k, len);
    _data.insertAll(0, tail);
  }

  /// Remove all elements.
  void clear() => _data.clear();

  /// Return shallow copy.
  Deque<T> get copy => Deque<T>(iterable: _data, maxlen: maxlen);

  /// Count occurrences of value.
  int count(T value) => _data.where((e) => e == value).length;

  /// Index of value (throws if not found).
  int index(T value, [int start = 0, int? stop]) {
    stop ??= _data.length;
    for (var i = start; i < stop && i < _data.length; i++) {
      if (_data[i] == value) return i;
    }
    return -1;
  }

  /// Remove first occurrence of value.
  void remove(T value) {
    var i = _data.indexOf(value);
    if (i == -1) throw StateError("value not found in deque");
    _data.removeAt(i);
  }

  /// Reverse in place.
  void reverse() => _data.setAll(0, _data.reversed);

  /// Length of deque.
  int get length => _data.length;

  /// Index operator.
  T operator [](int index) => _data[index];
  void operator []=(int index, T value) => _data[index] = value;

  /// Iterator support (required by Iterable).
  @override
  Iterator<T> get iterator => _data.iterator;

  @override
  String toString() => "Deque($_data, maxlen=$maxlen)";
}

