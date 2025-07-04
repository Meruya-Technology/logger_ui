import 'package:flutter/material.dart';
import 'package:logger_ui/logger_ui.dart';

import 'labeled_text.dart';

class LoggerListTile extends StatelessWidget {
  final Log log;
  const LoggerListTile({required this.log, super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
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
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    DateTime.fromMillisecondsSinceEpoch(
                      log.createdAt,
                    ).toString(),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final payloadObject =
                    (log.payloads as List<PayloadItem>)[index];
                return LabeledText(
                  label: payloadObject.label,
                  value: payloadObject.value?.toString(),
                );
              },
              separatorBuilder: (context, index) => SizedBox(height: 4),
              itemCount: log.payloads?.length ?? 0,
            ),
          ),
        ],
      ),
    );
  }
}
