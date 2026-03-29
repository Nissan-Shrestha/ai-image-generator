import 'package:flutter/material.dart';

class ImageGenerationViewmodel extends ChangeNotifier {
  bool isLoading = false;

  String? generatedImageUrl;

  Future<void> generateImage(String prompt) async {
    if (isLoading) return;
    if (prompt.trim().isEmpty) return;

    generatedImageUrl = null;
    isLoading = true;
    notifyListeners();

    print("Generating image for prompt: $prompt");

    await Future.delayed(const Duration(seconds: 2)); // simulate API

    generatedImageUrl =
        "https://gratisography.com/wp-content/uploads/2024/10/gratisography-cool-cat-800x525.jpg";
    isLoading = false;
    notifyListeners();
  }
}
