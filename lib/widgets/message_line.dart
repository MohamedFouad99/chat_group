import 'package:chat_group/constant/constant_color.dart';
import 'package:flutter/material.dart';

class MessageLine extends StatelessWidget {
  const MessageLine({
    super.key,
    this.text,
    this.image,
    required this.isMe,
    required this.sender,
  });
  final String? sender;
  final String? image;
  final String? text;
  final bool isMe;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            '$sender',
            style: TextStyle(fontSize: 12, color: ksecondryColor),
          ),
          Material(
            elevation: 5,
            borderRadius: isMe
                ? const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  )
                : const BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
            color: isMe ? kPrimaryColor : Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              child: text != ""
                  ? Text(
                      '$text ',
                      style: TextStyle(
                          fontSize: 15,
                          color: isMe ? Colors.white : Colors.black45),
                    )
                  : SizedBox(
                      width: MediaQuery.of(context).size.width * .4,
                      child: Image.network('$image')),
            ),
          ),
        ],
      ),
    );
  }
}
