import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:intl/intl.dart';

class VideoView extends StatefulWidget {
  final DocumentSnapshot document;

  VideoView(this.document);

  @override
  _VideoViewState createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.document.get('file'))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.document.get('name')),
      ),
      body: Center(
        child: ListView(
          children: [
            SizedBox(
              width: double.infinity,
              height: 400,
              child: Container(
                alignment: Alignment.center,
                child: _controller.value.initialized
                    ? Stack(children: [
                        Center(
                          child: AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: VideoPlayer(_controller),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(20),
                          alignment: Alignment.bottomCenter,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _controller.value.isPlaying
                                    ? _controller.pause()
                                    : _controller.play();
                              });
                            },
                            child: Icon(
                              _controller.value.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                            ),
                          ),
                        ),
                      ])
                    : Container(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0, left: 16, right: 16),
              child: Text(
                widget.document.get('name'),
                style: TextStyle(fontSize: 30),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                widget.document.get('cat'),
                style: TextStyle(fontSize: 14),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16,right: 16, top: 5),
              child: Text(
                readTimestamp(widget.document.get('time').seconds),
                style: TextStyle(fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 6,bottom: 16),
              child: Row(
                children: [
                  Icon(Icons.location_on),
                  Expanded(
                    child: Text(
                      widget.document.get('loc'),
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  String readTimestamp(int timestamp) {
    var now = DateTime.now();
    var format = DateFormat('HH:mm a');
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    var diff = now.difference(date);
    var time = '';

    if (diff.inSeconds <= 0 ||
        diff.inSeconds > 0 && diff.inMinutes == 0 ||
        diff.inMinutes > 0 && diff.inHours == 0 ||
        diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      if (diff.inDays == 1) {
        time = diff.inDays.toString() + ' DAY AGO';
      } else {
        time = diff.inDays.toString() + ' DAYS AGO';
      }
    } else if (diff.inDays < 30) {
      if (diff.inDays == 7) {
        time = (diff.inDays / 7).floor().toString() + ' WEEK AGO';
      } else {
        time = (diff.inDays / 7).floor().toString() + ' WEEKS AGO';
      }
    } else {
      time = DateFormat('d/M/y').format(date);
    }

    return time;
  }
}
