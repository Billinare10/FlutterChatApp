import 'package:flutter/material.dart';

class ChatMessageOther extends StatelessWidget {
  final int index;
  final Map<String, dynamic> data;
  final bool showAvatar;

  const ChatMessageOther({Key key, this.data, this.index, this.showAvatar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      child: Row(
        children: [
          if (showAvatar)
            CircleAvatar(backgroundImage: NetworkImage(data['image']))
          else
            SizedBox(width: 10),
          Container(
            constraints: BoxConstraints(maxWidth: 300),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(5)),
            child: Column(
              children: [
                Text(
                  '${data['author']} said:',
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontStyle: FontStyle.italic,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(data['value']),
              ],
            ),
          )
        ],
      ),
    );
  }
}
