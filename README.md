<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

## Logger UI

Logger UI is a tools that can be used to trace sequential proccess that hard to trace with traditional approach, while maintain the debugging proccess inflight.

## Getting started

Before using the Logger UI, you need to know that Logger UI working with 3rd package such as [sqflite](https://pub.dev/packages/sqflite) for the database

## Usage

Initialize the Logger UI, because depend on sqflite. Make sure to initiate the `WidgetsFlutterBinding.ensureInitialized();` first.

```dart
void main() {
  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  LoggerUi().initialize();
}
```

### Writing the log
```dart
// initialize instance
final loggerUi = LoggerUI();

// create log trought the repository
loggerUi.createLog(
    Log(
        title: 'Warning',
        type: LogType.warning,
        flags: 'auth,http_call,ble',
        createdAt: DateTime.now().millisecondsSinceEpoch,
    ),
);
```

### Listening to the event stream for entrypoint / badge
```dart
LoggerStreamManager.stream;
```
Retrieve the stream from LoggerStreamManager singleton, it will send a int data whenever the Log is created. 

### Fields
LogType (enum)
- info
- warning
- success
- error

PayloadType (enum)
- text
- list

Payload
- Text, Self explanatory just write any text to it.
- List, List of `PayloadObject`
    - String label
    - String? value

Flags (String) singular or multiple, separated by comma `,`
example : `http_call,auth,user`


### Accessing the Explorer
Navigate straight to the page
```dart
Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => LoggerListPage()),
);
```

## Additional information

Feel free to contribute, straight away to the [logger_ui](https://github.com/Meruya-Technology/logger_ui). 
