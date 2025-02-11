import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/theme.dart';

class ReceiveChatWidget extends StatelessWidget{
  final String message;
  final String? imageUrl;
  final DateTime time;

  const ReceiveChatWidget({super.key, required this.message, required this.time, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    String formattedTime = DateFormat('h:mm a').format(time).toLowerCase();

    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        margin: EdgeInsets.only(right: 1, bottom: 10),
        padding: imageUrl == null ? EdgeInsets.all(12) : EdgeInsets.zero,
        decoration: BoxDecoration(
          color:imageUrl == null ? Color(0xFF7A8194) : Color(0xFF3D4354),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            if(message.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: Text(message, style: Theme.of(context).textTheme.bodyMedium),
            ),
            Padding(
              padding: EdgeInsets.only(left: 5, bottom: 3, top: 3),
              child: Text(formattedTime,
                  style: TextStyle(color: Colors.grey, fontSize: 12)),
            ),
            // Display time
          ],
        ),
      ),
    );
  }
}
