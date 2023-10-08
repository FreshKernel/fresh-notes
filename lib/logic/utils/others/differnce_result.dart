import 'package:meta/meta.dart';

@immutable
class ListDifferenceResult<T> {
  const ListDifferenceResult({
    required this.differences,
    required this.commons,
    required this.missingsItems,
  });
  final List<T> differences;
  final List<T> commons;
  final List<T> missingsItems;
}
