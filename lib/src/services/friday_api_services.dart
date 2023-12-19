

import 'package:dio/dio.dart';

class AiApiServices{
  Future aiApiServices({
    required String prompt,
  }) async {
    dynamic responseJson;

    try {
      var dio = Dio();

      var response = await dio.post("https://generativelanguage.googleapis.com/v1beta3/models/text-bison-001:generateText?key=AIzaSyD24Bryve9_oNN1kmq0oem4vZwPIqlI2dc",
          options: Options(
             
              followRedirects: false,
              validateStatus: (status) {
                return status! <= 500;
              }),
          data: { "prompt": { "text": prompt} });
      
      print(response.statusCode);
      print(response.data);

      responseJson = response;
    } catch (e) {
      print(e);
    }

    return responseJson;
  }
}
