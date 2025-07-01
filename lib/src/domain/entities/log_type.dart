enum LogType {
  info,
  success,
  error,
  warning;

  static LogType fromInt(int value) {
    switch (value) {
      case 0:
        return info;
      case 1:
        return success;
      case 3:
        return error;
      case 4:
        return warning;
      default:
        return info;
    }
  }

  int get toInt {
    switch (this) {
      case info:
        return 0;
      case success:
        return 1;
      case error:
        return 3;
      case warning:
        return 4;
    }
  }
}
