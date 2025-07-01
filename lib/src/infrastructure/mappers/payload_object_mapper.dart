import 'dart:convert';

import 'package:logger_ui/src/domain/entities/payload_object.dart';

class PayloadObjectMapper {
  static List<PayloadObject> toEntity(String string) {
    final Map<String, String?> jsonMap = jsonDecode(string);
    final objects = jsonMap.entries
        .map((entry) => PayloadObject(label: entry.key, value: entry.value))
        .toList();
    return objects;
  }

  static String? toStringJson(List<PayloadObject> entities) {
    Map<String, dynamic> resultMap = {};

    for (var payload in entities) {
      resultMap[payload.label] = payload.value;
    }

    return jsonEncode(resultMap);
  }
}
