import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

import 'ResponseModel.dart';
import 'package:http/http.dart' as http;

part 'ml_integration_state.dart';

class MlIntegrationCubit extends Cubit<MlIntegrationState> {
  MlIntegrationCubit() : super(MlIntegrationInitial());

  //bool _isUploading = false;
  ResponseModel? responseModel;
  File? video;
  Future<void> pickVideo() async {

    final pickedFile = await ImagePicker().pickVideo(source: ImageSource.camera,
      maxDuration: Duration(seconds: 4),);

    if (pickedFile != null) {

      video =await File(pickedFile.path);
      uploadVideo();
      print("path:${video}");
      //setState(() {  });
    }

  }

  Future<void> uploadVideo() async {
    // setState(() {
    //   _isUploading = true;  // Set to true before the upload
    // });
    //_pickVideo();
    emit( MlIntegrationInitial());

    print("value${video}");
    if (video == null) {
      print('No video selected');
      return;
    }
    if (!await video!.exists()) {
      print('Video file does not exist');
      return;
    }

    final url = Uri.parse('http://192.168.1.20:5000/classify-video');
    final request =await http.MultipartRequest('POST', url);
    request.files.add(
      await http.MultipartFile.fromPath('file', video!.path),
    );

    final response = await request.send();
    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      var responseBodyDecode=jsonDecode(responseBody);
      responseModel = ResponseModel.fromJson(responseBodyDecode);
      print("responseBody:$responseBodyDecode");
      print('Video uploaded successfully');
    } else {
      print('Failed to upload video');
    }
    emit( MlIntegrationSucessState());
    // setState(() {
    //   _isUploading = false;  // Set to false after processing the response
    // });
  }
}
