import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> uploadImage(String path, BuildContext context) async {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Uploading image...")));
    print("Uploading image...");
    File file = File(path);
    try {
      String fileName = DateTime.now().toString();

      Reference ref = _storage.ref().child("shop_images/$fileName");

      UploadTask uploadTask = ref.putFile(file);

      await uploadTask;

      String downloadURL = await ref.getDownloadURL();
      print("Download URL: $downloadURL");
      return downloadURL;
    } catch (e) {
      print("There was an error");
      print(e);

      return null;
    }
  }
}
