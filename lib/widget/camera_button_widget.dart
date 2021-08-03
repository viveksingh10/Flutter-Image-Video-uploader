import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_video_picker_example/model/media_source.dart';
import 'package:image_video_picker_example/widget/list_tile_widget.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CameraButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ListTileWidget(
        text: 'From Camera',
        icon: Icons.camera_alt,
        onClicked: () => pickCameraMedia(context),
      );

  Future pickCameraMedia(BuildContext context) async {
    final _storage = FirebaseStorage.instance;
    final MediaSource source = ModalRoute.of(context).settings.arguments;

    final getMedia = source == MediaSource.image
        ? ImagePicker().getImage
        : ImagePicker().getVideo;

    final media = await getMedia(source: ImageSource.camera);
    final file = File(media.path);
    if (media != null) {
      var snapshot = await _storage
          .ref()
          .child('folder/imageName')
          .putFile(file)
          .onComplete;
    }
    Navigator.of(context).pop(file);
  }
}
