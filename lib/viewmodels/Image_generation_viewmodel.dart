import 'package:flutter/material.dart';

class ImageGenerationViewmodel extends ChangeNotifier {
  bool isLoading = false;

  Future<void> generateImage(String prompt) async {
    if (isLoading) return;
    if (prompt.trim().isEmpty) return;

    isLoading = true;
    notifyListeners();

    print("Generating image for prompt: $prompt");

    await Future.delayed(const Duration(seconds: 2)); // simulate API

    isLoading = false;
    notifyListeners();
  }
}