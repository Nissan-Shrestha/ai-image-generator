import 'package:ai_image_generator_app/core/constants/textstyle.dart';
import 'package:ai_image_generator_app/viewmodels/Image_generation_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ImageGenerationScreen extends StatelessWidget {
  const ImageGenerationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ImageGenerationViewmodel(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Generate Image", style: subheadingStyle),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Consumer<ImageGenerationViewmodel>(
                builder: (context, vm, _) {
                  return TextFormField(
                    onFieldSubmitted: (_) => vm.enterPrompt(),
                    enabled: !vm.isLoading,
                    controller: vm.generateController,
                    decoration: InputDecoration(
                      hintText: "Enter ur prompt",
                      suffixIcon: vm.isLoading
                          ? Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : IconButton(
                              onPressed: vm.enterPrompt,
                              icon: Icon(Icons.arrow_forward),
                            ),
                      filled: true,
                      enabledBorder: OutlineInputBorder(
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
            ],
          ),
        ),
      ),
    );
  }
}
