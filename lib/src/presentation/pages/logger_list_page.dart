import 'package:flutter/material.dart';
import 'package:logger_ui/logger_ui.dart';

import '../widgets/logger_list_tile.dart';

class LoggerListPage extends StatefulWidget {
  const LoggerListPage({super.key});

  @override
  State<LoggerListPage> createState() => _LoggerListPageState();
}

class _LoggerListPageState extends State<LoggerListPage> {
  final _loggerUi = LoggerUi();
  Future<List<Log>?>? _logs;
  Future<List<String>?>? _flags;
  final _selectedFlags = <String>[];

  @override
  void initState() {
    retrieveLogs();
    retrieveFlags();
    super.initState();
  }

  void retrieveLogs() {
    setState(() {
      _logs = _loggerUi.retrieveLogs(flags: _selectedFlags.join(','));
    });
  }

  void retrieveFlags() {
    setState(() {
      _flags = _loggerUi.retrieveFlags();
    });
  }

  Future<void> refresh() async {
    retrieveLogs();
    retrieveFlags();
  }

  void changeSelectedFlags(String flag, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedFlags.add(flag);
      } else {
        _selectedFlags.remove(flag);
      }
      retrieveLogs();
    });
  }

  Future<void> readAllLogs(BuildContext context) async {
    final logs = await _logs;
    final ids = logs
        ?.where((log) => !log.isRead)
        .map((log) => log.id!)
        .toList();
    if (ids != null) {
      _loggerUi
          .read(ids)
          ?.then(
            (result) {
              if (result == true && context.mounted) {
                retrieveLogs();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('All notifications marked as read')),
                );
              }
            },
            onError: (error) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'An error occurred when marking logs as read',
                    ),
                  ),
                );
              }
            },
          );
    }
  }

  void deleteLogs(BuildContext context) {
    _loggerUi.clear()?.then(
      (result) {
        if (result) refresh();
      },
      onError: (error) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('An error occurred while deleting logs')),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: SafeArea(
        child: Column(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [filterSection(context), listSection(context)],
        ),
      ),
    );
  }

  PreferredSizeWidget appBar(BuildContext context) {
    return AppBar(
      title: Text('Log list'),
      actions: [
        FutureBuilder(
          future: _logs,
          builder: (context, snapshot) {
            return Visibility(
              visible: snapshot.hasData,
              replacement: SizedBox.shrink(),
              child: IconButton(
                icon: Icon(Icons.mark_email_read),
                onPressed: () {
                  readAllLogs(context);
                },
              ),
            );
          },
        ),
        FutureBuilder(
          future: _logs,
          builder: (context, snapshot) {
            return Visibility(
              visible: snapshot.hasData,
              replacement: SizedBox.shrink(),
              child: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  deleteLogs(context);
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget body(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FutureBuilder(
          future: _flags,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.start,
                    spacing: 8,
                    children: snapshot.data!
                        .map(
                          (flag) => FilterChip(
                            showCheckmark: false,
                            label: Text(flag),
                            selected: _selectedFlags.contains(flag),
                            onSelected: (value) {
                              changeSelectedFlags(flag, value);
                            },
                          ),
                        )
                        .toList(),
                  ),
                ),
              );
            } else {
              return SizedBox.shrink();
            }
          },
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: refresh,
            child: FutureBuilder(
              future: _logs,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.separated(
                    padding: EdgeInsets.all(16),
                    itemCount: snapshot.data?.length ?? 0,
                    separatorBuilder: (context, index) => SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final data = snapshot.data![index];
                      return LoggerListTile(log: data);
                    },
                  );
                } else {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'No logs found',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          'Log some activities to see them here.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget filterSection(BuildContext context) {
    return FutureBuilder(
      future: _flags,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 8,
                alignment: WrapAlignment.start,
                children: snapshot.data!
                    .map(
                      (flag) => FilterChip(
                        showCheckmark: false,
                        label: Text(flag),
                        selected: _selectedFlags.contains(flag),
                        onSelected: (value) {
                          changeSelectedFlags(flag, value);
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
          );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }

  Widget listSection(BuildContext context) {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: refresh,
        child: FutureBuilder(
          future: _logs,
          builder: (context, snapshot) {
            debugPrint('Logs: ${snapshot.data}');
            if (snapshot.hasData) {
              return ListView.separated(
                itemCount: snapshot.data?.length ?? 0,
                separatorBuilder: (context, index) => Divider(height: 0),
                itemBuilder: (context, index) {
                  final data = snapshot.data![index];
                  return LoggerListTile(log: data);
                },
              );
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'No logs found',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      'Log some activities to see them here.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
