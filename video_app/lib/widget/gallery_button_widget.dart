import 'package:flutter/material.dart';
import 'list_tile_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class GalleryButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTileWidget(
      text: "From Gallery",
      icon: Icons.photo,
      onClicked: () => pickGalleryMedia(context),
    );
  }

  Future pickGalleryMedia(BuildContext context) async {
    final media = await ImagePicker().getVideo(source: ImageSource.gallery);
    final file = File(media.path);

    Navigator.of(context).pop(file);
  }
}
