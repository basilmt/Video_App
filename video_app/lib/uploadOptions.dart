import 'package:flutter/material.dart';
import 'widget/gallery_button_widget.dart';
import 'widget/camera_button_widget.dart';

class UploadOptions extends StatefulWidget {
  @override
  _UploadOptionsState createState() => _UploadOptionsState();
}

class _UploadOptionsState extends State<UploadOptions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload'),
      ),
      body: ListView(
        children: [
          CameraButtonWidget(),
          GalleryButtonWidget(),
        ],
      ),
    );
  }
}
