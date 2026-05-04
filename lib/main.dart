import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ai_image_generator_app/viewmodels/image_generation_viewmodel.dart';
import 'package:ai_image_generator_app/viewmodels/auth_viewmodel.dart';
import 'package:ai_image_generator_app/views/auth/login_screen.dart';
import 'package:ai_image_generator_app/views/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ImageGenerationViewmodel>(
          create: (_) => ImageGenerationViewmodel(),
        ),
        ChangeNotifierProvider<AuthViewModel>(
          create: (_) => AuthViewModel(),
        ),
      ],
      child: MaterialApp(
        title: 'AI Image Generator',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const AuthWrapper(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // If connecting to Firebase, show loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFF1A1A2E),
            body: Center(child: CircularProgressIndicator(color: Colors.purpleAccent)),
          );
        }
        
        // If user is logged in, show the Dashboard
        if (snapshot.hasData) {
          return const DashboardScreen();
        }
        
        // If not logged in, show the Login screen
        return const LoginScreen();
      },
    );
  }
}
