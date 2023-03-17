// ignore_for_file: deprecated_member_use

import 'package:chat_group/constant/constant_color.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MessageLine extends StatelessWidget {
  const MessageLine({
    super.key,
    this.text,
    this.image,
    this.pdf,
    this.record,
    required this.isMe,
    required this.sender,
  });
  final String? sender;
  final String? image;
  final String? pdf;
  final String? record;
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
                  : image != ""
                      ? SizedBox(
                          width: MediaQuery.of(context).size.width * .4,
                          child: InkWell(
                            onTap: () async {
                              if (await canLaunch(image!)) {
                                await launch(image!);
                              }
                            },
                            child: Image.network('$image'),
                          ),
                        )
                      : pdf != ""
                          ? SizedBox(
                              width: MediaQuery.of(context).size.width * .2,
                              height: MediaQuery.of(context).size.height * .1,
                              child: InkWell(
                                  onTap: () async {
                                    debugPrint(pdf);
                                    if (await canLaunch(pdf!)) {
                                      await launch(pdf!);
                                    }
                                  },
                                  child: Image.asset('assets/images/pdf.png')),
                            )
                          : record != ""
                              ? SizedBox(
                                  width: MediaQuery.of(context).size.width * .2,
                                  height:
                                      MediaQuery.of(context).size.height * .1,
                                  child: InkWell(
                                      onTap: () async {
                                        if (await canLaunch(record!)) {
                                          await launch(record!);
                                        }
                                      },
                                      child: Icon(Icons.record_voice_over)),
                                )
                              : const SizedBox(),
            ),
          ),
        ],
      ),
    );
  }
}
