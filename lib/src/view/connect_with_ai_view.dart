import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:study_helper/src/const/app_fonts.dart';
import 'package:study_helper/src/controller/ai_chat_controller.dart';



class ConnectWithAiView extends StatefulWidget {
  const ConnectWithAiView({super.key});

  @override
  State<ConnectWithAiView> createState() => _ConnectWithAiViewState();
}

class _ConnectWithAiViewState extends State<ConnectWithAiView> {

  final aiChatController = Get.find<AIchatController>();

  var textController = TextEditingController();

  


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        
      ),
      body:GetBuilder<AIchatController>(
        builder: (_) {
          return aiChatController.chatList.isEmpty ? Center(
        child: Image.asset("assets/images/5162744.jpg",height: 250,),
        ) : ListView.builder(
            itemCount: aiChatController.chatList.length,
            controller: aiChatController.scrollController,
            itemBuilder: (context,index){
              return Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Image.asset("assets/images/woman (2).png",height: 30,),
                      ),
                      Container(
                        width: size.width * 0.8,
                        child: Text(aiChatController.chatList[index].question,style: primaryFontSemiBold.copyWith(
                          fontSize: 14
                        ),))
                    ],
                  ),
                 const SizedBox(
                    height: 10,
                  ),
                   Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text("        "),
                      ),
                      Container(
                         width: size.width * 0.8,
                        child: Markdown(
                                  data: aiChatController.chatList[index].answer,
                                  selectable: true,
                                  shrinkWrap: true,
                                  styleSheet: MarkdownStyleSheet(
                                    textScaleFactor: 1.0, // Adjust the text scale factor as needed
                                  ),
                                ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Divider()
                ],
              );
            },
          );
        }
      ),
      bottomNavigationBar: Padding(
         padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 15),
        child: Container(
         child: Row(
           children: [
             Expanded(
              flex:5,
               child: Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 15),
                 child: TextField(
                  maxLines: 5,
                  minLines: 1,
                  controller: textController,
                  style: primaryFont.copyWith(
                    fontSize: 15
                  ),
                    decoration: InputDecoration(
                      hintText: "Type here...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50)
                      )
                    ),
                 ),
               ),
             ),
             Expanded(
              flex: 1,
              child: Obx(()=>aiChatController.isLoading.isTrue ? Container(
                height: 55,
                width: 50,
                child: Row(
                  children: [
                    CircularProgressIndicator(
                      color: Colors.blue,
                    ),
                  ],
                ),
              )  :InkWell(
                  onTap: (){
                    String question = textController.text;
                    textController.clear();
                    aiChatController.getgeminiResponse(question);
                     
                  },
                  child: Image.asset("assets/images/send (1).png",height: 55,)),
              ))
           ],
         ),
        ),
      ),
    );
  }
}