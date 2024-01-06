import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:study_helper/src/const/app_fonts.dart';
import 'package:study_helper/src/controller/ai_chat_controller.dart';
import 'package:study_helper/src/view/search_image_view.dart';


class ConnectWithAiView extends StatefulWidget {
  const ConnectWithAiView({super.key});

  @override
  State<ConnectWithAiView> createState() => _ConnectWithAiViewState();
}

class _ConnectWithAiViewState extends State<ConnectWithAiView> {

  final aiChatController = Get.find<AIchatController>();

  var textController = TextEditingController();

 
  String? searchedText, result, _finishReason;
  bool _loading = false;

  String? get finishReason => _finishReason;
  bool get loading => _loading;

  set finishReason(String? set) {
    if (set != _finishReason) {
      setState(() => _finishReason = set);
    }
  }

  set loading(bool set) {
    if (set != loading) {
      setState(() => _loading = set);
    }
  }

  

  @override
  void initState() {
    super.initState();
     sayHello();
  }

  sayHello(){
    WidgetsBinding.instance.addPostFrameCallback((_) {
              // aiChatController.getgeminiResponse("Hey Gemini!");
     });
  }

  


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // title: Text("Friday",style: primaryFont.copyWith(

        // ),),
        actions: [
          IconButton(onPressed: (){
            Get.to(SearchImageView());
          }, icon: Image.asset("assets/images/image_icon.png",height: 30,)),

           PopupMenuButton<String>(
          // initialValue: "Clear Chat",
          // Callback that sets the selected popup menu item.
          onSelected: (String item) {
            aiChatController.chatList.clear();
            aiChatController.chats.clear();
            aiChatController.update();
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: "Clear Chat",
              child: Text('Clear Chat'),
            ),
           
          ],
        ),
        ],
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Image.asset("assets/images/woman (2).png",height: 30,),
                          ),
                          Container(
                            width: size.width * 0.75,
                            child: Text(aiChatController.chatList[index].question,style: primaryFontSemiBold.copyWith(
                              fontSize: 14
                            ),))
                        ],
                      ),
                      IconButton(
                          tooltip: "Edit Question",
                        onPressed: (){
                        textController.text = aiChatController.chatList[index].question;

                      }, icon: const Icon(Icons.mode_edit_outline,size: 20,color: Colors.blue,))
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
                          physics: NeverScrollableScrollPhysics(),
                                  data: aiChatController.chatList[index].answer.toString(),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        tooltip: "Copy",
                        onPressed: (){
                          aiChatController.copyAnswer(aiChatController.chatList[index].answer.toString());


                      }, icon: Icon(Icons.copy_outlined,size: 20,))

                    ],
                  ),
                  Divider()
                ],
              );
            },
          );
        }
      ),
      bottomNavigationBar: Padding(
         padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 10),
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
                      contentPadding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                      )
                    ),
                 ),
               ),
             ),
             Expanded(
              flex: 1,
              child: Obx(() => aiChatController.isLoading.isTrue ? Container(
                height: 55,
                width: 50,
                child: Row(
                  children: [
                    // CircularProgressIndicator(
                    //   color: Colors.blue,
                    // ),
                    Image.asset("assets/images/loader.gif")

                  ],
                ),
              )  :Padding(
                padding: const EdgeInsets.only(right: 15),
                child: InkWell(
                    onTap: (){
                      if (textController.text.isNotEmpty) {
  String question = textController.text;
  textController.clear();
  aiChatController.getGemini(question);
}else{
  Get.rawSnackbar(
    message: "Friday need some Inputs"
  );
}
                    },
                    child: Image.asset("assets/images/send (1).png",height: 55,)),
              ),
              ))
           ],
         ),
        ),
      ),
    );
  }
}