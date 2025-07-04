import 'dart:convert';

import 'package:logger_ui/src/domain/entities/payload_object.dart';

class PayloadItemMapper {
  static List<PayloadItem> toListEntity(Map<String, dynamic> model) {
    final result = model.entries.map(
      (entry) => PayloadItem(label: entry.key, value: entry.value),
    );
    return result.toList();
  }

  static String? toStringJson(List<PayloadItem> entities) {
    Map<String, dynamic> resultMap = {};

    for (var payload in entities) {
      resultMap[payload.label] = payload.value;
    }

    return jsonEncode(resultMap);
  }
}
