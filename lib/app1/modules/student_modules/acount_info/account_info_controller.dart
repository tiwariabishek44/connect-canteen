import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AccountInfoController extends GetxController {
  var image = File('').obs; // Here's an example using GetX

//-------------TO PICK THE IMAGE FORM THE MOBILE-------------//
  Future<void> pickImages() async {
    final picker = ImagePicker();

    await showModalBottomSheet(
      context: Get.overlayContext!,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Gallery'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final pickedFile =
                      await picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    image.value = File(pickedFile.path);
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Camera'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final pickedFile =
                      await picker.pickImage(source: ImageSource.camera);
                  if (pickedFile != null) {
                    image.value = File(pickedFile.path);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
