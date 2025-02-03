import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/theme.dart';

class ReceiveChatWidget extends StatelessWidget{
  final String message;
  final DateTime time;

  const ReceiveChatWidget({super.key, required this.message, required this.time});

  @override
  Widget build(BuildContext context) {
    String formattedTime = DateFormat('h:mm a').format(time).toLowerCase();

    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        margin: EdgeInsets.only(right: 1, bottom: 10),
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: DefaultColors.receiverMessage,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message, style: Theme.of(context).textTheme.bodyMedium),
            Text(formattedTime,
                style: TextStyle(color: Colors.grey, fontSize: 12)),
            // Display time
          ],
        ),
      ),
    );
  }
}
