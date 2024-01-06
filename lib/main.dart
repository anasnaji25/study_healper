import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_helper/src/controller/ai_chat_controller.dart';
import 'package:study_helper/src/view/connect_with_ai_view.dart';
import 'package:study_helper/src/view/splash_screen_view.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

void main() {
  Gemini.init(apiKey: 'AIzaSyD24Bryve9_oNN1kmq0oem4vZwPIqlI2dc', enableDebugging: true);
  Get.put(AIchatController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Friday',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home:ConnectWithAiView() ,
      home: SpashScreenView(),
    );
  }
}

