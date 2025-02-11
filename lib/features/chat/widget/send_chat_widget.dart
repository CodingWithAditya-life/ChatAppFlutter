import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/theme.dart';

class SendChatWidget extends StatelessWidget {
  final String message;
  final String? imageUrl;
  final DateTime time;
  final bool isSeen;

  const SendChatWidget(
      {super.key, required this.message, required this.time, this.imageUrl,required this.isSeen});

  @override
  Widget build(BuildContext context) {
    String formattedTime = DateFormat('h:mm a').format(time).toLowerCase();

    return Align(
      alignment: Alignment.topRight,
      child: Container(
        margin: EdgeInsets.only(right: 1, bottom: 10),
        padding: imageUrl == null ? EdgeInsets.symmetric(horizontal: 10, vertical: 7) : EdgeInsets.zero,
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75
        ),
        decoration: BoxDecoration(
          color: imageUrl == null
              ? Color(0xFF7A8194)
              : Color(0xFF3D4354),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl!,
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
              ),
            if (message.isNotEmpty)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(message,
                    style: Theme.of(context).textTheme.bodyMedium),
              ),
            Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(formattedTime,
                      style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
                  SizedBox(width: 3),
                  Icon(
                    Icons.done_all,
                    color: isSeen ? Colors.blue : Colors.grey,
                    size: 14,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
