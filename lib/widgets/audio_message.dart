import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioMessage extends StatefulWidget {
  final Source audioUrl;

  AudioMessage({Key? key, required this.audioUrl}) : super(key: key);

  @override
  State<AudioMessage> createState() => _AudioMessageState();
}

class _AudioMessageState extends State<AudioMessage> {
  bool played = false;
  AudioPlayer audioPlayer = AudioPlayer();
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        audioPlayer.play(widget.audioUrl);
        played = true;
        setState(() {});
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
                onTap: () {
                  setState(() {
                    if (played) {
                      audioPlayer.pause();
                      played = false;
                    } else {
                      setState(() {
                        audioPlayer.play(widget.audioUrl);
                        played = true;
                      });
                    }
                  });
                },
                child: played
                    ? const Icon(Icons.pause)
                    : const Icon(Icons.play_arrow)),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
