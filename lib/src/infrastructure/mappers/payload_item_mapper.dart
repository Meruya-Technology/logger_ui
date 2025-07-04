import 'dart:convert';

import 'package:logger_ui/src/domain/entities/payload_object.dart';

class PayloadItemMapper {
  static PayloadItem toEntity(Map<String, String?> model) {
    return PayloadItem(label: model['label'] ?? '', value: model['value']);
  }

  static String? toStringJson(List<PayloadItem> entities) {
    Map<String, dynamic> resultMap = {};

    for (var payload in entities) {
      resultMap[payload.label] = payload.value;
    }

    return jsonEncode(resultMap);
  }
}
