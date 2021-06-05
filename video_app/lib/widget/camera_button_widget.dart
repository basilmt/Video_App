import 'package:flutter/material.dart';
import 'list_tile_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CameraButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTileWidget(
      text: "From Camera",
      icon: Icons.camera_alt,
      onClicked: () => pickCameraMedia(context),
    );
  }

  Future pickCameraMedia(BuildContext context) async {
    final media = await ImagePicker().getVideo(source: ImageSource.camera);
    final file = File(media.path);

    Navigator.of(context).pop(file);
  }
}
