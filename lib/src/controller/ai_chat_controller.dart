import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:study_helper/src/models/chat_model.dart';
import 'package:study_helper/src/models/gemini_api_model.dart';
import 'package:study_helper/src/services/friday_api_services.dart';
import 'package:dio/dio.dart' as dio;

class AIchatController extends GetxController{


AiApiServices aiApiServicesb = AiApiServices();
ScrollController scrollController = ScrollController();
  List<ChatModel> chatList = [
    
    
  ];

  RxBool isLoading = false.obs;
 

 getgeminiResponse(String prompt) async{
  isLoading(true);
    dio.Response<dynamic> response = await aiApiServicesb.aiApiServices(prompt: prompt);
     isLoading(false);
    if(response.statusCode == 200){

      GeminiModel geminiModel = GeminiModel.fromJson(response.data);
      ChatModel chatModel = ChatModel(answer: geminiModel.candidates.first.output,question: prompt);
      chatList.add(chatModel);
      SchedulerBinding.instance.addPostFrameCallback((_) {
                     scrollController.animateTo(
                     scrollController.position.maxScrollExtent,
                     duration: const Duration(milliseconds: 1),
                     curve: Curves.fastOutSlowIn);
                     });
      update();
      
    }else{
      Get.rawSnackbar(
        message: "Something went wrong, Contact the developer",
        backgroundColor: Colors.red
      );
    }
 }


}