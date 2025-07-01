import 'dart:async';
import 'dart:isolate';

class LoggerStreamManager {
  LoggerStreamManager._internal();

  static final LoggerStreamManager _instance = LoggerStreamManager._internal();

  factory LoggerStreamManager() {
    return _instance;
  }

  static final _streamController = StreamController<int>.broadcast();

  static Stream<int> get stream => _streamController.stream;

  static Isolate? _isolate;

  static ReceivePort? _receivePort;

  static Future<void> startIsolate() async {
    _receivePort = ReceivePort();

    _isolate = await Isolate.spawn(isolateFunction, _receivePort!.sendPort);

    // Listen to data coming from the isolate
    _receivePort!.listen((data) {
      _streamController.sink.add(data);
    });
  }

  static void stopIsolate() {
    _isolate?.kill(priority: Isolate.immediate);
    _isolate = null;
    _receivePort?.close();
  }

  static void dispose() {
    stopIsolate();
    _streamController.close();
  }

  // This function will be run in a separate isolate.
  static void isolateFunction(SendPort sendPort) {
    // Forward stream events to the SendPort
    _streamController.stream.listen((data) {
      sendPort.send(data);
    });

    // Emit data periodically (e.g., every second)
    Timer.periodic(Duration(seconds: 1), (timer) {
      // Send random numbers as example data
      _streamController.add(DateTime.now().millisecondsSinceEpoch % 100);
    });
  }

  static void sendData(int data) {
    _streamController.add(data);
  }
}
