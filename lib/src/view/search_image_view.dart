import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:study_helper/src/const/app_fonts.dart';
import 'package:study_helper/src/controller/ai_chat_controller.dart';


class SearchImageView extends StatefulWidget {
  const SearchImageView({super.key});

  @override
  State<SearchImageView> createState() => _ConnectWithAiViewState();
}

class _ConnectWithAiViewState extends State<SearchImageView> {

  final aiChatController = Get.find<AIchatController>();

  var textController = TextEditingController();

 
  String? searchedText, result, _finishReason;
  bool _loading = false;

  Uint8List? selectedImage;

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
          aiChatController.imageresult("");
          aiChatController.isLoading(false);
     });
  }

  


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
         title: Text("Search image",style: primaryFont.copyWith(
        ),),
        actions: [
           PopupMenuButton<String>(
          // initialValue: "Clear Chat",
          // Callback that sets the selected popup menu item.
          onSelected: (String item) {
            sayHello();
            selectedImage = null ;
           setState(() {
             
           });
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
      body: selectedImage == null ? Center(
        child: InkWell(
          onTap: (){
               _ShowBottomSheet();
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/images/pic_image.jpg",height: 200,),
              Text("Click Here",style: primaryFont,)
            ],
          )),
      ): ListView(
        children: [
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Image.memory(selectedImage!),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Obx(()=> aiChatController.imageresult.value == "" ? Text("Enter your text and send for the magic",style: primaryFont.copyWith(

            ),) :  Markdown(
                physics: NeverScrollableScrollPhysics(),
                        data: aiChatController.imageresult.value,
                        selectable: true,
                        shrinkWrap: true,
                        styleSheet: MarkdownStyleSheet(
                          textScaleFactor: 1.0, // Adjust the text scale factor as needed
                        ),
                      ),
            ),
          )

        ],
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
                      if (textController.text.isNotEmpty && selectedImage != null) {
  String question = textController.text;
  textController.clear();
  aiChatController.searchImageAndtext(question,selectedImage);
}else{
  Get.rawSnackbar(
    message: "Friday need an Image and prompt for thinking"
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



   _ShowBottomSheet() {
    showModalBottomSheet<void>(
            context: context,
            shape:  const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
            ),
            builder: (BuildContext context) {
              return SizedBox(
                height: 200,
                child: Padding(
                  padding: const EdgeInsets.only(top: 35),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                           GestureDetector(
                            onTap: () async{
                      final ImagePicker picker = ImagePicker();
                      final XFile? image =    await picker.pickImage(source: ImageSource.gallery);

                    

                      
CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: image!.path,
      compressQuality: 70,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,

            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
        WebUiSettings(
          context: context,
        ),
      ],
    );
  var tempImage =  await croppedFile?.readAsBytes();

                 setState(() {
                        selectedImage = tempImage;
                      });
                      Get.back();
                            },
                             child: Column(
                               children: [
                                 DottedBorder(
                                  dashPattern: const [6,6],
                                  borderType: BorderType.RRect,
                                  radius: Radius.circular(12),
                                  padding: EdgeInsets.all(6),
                                  child: Container(
                                    height: 100,
                                    width: 100,
                                    child: const  Center(
                                      child: Icon(Icons.photo_library_outlined),
                                    ),
                                  ),
                                  ),
                                                  const  SizedBox(
                                                         height: 10,
                                                     ),
                                                     Text("Gallery",style: primaryFont.copyWith(
                                                      fontSize: 15
                                                     ),)
                               ],
                             ),
                           ),
                         const SizedBox(
                            width: 50,
                          ),
                          GestureDetector(
                            onTap: () async{
                               final ImagePicker picker = ImagePicker();
                      final XFile? image =    await picker.pickImage(source: ImageSource.camera);

                     CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: image!.path,
      compressQuality: 70,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,

            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
        WebUiSettings(
          context: context,
        ),
      ],
    );
  var tempImage =  await croppedFile?.readAsBytes();


                 setState(() {
                        selectedImage = tempImage;
                      });
                      Get.back();
                            },
                            child: Column(
                              children: [
                                DottedBorder(
                                  dashPattern: const [6,6],
                                  borderType: BorderType.RRect,
                                  radius: Radius.circular(12),
                                  padding: EdgeInsets.all(6),
                                  child: Container(
                                    height: 100,
                                    width: 100,
                                    child: const Center(
                                      child: Icon(Icons.camera_alt_outlined),
                                    ),
                                  ),
                                ),
                                  const  SizedBox(
                              height: 10,
                            ),
                            Text("Capture",style: primaryFont.copyWith(
                              fontSize: 15
                            ),)
                              ],
                            ),
                          )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
  }
}