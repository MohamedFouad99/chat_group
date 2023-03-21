// ignore_for_file: deprecated_member_use

import 'package:audioplayers/audioplayers.dart';
import 'package:chat_bubbles/chat_bubbles.dart';

import 'package:chat_group/constant/constant_color.dart';
import 'package:chat_group/widgets/bubble_text.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'audio_message.dart';
import 'bubble_image.dart';

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
    this.time,
    this.date,
    this.lastDay,
  });
  final String? sender;
  final String? image;
  final String? pdf;
  final String? record;
  final String? text;
  final bool isMe;
  final bool isRead;
  final String? time;
  final DateTime? date;
  final DateTime? lastDay;

  @override
  Widget build(BuildContext context) {
    Source urlRecord = UrlSource(record!);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Center(
            child: lastDay != null
                ? DateChip(
                    date: lastDay!,
                  )
                : const SizedBox(),
          ),
          !isMe
              ? Text(
                  '$sender',
                  style: TextStyle(fontSize: 12, color: ksecondryColor),
                )
              : const SizedBox(),
          text != ""
              ? BubbleText(
                  text: '$text ',
                  color: isMe ? kPrimaryColor : Colors.white,
                  isSender: isMe,
                  seen: isRead,
                  tail: isMe,
                  sent: true,
                  textStyle: TextStyle(
                      fontSize: 16, color: isMe ? Colors.white : Colors.black),
                )
              : image != ""
                  ? SizedBox(
                      child: BubbleImage(
                        image: Image.network('$image'),
                        color: isMe ? kPrimaryColor : Colors.white,
                        isSender: isMe,
                        seen: isRead,
                        tail: isMe,
                        sent: true,
                        onTap: () async {
                          if (await canLaunch(image!)) {
                            await launch(image!);
                          }
                        },
                      ),
                    )
                  : pdf != ""
                      ? SizedBox(
                          width: MediaQuery.of(context).size.width * .2,
                          height: MediaQuery.of(context).size.height * .1,
                          child: BubbleImage(
                            image: Image.asset('assets/images/pdf.png'),
                            color: isMe ? kPrimaryColor : Colors.white,
                            isSender: isMe,
                            seen: isRead,
                            tail: isMe,
                            sent: true,
                            onTap: () async {
                              if (await canLaunch(pdf!)) {
                                await launch(pdf!);
                              }
                            },
                          ),
                        )
                      : record != ""
                          ? SizedBox(
                              height: MediaQuery.of(context).size.height * .1,
                              child: AudioMessage(
                                audioUrl: urlRecord,
                                isMe: isMe,
                                isRead: isRead,
                              ),
                            )
                          : const SizedBox(),
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Row(
              mainAxisAlignment:
                  isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                Text(
                  '$time',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          Center(
            child: date != null
                ? DateChip(
                    date: date!,
                  )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }
}
