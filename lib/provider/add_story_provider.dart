import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddStoryProvider extends ChangeNotifier {
  String? imagePath;
  XFile? imageFile;

  void setImageFile(XFile? value) {
    imageFile = value;
    notifyListeners();
  }

  void setImagePath(String? value) {
    imagePath = value;
    notifyListeners();
  }

  void clearImage() {
    imagePath = null;
    notifyListeners();
  }
}