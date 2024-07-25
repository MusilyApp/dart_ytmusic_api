dynamic traverse(dynamic data, List<String> keys) {
  dynamic again(dynamic data, String key, {bool deadEnd = false}) {
    List<dynamic> res = [];

    if (data is Map && data.containsKey(key)) {
      res.add(data[key]);
      if (deadEnd) return res.length == 1 ? res[0] : res;
    }

    if (data is List) {
      res.addAll(
          data.map((v) => again(v, key)).expand((x) => x is List ? x : [x]));
    } else if (data is Map) {
      res.addAll(data.values
          .map((v) => again(v, key))
          .expand((x) => x is List ? x : [x]));
    }

    return res.length == 1 ? res[0] : res;
  }

  dynamic value = data;
  String? lastKey = keys.isNotEmpty ? keys.last : null;
  for (String key in keys) {
    value = again(value, key, deadEnd: lastKey == key);
  }

  return value;
}

List<dynamic> traverseList(dynamic data, List<String> keys) {
  return [traverse(data, keys)].expand((x) => x is List ? x : [x]).toList();
}

String? traverseString(dynamic data, List<String> keys) {
  final filteredString = traverseList(data, keys);
  if (filteredString.isEmpty) {
    return null;
  }
  return filteredString.first.toString();
}
