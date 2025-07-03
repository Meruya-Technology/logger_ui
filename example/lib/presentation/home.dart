import 'package:flutter/material.dart';
import 'package:logger_ui/logger_ui.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final loggerUi = LoggerUi();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Logger UI Example')),
      floatingActionButton: StreamBuilder(
        stream: LoggerStreamManager.stream,
        builder: (context, snapshot) {
          return Visibility(
            visible: snapshot.hasData,
            child: FloatingActionButton(
              onPressed: () {},
              child: Badge.count(
                count: snapshot.data ?? 0,
                child: Icon(Icons.notifications),
              ),
            ),
          );
        },
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Log list'),
            subtitle: Text('Explore the log list UI'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoggerListPage()),
              );
            },
          ),
          ListTile(
            title: Text('Info log'),
            subtitle: Text('Create new info log'),
            onTap: () {
              loggerUi.createLog(
                Log(
                  title: 'Info log',
                  type: LogType.info,
                  flags: 'example,ble,lte',
                  createdAt: DateTime.now().millisecondsSinceEpoch,
                ),
              );
            },
          ),
          ListTile(
            title: Text('Warning log'),
            subtitle: Text('Create new warning log'),
            onTap: () {
              loggerUi.createLog(
                Log(
                  title: 'Warning',
                  type: LogType.warning,
                  flags: 'auth,http_call,ble',
                  createdAt: DateTime.now().millisecondsSinceEpoch,
                ),
              );
            },
          ),
          ListTile(
            title: Text('Error log'),
            subtitle: Text('Create new error log'),
            onTap: () {
              loggerUi.createLog(
                Log(
                  title: 'Error',
                  type: LogType.error,
                  flags: 'keypair,lte,ble',
                  createdAt: DateTime.now().millisecondsSinceEpoch,
                ),
              );
            },
          ),
          ListTile(
            title: Text('Success log'),
            subtitle: Text('Create new success log'),
            onTap: () {
              loggerUi.createLog(
                Log(
                  title: 'Success',
                  type: LogType.success,
                  flags: 'http_call,lte,mqtt',
                  createdAt: DateTime.now().millisecondsSinceEpoch,
                ),
              );
            },
          ),
          Divider(),

          ListTile(
            title: Text('Info log with payload'),
            subtitle: Text('Create new info log with list payload'),
            onTap: () {
              loggerUi.createLog(
                Log(
                  title: 'Info log',
                  type: LogType.info,
                  flags: 'example,ble,lte',
                  payloadType: PayloadType.list,
                  payload: [
                    PayloadObject(label: 'key1', value: 'value1'),
                    PayloadObject(label: 'key2', value: 'value2'),
                    PayloadObject(label: 'key3', value: 'value3'),
                  ],
                  createdAt: DateTime.now().millisecondsSinceEpoch,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
