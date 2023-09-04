import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class ImageUtil {
  static Future<File?> pickImageFromGallery({
    required CropStyle cropStyle,
    required BuildContext context,
    required String? title,
    int? imageQuality,
  }) async {
    final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery, imageQuality: imageQuality ?? 70);
    if (pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        cropStyle: cropStyle,
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: title,
          toolbarColor: Colors.grey.shade800,
          //toolbarColor: Theme.of(context).primaryColor,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        iosUiSettings: const IOSUiSettings(),
        compressQuality: 70,
      );
      return croppedFile;
    }
    return null;
  }

  static Future<String> uploadProfileImageToStorage(
    String childName,
    Uint8List file,
    bool isPost,
    String uid,
  ) async {
    final FirebaseStorage _storage = FirebaseStorage.instance;
    // creating location to our firebase storage

    Reference ref = _storage.ref().child(childName).child(uid);
    if (isPost) {
      String id = const Uuid().v1();
      ref = ref.child(id);
    }

    // putting in uint8list format -> Upload task like a future but not future
    UploadTask uploadTask = ref.putData(file);

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  static Future<String> uploadStoryImageToStorage(
    String childName,
    Uint8List file,
    bool isPost,
    String storyId,
  ) async {
    final FirebaseStorage _storage = FirebaseStorage.instance;
    // creating location to our firebase storage

    Reference ref = _storage.ref().child(childName).child(storyId);
    if (isPost) {
      String id = const Uuid().v1();
      ref = ref.child(id);
    }

    // putting in uint8list format -> Upload task like a future but not future
    UploadTask uploadTask = ref.putData(file);

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
