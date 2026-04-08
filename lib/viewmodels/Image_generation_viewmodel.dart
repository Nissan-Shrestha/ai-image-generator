import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ai_image_generator_app/core/services/cloudflare_ai_service.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';

class ImageGenerationViewmodel extends ChangeNotifier {
  bool _isPickerActive = false;
  bool isLoading = false;
  String? generatedImageUrl;
  String? errorMessage;

  File? selectedImage;
  final _service = CloudflareAIService();

  Future<bool> generateImage(String prompt) async {
    if (isLoading) return false;
    if (prompt.trim().isEmpty) {
      errorMessage = "Please enter a prompt";
      notifyListeners();
      return false;
    }

    isLoading = true;
    errorMessage = null;
    generatedImageUrl = null;
    notifyListeners();

    try {
      final imageUrl = await _service.generateImage(
        prompt: prompt,
        imageFile: selectedImage,
      );
      generatedImageUrl = imageUrl;
      
      // Success! Clear the selected image now.
      selectedImage = null; 
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> pickImage() async {
    if (_isPickerActive) return;
    _isPickerActive = true;
    notifyListeners();

    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        img.Image? decoded = img.decodeImage(bytes);

        if (decoded != null) {
          // Resize to max 512 while maintaining aspect ratio
          img.Image resized = img.copyResize(decoded, width: 512, height: 512);

          // Save it back to a file
          final tempDir = Directory.systemTemp;
          final resizedFile = File('${tempDir.path}/resized_image.png')
            ..writeAsBytesSync(img.encodePng(resized));

          selectedImage = resizedFile;
        }
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      _isPickerActive = false;
      notifyListeners();
    }
  }

  void clearSelectedImage() {
    selectedImage = null;
    notifyListeners();
  }
}
