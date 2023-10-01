import 'dart:typed_data' show Uint8List;

class SqlValue {

  SqlValue.num(num value) : _value = value;
  SqlValue.string(String? value) : _value = value;
  SqlValue.uint8List(Uint8List value) : _value = value;
  final Object? _value;

  Object? get value => _value;
}

typedef SqlMapData = Map<String, SqlValue?>;

extension SqlMapDataExtensions on SqlMapData {
  Map<String, Object?> toMap() {
    return map((key, value) {
      return MapEntry(key, value?.value);
    });
  }
}
