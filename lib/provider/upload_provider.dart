import 'dart:typed_data';

import 'package:faveverse/data/model/add_story_response.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

import '../data/api/api_services.dart';

class UploadProvider extends ChangeNotifier {
  final ApiServices apiService;

  UploadProvider(this.apiService);

  bool isUploading = false;
  String message = "";
  AddStoryResponse? uploadResponse;

  Future<void> upload(
    List<int> bytes,
    String fileName,
    String description, {
    double? lat,
    double? lon,
  }) async {
    try {
      message = "";
      uploadResponse = null;
      isUploading = true;
      notifyListeners();

      uploadResponse = await apiService.uploadDocument(
        bytes,
        fileName,
        description,
        lat: lat,
        lon: lon,
      );
      message = uploadResponse?.message ?? "success";
      isUploading = false;
      notifyListeners();
    } catch (e) {
      isUploading = false;
      message = e.toString();
      notifyListeners();
    }
  }

  Future<List<int>> compressImage(List<int> bytes) async {
    int imageLength = bytes.length;
    if (imageLength < 1000000) return bytes;
    final img.Image image = img.decodeImage(Uint8List.fromList(bytes))!;
    int compressQuality = 100;
    int length = imageLength;
    List<int> newByte = [];
    do {
      compressQuality -= 10;
      newByte = img.encodeJpg(image, quality: compressQuality);
      length = newByte.length;
    } while (length > 1000000);
    return newByte;
  }

  void setLoadingState(bool isLoading) {
    isUploading = isLoading;
    notifyListeners();
  }
}
