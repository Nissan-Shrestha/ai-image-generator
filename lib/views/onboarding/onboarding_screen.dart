import 'package:ai_image_generator_app/core/constants/colors.dart';
import 'package:ai_image_generator_app/core/constants/textstyle.dart';
import 'package:ai_image_generator_app/views/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SizedBox(
          height: double.maxFinite,
          width: double.maxFinite,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Welcome to AI Image Generator",
                textAlign: TextAlign.center,
                style: headingStyle,
              ),
              SizedBox(height: 5),
              Text("Generate or edit your first image", style: bodyStyle),
              SizedBox(height: 5),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => DashboardScreen()),
                  );
                },

                child: Text("Lets Go", style: buttonTextStyle),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
