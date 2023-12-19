import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_helper/src/controller/ai_chat_controller.dart';
import 'package:study_helper/src/view/connect_with_ai_view.dart';
import 'package:study_helper/src/view/splash_screen_view.dart';

void main() {
  Get.put(AIchatController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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

