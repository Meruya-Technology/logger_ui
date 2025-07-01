import 'package:flutter/material.dart';
import 'package:logger_ui/logger_ui.dart';

class LoggerListTile extends StatelessWidget {
  final Log log;
  const LoggerListTile({required this.log, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: switch (log.type) {
        LogType.error => Colors.red.shade100,
        LogType.info => Colors.blue.shade100,
        LogType.success => Colors.green.shade100,
        LogType.warning => Colors.yellow.shade100,
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: !log.isRead
            ? BorderSide(
                color: switch (log.type) {
                  LogType.error => Colors.red,
                  LogType.info => Colors.blue,
                  LogType.success => Colors.green,
                  LogType.warning => Colors.yellow,
                },
                width: 1,
              )
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          spacing: 4,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 4,
              children: [
                Icon(
                  switch (log.type) {
                    LogType.error => Icons.error,
                    LogType.info => Icons.info,
                    LogType.success => Icons.check_circle,
                    LogType.warning => Icons.warning,
                  },
                  color: switch (log.type) {
                    LogType.error => Colors.red,
                    LogType.info => Colors.blue,
                    LogType.success => Colors.green,
                    LogType.warning => Colors.yellow,
                  },
                ),
                Text(log.title, style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            Text(
              log.payload ?? 'No payload provided',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
