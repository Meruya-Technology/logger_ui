import 'package:flutter/material.dart';
import 'package:logger_ui/logger_ui.dart';
import 'package:logger_ui/src/domain/entities/payload_object.dart';
import 'package:logger_ui/src/domain/entities/payload_type.dart';

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
      child: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          childrenPadding: EdgeInsets.zero,
          title: Row(
            spacing: 8,
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: [
                    Text(
                      log.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      DateTime.fromMillisecondsSinceEpoch(
                        log.createdAt,
                      ).toString(),
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          children: [
            Divider(
              height: 1,
              color: switch (log.type) {
                LogType.error => Colors.red,
                LogType.info => Colors.blue,
                LogType.success => Colors.green,
                LogType.warning => Colors.yellow,
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Visibility(
                visible: log.payloadType == PayloadType.text,
                replacement: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final payloadObject =
                        (log.payload as List<PayloadObject>)[index];
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          payloadObject.label,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          payloadObject.value ?? 'null',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(height: 4),
                  itemCount: (log.payload as List<PayloadObject>?)?.length ?? 0,
                ),
                child: Text(
                  log.payload ?? 'No payload provided',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
