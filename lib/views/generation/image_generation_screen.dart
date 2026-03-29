import 'package:ai_image_generator_app/core/constants/colors.dart';
import 'package:ai_image_generator_app/core/constants/textstyle.dart';
import 'package:ai_image_generator_app/data/models/prompt.dart';
import 'package:ai_image_generator_app/viewmodels/Image_generation_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ImageGenerationScreen extends StatefulWidget {
  const ImageGenerationScreen({super.key});

  @override
  State<ImageGenerationScreen> createState() => _ImageGenerationScreenState();
}

class _ImageGenerationScreenState extends State<ImageGenerationScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ImageGenerationViewmodel(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: backgroundColor,
        appBar: AppBar(
          centerTitle: true,
          title: Text("Generate Image", style: subheadingStyle),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: 20),
              Consumer<ImageGenerationViewmodel>(
                builder: (context, vm, _) {
                  return TextFormField(
                    enabled: !vm.isLoading,
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Enter ur prompt",
                      suffixIcon: vm.isLoading
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(strokeWidth: 3),
                            )
                          : IconButton(
                              onPressed: () {
                                final prompt = _controller.text;
                                vm.generateImage(prompt);
                                _controller.clear();
                              },
                              icon: Icon(Icons.arrow_forward),
                            ),
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 20),

              //i was just messing around
              // Text("Previous Prompts", style: bodyStyle),
              // Consumer<ImageGenerationViewmodel>(
              //   builder: (context, vm, _) {
              //     if (vm.history.isEmpty) {
              //       return Text("No history");
              //     } else {
              //       return ListView.builder(
              //         shrinkWrap: true,
              //         itemCount: vm.history.length,
              //         itemBuilder: (BuildContext context, int index) {
              //           final prompt = vm.history[index];
              //           return ListTile(
              //             leading: Icon(Icons.history),
              //             title: Text(prompt),
              //           );
              //         },
              //       );
              //     }
              //   },
              // ),
              Container(
                height: 300,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  "Your generated image will appear here",
                  style: bodyStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
