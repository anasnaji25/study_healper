import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:study_helper/src/view/connect_with_ai_view.dart';


class SpashScreenView extends StatefulWidget {
  const SpashScreenView({super.key});

  @override
  State<SpashScreenView> createState() => _SpashScreenViewState();
}

class _SpashScreenViewState extends State<SpashScreenView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: Color(0xff121212),
      body: Center(
        child: SizedBox(
  width: 250.0,
  child: DefaultTextStyle(
    style: GoogleFonts.silkscreen(
      fontSize: 30.0,
      color: Colors.white
    ),
    child: AnimatedTextKit(
      totalRepeatCount: 1,
      animatedTexts: [
        TypewriterAnimatedText('Heyy ....!'),
        TypewriterAnimatedText('Its Me Friday'),
        TypewriterAnimatedText('Your personal AI'),
        // TypewriterAnimatedText('With lots of love ♡'),
      ],
      onTap: () {
        print("Tap Event");
      },
      onFinished: (){
        Get.offAll(ConnectWithAiView());
        
      },
    ),
  ),
),
      ),
    );
  }
}