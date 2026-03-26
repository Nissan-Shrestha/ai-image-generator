import 'package:flutter/material.dart';

class ImageGenerationViewmodel extends ChangeNotifier {
  final TextEditingController generateController = TextEditingController();

  bool isLoading = false;

  // final List<String> history = [];

  //currently just clears textformfield
  Future<void> enterPrompt() async {
    if (isLoading) return;

    final prompt = generateController.text.trim();
    if (prompt.isEmpty) return;

    isLoading = true;
    notifyListeners();

    print("the prompt was:$prompt");
    // history.insert(0, prompt);

    // if (history.length > 5) {
    //   history.removeAt(4);
    // }

    await Future.delayed(const Duration(seconds: 2));

    isLoading = false;
    generateController.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    generateController.dispose();
    super.dispose();
  }
}
