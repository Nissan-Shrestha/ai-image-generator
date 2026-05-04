import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ai_image_generator_app/core/services/cloudflare_ai_service.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:gal/gal.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

class ImageGenerationViewmodel extends ChangeNotifier {
  bool _isPickerActive = false;
  bool isLoading = false;
  bool isSaving = false;
  bool isSharing = false;
  bool saveSuccess = false;
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
      String errorStr = e.toString();
      if (errorStr.startsWith('Exception: ')) {
        errorStr = errorStr.replaceFirst('Exception: ', '');
      }
      errorMessage = errorStr;
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

  void clearGeneratedImage() {
    generatedImageUrl = null;
    saveSuccess = false;
    notifyListeners();
  }

  Future<void> saveImageToGallery() async {
    if (generatedImageUrl == null || isSaving) return;

    isSaving = true;
    saveSuccess = false;
    notifyListeners();

    try {
      // gal handles permissions automatically
      Uint8List imageBytes;

      if (generatedImageUrl!.startsWith('data:')) {
        final base64Str = generatedImageUrl!.replaceFirst(
          RegExp(r'data:image/[^;]+;base64,'),
          '',
        );
        imageBytes = base64Decode(base64Str);
      } else {
        final response = await http.get(Uri.parse(generatedImageUrl!));
        imageBytes = response.bodyBytes;
      }

      await Gal.putImageBytes(imageBytes);
      saveSuccess = true;
      errorMessage = null;
    } on GalException catch (e) {
      errorMessage = "Failed to save image: ${e.type.message}";
    } catch (e) {
      errorMessage = "Error saving image: $e";
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  Future<void> shareImage() async {
    if (generatedImageUrl == null || isSharing) return;

    isSharing = true;
    notifyListeners();

    try {
      Uint8List imageBytes;

      if (generatedImageUrl!.startsWith('data:')) {
        final base64Str = generatedImageUrl!.replaceFirst(
          RegExp(r'data:image/[^;]+;base64,'),
          '',
        );
        imageBytes = base64Decode(base64Str);
      } else {
        final response = await http.get(Uri.parse(generatedImageUrl!));
        imageBytes = response.bodyBytes;
      }

      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/shared_ai_image.png');
      await file.writeAsBytes(imageBytes);

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          text: 'Check out this image I generated with AI!',
        ),
      );
    } catch (e) {
      errorMessage = "Error sharing image: $e";
    } finally {
      isSharing = false;
      notifyListeners();
    }
  }
}
