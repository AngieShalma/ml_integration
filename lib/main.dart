import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:poc_integration_ml/ResponseModel.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isUploading = false;
  ResponseModel? responseModel;
  File? _video;
  String? _uploadUrl = "http://192.168.1.18:5000/classify-video"; // Replace with your actual backend endpoint

  //  Future pickedFile = ImagePicker().pickVideo(source: ImageSource.camera).then((File file) {
  // if (file != null && mounted) {
  // var tempFile = file;
  // }
  // }
  Future<void> _pickVideo() async {

    final pickedFile = await ImagePicker().pickVideo(source: ImageSource.camera,
      maxDuration: Duration(seconds: 4),);

      if (pickedFile != null) {

        _video =await File(pickedFile.path);
        _uploadVideo();
        print("path:${_video}");
        setState(() {  });
      }

  }

  Future<void> _uploadVideo() async {
    setState(() {
      _isUploading = true;  // Set to true before the upload
    });
     //_pickVideo();
     print("value${_video}");
    if (_video == null) {
          print('No video selected');
          return;
        }
    if (!await _video!.exists()) {
      print('Video file does not exist');
      return;
    }

    final url = Uri.parse('http://192.168.1.20:5000/classify-video');
    final request =await http.MultipartRequest('POST', url);
    request.files.add(
      await http.MultipartFile.fromPath('file', _video!.path),
    );

    final response = await request.send();
    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      responseModel = ResponseModel.fromJson(responseBody);
      print('Video uploaded successfully');
    } else {
      print('Failed to upload video');
    }
    setState(() {
      _isUploading = false;  // Set to false after processing the response
    });
  }
  // Future<void> _uploadVideo() async {
  //   if (_video == null) {
  //     print('No video selected');
  //     return;
  //   }
  //   if (!_video!.existsSync()) {
  //     print('not exissssssssst');
  //     return;
  //   }
  //   var request = http.MultipartRequest('POST', Uri.parse(_uploadUrl!));
  //   var stream = http.ByteStream(_video!.openRead());
  //   request.files.add(http.MultipartFile(
  //       'file', stream, _video!.lengthSync(), filename: _video!.path.split('/').last));
  //   var response = await request.send();
  //
  //   if (response.statusCode == 200) {
  //     print('Video uploaded successfully!');
  //     setState(() {
  //       _video = null; // Clear video selection after successful upload
  //     });
  //   } else {
  //     print('Error uploading video: ${response.statusCode}');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Video Recorder'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _pickVideo,
                child: Text('Record Video'),
              ),

              ElevatedButton(
                onPressed: _uploadVideo,
                child: Text('Upload Video'),
              ),
              if (_video != null) Text('Selected video: ${_video!.path.split('/').last}'),
              // if (responseModel != null) Text('Sentence: ${responseModel!.sentence!.join(', ')}'),
              if (_isUploading)
              CircularProgressIndicator()
              else if (responseModel != null)
                Text('Sentence: ${responseModel!.sentence!.join(', ')}')
              else
                 Text('Waiting for response...'),
            ],
          ),
        ),
      ),
    );
  }
}
