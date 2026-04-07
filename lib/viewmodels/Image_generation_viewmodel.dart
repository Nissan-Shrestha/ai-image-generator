import 'package:flutter/material.dart';
import 'package:ai_image_generator_app/core/services/cloudflare_ai_service.dart';

class ImageGenerationViewmodel extends ChangeNotifier {
  bool isLoading = false;
  String? generatedImageUrl;
  String? errorMessage;
  final _service = CloudflareAIService();

  Future<void> generateImage(String prompt) async {
    if (isLoading) return;

    isLoading = true;
    errorMessage = null;
    generatedImageUrl = null;
    notifyListeners();

    try {
      final imageUrl = await _service.generateImage(prompt: prompt);
      generatedImageUrl = imageUrl;
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }
}
