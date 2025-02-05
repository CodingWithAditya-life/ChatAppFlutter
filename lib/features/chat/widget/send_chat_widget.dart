import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/theme.dart';

class SendChatWidget extends StatelessWidget {
  final String message;
  final DateTime time;

  const SendChatWidget({super.key, required this.message, required this.time});

  @override
  Widget build(BuildContext context) {
    String formattedTime = DateFormat('h:mm a').format(time).toLowerCase();

    return Align(
      alignment: Alignment.topRight,
      child: Container(
        margin: EdgeInsets.only(right: 1, bottom: 10),
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: DefaultColors.senderMessage,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(message, style: Theme.of(context).textTheme.bodyMedium),
            SizedBox(height: 3),
            Text(formattedTime,
                style: TextStyle(color: Colors.grey, fontSize: 12)),
            // Display time
          ],
        ),
      ),
    );
  }
}
