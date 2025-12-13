import '../lib/python_like_tools.dart';

void main() {
  final m = SliceableMap<String, int>({'a': 1, 'b': 2, 'c': 3, 'd': 4, 'e': 5});

  print('original: $m');

  final s1 = m.slice(0, 3);
  print('slice(0,3): $s1');
  assert(s1.toString() == '{a: 1, b: 2, c: 3}');

  final s2 = m.slice(2);
  print('slice(2): $s2');
  assert(s2.toString() == '{c: 3, d: 4, e: 5}');

  final s3 = m.slice(null, 2);
  print('slice(null,2): $s3');
  assert(s3.toString() == '{a: 1, b: 2}');

  final s4 = m.slice(-10, 2);
  print('slice(-10,2): $s4');
  assert(s4.toString() == '{a: 1, b: 2}');

  final s5 = m.slice(3, 100);
  print('slice(3,100): $s5');
  assert(s5.toString() == '{d: 4, e: 5}');

  final s6 = m.slice(4, 2);
  print('slice(4,2): $s6');
  assert(s6.isEmpty);

  final s7 = m.slice(0, 0);
  print('slice(0,0): $s7');
  assert(s7.isEmpty);

  final s8 = m.slice(0, m.length);
  print('slice(0,length): $s8');
  assert(s8.toString() == m.toString());

  s1['x'] = 100;
  print('after modify slice: $s1');
  print('original unchanged: $m');
  assert(!m.containsKey('x'));

  final sum = s8.values.reduce((a, b) => a + b);
  print('sum of values: $sum');
  assert(sum == 15);

  print('ALL TESTS PASSED');
}
