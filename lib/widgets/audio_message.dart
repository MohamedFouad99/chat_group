// ignore_for_file: must_be_immutable

import 'package:audioplayers/audioplayers.dart';
import 'package:chat_group/widgets/bubble_audio.dart';
import 'package:flutter/material.dart';

// AudioMessage that displays an audio message. The widget takes in a Source
// object for the audio URL, a bool to determine if the message is sent by the user,
// and another bool to determine if the message has been read by the recipient.
// The AudioMessage widget creates a BubbleAudio widget with certain properties
// based on the state of the widget. The state of the widget is managed by
// _AudioMessageState, which is a private class that extends State<AudioMessage>.
// The state class defines methods _changeSeek and _playAudio that control seeking
// and playing of the audio respectively.
// The state class creates an AudioPlayer object to play the audio and sets up
// listeners for changes in the duration and position of the audio, as well as
// completion of the audio playback. The state class also manages the state of
// the widget, such as whether the audio is currently playing, paused, or loading.
class AudioMessage extends StatefulWidget {
  final Source audioUrl;
  final bool isMe;
  final bool isRead;
  AudioPlayer audioPlayer = AudioPlayer();
  Duration duration = const Duration();
  Duration position = const Duration();
  bool isPlaying = false;
  bool isLoading = false;
  bool isPause = false;

  AudioMessage(
      {Key? key,
      required this.audioUrl,
      required this.isMe,
      required this.isRead})
      : super(key: key);

  @override
  State<AudioMessage> createState() => _AudioMessageState();
}

class _AudioMessageState extends State<AudioMessage> {
  bool played = false;
  AudioPlayer audioPlayer = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return BubbleAudio(
      duration: widget.duration.inSeconds.toDouble(),
      position: widget.position.inSeconds.toDouble(),
      isPlaying: widget.isPlaying,
      isLoading: widget.isLoading,
      isPause: widget.isPause,
      onSeekChanged: _changeSeek,
      onPlayPauseButtonClick: _playAudio,
      sent: true,
      isSender: widget.isMe,
      tail: widget.isMe,
      seen: widget.isRead,
      color: Theme.of(context).colorScheme.onSecondary.withOpacity(.3),
    );
  }

  void _changeSeek(double value) {
    setState(() {
      audioPlayer.seek(Duration(seconds: value.toInt()));
    });
  }

  void _playAudio() async {
    final url = widget.audioUrl;
    if (widget.isPause) {
      await audioPlayer.resume();
      setState(() {
        widget.isPlaying = true;
        widget.isPause = false;
      });
    } else if (widget.isPlaying) {
      await audioPlayer.pause();
      setState(() {
        widget.isPlaying = false;
        widget.isPause = true;
      });
    } else {
      setState(() {
        widget.isLoading = true;
      });
      await audioPlayer.play(url);
      setState(() {
        widget.isPlaying = true;
      });
    }

    audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() {
        widget.duration = d;
        widget.isLoading = false;
      });
    });

    audioPlayer.onPositionChanged.listen((Duration p) {
      setState(() {
        widget.position = p;
      });
    });
    audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        widget.isPlaying = false;
        widget.duration = const Duration();
        widget.position = const Duration();
      });
    });
  }
}
