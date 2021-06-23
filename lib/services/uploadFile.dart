import 'dart:io';

import 'package:autorization_name/domain/user.dart';

import 'package:file_picker/file_picker.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:autorization_name/services/database.dart';
import 'package:image_picker/image_picker.dart';

import 'package:path/path.dart';

class FileWork {
  UploadTask task;
  File file;
  UserDom user;
  final imagePicker = ImagePicker();

  FileWork();

  FileWork.setFile(this.file);

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    final path = result.files.single.path;
    file = File(path);
  }

  Future getImageCamera() async {
    final image = await imagePicker.getImage(source: ImageSource.camera);
    if (image == null) return;
    file = File(image.path);
  }

  Future uploadFile(UserDom user) async {
    if (file == null) return;

    final fileName = basename(file.path);

    final destination = 'avatars/${user.id}_avatar';

    task = DatabaseServise.uploadFile(destination, file);

    if (task == null) return;

    final snapshot = await task.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    user.avatarURL = urlDownload;
    return user;
  }
}
