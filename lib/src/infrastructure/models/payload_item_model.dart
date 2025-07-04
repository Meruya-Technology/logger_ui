class PayloadItemModel {
  final String label;
  final String? value;

  PayloadItemModel({required this.label, this.value});
  factory PayloadItemModel.fromJson(Map<String, dynamic> json) {
    return PayloadItemModel(
      label: json['label'] as String,
      value: json['value'] as String?,
    );
  }
  Map<String, dynamic> toJson() {
    return {'label': label, 'value': value};
  }
}
