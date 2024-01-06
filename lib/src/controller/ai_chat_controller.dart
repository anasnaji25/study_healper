import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:get/get.dart';
import 'package:study_helper/src/const/app_fonts.dart';
import 'package:study_helper/src/models/chat_model.dart';
import 'package:study_helper/src/models/gemini_api_model.dart';
import 'package:study_helper/src/services/friday_api_services.dart';
import 'package:dio/dio.dart' as dio;

class AIchatController extends GetxController{


AiApiServices aiApiServicesb = AiApiServices();
ScrollController scrollController = ScrollController();
  List<ChatModel> chatList = [
    
    
  ];


  final List<Content> chats = [];

  RxBool isLoading = false.obs;


  final gemini = Gemini.instance;
  getGemini(String prompt){
   chats.add(
                  Content(role: 'user', parts: [Parts(text: prompt)]));
              
              isLoading(true);

              gemini.chat(chats).then((value) {
                ChatModel chatModel = ChatModel(question: prompt,answer: value?.output);
                chatList.add(chatModel);
                      SchedulerBinding.instance.addPostFrameCallback((_) {
                     scrollController.animateTo(
                     scrollController.position.maxScrollExtent,
                     duration: const Duration(milliseconds: 1),
                     curve: Curves.fastOutSlowIn);
                     });
                 update();
                chats.add(Content(
                    role: 'model', parts: [Parts(text: value?.output)]));
                isLoading(false);
              });
              update();
  }

  RxString imageresult = "".obs;


  searchImageAndtext(String prompt,Uint8List? selectedImage) async{
    isLoading(true);
    gemini.textAndImage(
                  text: prompt, images: [selectedImage!]).then((value) {
                imageresult(value?.content?.parts?.last.text);
                isLoading(false);
                update();
              });
 
  }


  
 

//  getgeminiResponse(String prompt) async{
//   isLoading(true);
//     dio.Response<dynamic> response = await aiApiServicesb.aiApiServices(prompt: prompt);
//      isLoading(false);
//     if(response.statusCode == 200){

//       GeminiModel geminiModel = GeminiModel.fromJson(response.data);
//       ChatModel chatModel = ChatModel(answer: geminiModel.candidates.first.output,question: prompt);
//       chatList.add(chatModel);
//       SchedulerBinding.instance.addPostFrameCallback((_) {
//                      scrollController.animateTo(
//                      scrollController.position.maxScrollExtent,
//                      duration: const Duration(milliseconds: 1),
//                      curve: Curves.fastOutSlowIn);
//                      });
//       update();
      
//     }else{
//       Get.rawSnackbar(
//         message: "Something went wrong, Contact the developer",
//         backgroundColor: Colors.red
//       );
//     }
//  }
void copyAnswer(String answer) {
    Clipboard.setData(ClipboardData(text: answer)).then((value) { 
      Get.closeAllSnackbars();
      Get.rawSnackbar(
        messageText: Text("Copied",style: primaryFont.copyWith(
          color: Colors.white,

        ),),
        backgroundColor: Colors.green
      );
}); // -> notify the user
}

}