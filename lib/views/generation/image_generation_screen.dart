import 'package:ai_image_generator_app/core/constants/colors.dart';
import 'package:ai_image_generator_app/viewmodels/image_generation_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

class ImageGenerationScreen extends StatefulWidget {
  const ImageGenerationScreen({super.key});

  @override
  State<ImageGenerationScreen> createState() => _ImageGenerationScreenState();
}

class _ImageGenerationScreenState extends State<ImageGenerationScreen> {
  final TextEditingController _controller = TextEditingController();

  final List<String> _styles = [
    "Cyberpunk",
    "Cinematic",
    "Anime",
    "Oil Painting",
    "3D Render",
    "Watercolor",
    "Photorealistic"
  ];

  final List<String> _surprisePrompts = [
    "A futuristic city with flying cars at sunset, cyberpunk style",
    "A cute golden retriever astronaut floating in space",
    "A majestic waterfall inside a glowing bioluminescent cave",
    "A tiny magical village hidden inside a hollow tree",
    "A steampunk airship soaring through fluffy white clouds",
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [backgroundColor, surfaceColor],
          ),
        ),
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: accentColor, width: 2),
                      ),
                      child: Icon(Icons.arrow_back, color: accentColor),
                    ),
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Create Image",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      Text(
                        "Describe what you want to see",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // Input Field
                    Consumer<ImageGenerationViewmodel>(
                      builder: (context, vm, _) {
                        return Column(
                          children: [
                            if (vm.selectedImage != null)
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Stack(
                                    alignment: Alignment.topRight,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: accentColor.withValues(alpha: 0.2),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color: accentColor.withValues(alpha: 0.5),
                                          ),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          child: Image.file(
                                            vm.selectedImage!,
                                            height: 80,
                                            width: 80,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      // Clear Button
                                      GestureDetector(
                                        onTap: () {
                                          vm.clearSelectedImage();
                                        },
                                        child: Container(
                                          margin: EdgeInsets.all(2),
                                          padding: EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                            Container(
                              decoration: BoxDecoration(
                                color: surfaceColor,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: vm.errorMessage != null
                                      ? Colors.red.withValues(alpha: 0.5)
                                      : accentColor.withValues(alpha: 0.3),
                                  width: 2,
                                ),
                              ),
                              child: TextField(
                                enabled: !vm.isLoading,
                                controller: _controller,
                                maxLines: 4,
                                style: TextStyle(color: textColor),
                                decoration: InputDecoration(
                                  prefixIcon: IconButton(
                                    onPressed: vm.pickImage,
                                    icon: Icon(
                                      vm.selectedImage != null
                                          ? Icons.image
                                          : Icons.add_a_photo,
                                      color: vm.selectedImage != null
                                          ? Colors.green
                                          : Colors.grey,
                                    ),
                                  ),
                                  hintText:
                                      "A beautiful sunset over mountains...",
                                  hintStyle: TextStyle(
                                    color: Colors.grey.shade600,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(16),
                                  suffixIcon: vm.isLoading
                                      ? Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation(
                                                    accentColor,
                                                  ),
                                            ),
                                          ),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: GestureDetector(
                                            onTap: () async {
                                              final prompt = _controller.text;
                                              final success =
                                                  await vm.generateImage(prompt);
                                              if (success) {
                                                _controller.clear();
                                              }
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    primaryColor,
                                                    secondaryColor,
                                                  ],
                                                ),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                Icons.send,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                ),
                              ),
                            ),
                            SizedBox(height: 12),
                            // Style Chips
                            SizedBox(
                              height: 40,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      _surprisePrompts.shuffle();
                                      _controller.text = _surprisePrompts.first;
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(right: 8),
                                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(colors: [primaryColor, secondaryColor]),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      alignment: Alignment.center,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.auto_awesome, color: Colors.white, size: 16),
                                          SizedBox(width: 6),
                                          Text("Surprise Me", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  ..._styles.map((style) => GestureDetector(
                                    onTap: () {
                                      final currentText = _controller.text;
                                      if (currentText.isEmpty) {
                                        _controller.text = style;
                                      } else {
                                        _controller.text = "$currentText, $style style";
                                      }
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(right: 8),
                                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: surfaceColor,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(color: accentColor.withValues(alpha: 0.3)),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(style, style: TextStyle(color: textColor, fontSize: 13)),
                                    ),
                                  )),
                                ],
                              ),
                            ),
                            SizedBox(height: 16),
                            // Error Message
                            if (vm.errorMessage != null &&
                                vm.errorMessage!.isNotEmpty)
                              Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade900.withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.red.withValues(alpha: 0.5),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.warning_amber,
                                      color: Colors.red,
                                      size: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        vm.errorMessage!,
                                        style: TextStyle(
                                          color: Colors.red.shade200,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: 30),
                    // Image Display
                    Consumer<ImageGenerationViewmodel>(
                      builder: (context, vm, _) {
                        return Container(
                          height: 300,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                surfaceColor,
                                surfaceColor.withValues(alpha: 0.5),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: accentColor.withValues(alpha: 0.2),
                            ),
                          ),
                          child: () {
                            if (vm.isLoading) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 60,
                                      height: 60,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 3,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              accentColor,
                                            ),
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    Text(
                                      "Creating your image...",
                                      style: TextStyle(
                                        color: Colors.grey.shade400,
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      "(This may take 30-60 seconds)",
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            if (vm.generatedImageUrl == null) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.image,
                                      color: Colors.grey.shade600,
                                      size: 50,
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      "Your image will appear here",
                                      style: TextStyle(
                                        color: Colors.grey.shade400,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: vm.generatedImageUrl!.startsWith('data:')
                                  ? Image.memory(
                                      base64Decode(
                                        vm.generatedImageUrl!.replaceFirst(
                                          'data:image/png;base64,',
                                          '',
                                        ),
                                      ),
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    )
                                  : Image.network(
                                      vm.generatedImageUrl!,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ),
                            );
                          }(),
                        );
                      },
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
