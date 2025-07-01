enum PayloadType {
  text,
  list,
  undefined;

  static PayloadType fromInt(int value) {
    switch (value) {
      case 0:
        return PayloadType.text;
      case 1:
        return PayloadType.list;
      default:
        return PayloadType.text;
    }
  }

  int toInt() {
    switch (this) {
      case PayloadType.text:
        return 0;
      case PayloadType.list:
        return 1;
      default:
        return 0;
    }
  }
}
