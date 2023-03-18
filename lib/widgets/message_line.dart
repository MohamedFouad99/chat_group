// ignore_for_file: deprecated_member_use

import 'package:audioplayers/audioplayers.dart';
import 'package:chat_group/constant/constant_color.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'audio_message.dart';

class MessageLine extends StatelessWidget {
  const MessageLine({
    super.key,
    this.text,
    this.image,
    this.pdf,
    this.record,
    required this.isMe,
    required this.isRead,
    required this.sender,
  });
  final String? sender;
  final String? image;
  final String? pdf;
  final String? record;
  final String? text;
  final bool isMe;
  final bool isRead;
  @override
  Widget build(BuildContext context) {
    Source urlRecord = UrlSource(record!);
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
                                child: Image.asset('assets/images/pdf.png'),
                              ))
                          : record != ""
                              ? SizedBox(
                                  width: MediaQuery.of(context).size.width * .5,
                                  height:
                                      MediaQuery.of(context).size.height * .08,
                                  child: AudioMessage(audioUrl: urlRecord),
                                )
                              : const SizedBox(),
            ),
          ),
          isMe
              ? isRead
                  ? Icon(
                      Icons.checklist,
                      color: kPrimaryColor,
                    )
                  : const Icon(
                      Icons.check,
                      size: 15,
                    )
              : const SizedBox(),
        ],
      ),
    );
  }
}
