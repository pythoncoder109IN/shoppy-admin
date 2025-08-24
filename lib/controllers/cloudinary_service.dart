import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import "package:http/http.dart" as http;

import 'package:image_picker/image_picker.dart';

Future<String?> uploadToCloudinary(XFile? xFile) async {
  if (xFile == null) {
    print("No file selected!");
    return null;
  }

  String cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '';

  var uri = Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/raw/upload");
  var request = http.MultipartRequest("POST", uri);

  var fileBytes = await xFile.readAsBytes();

  var multipartFile = http.MultipartFile.fromBytes(
    'file',
    fileBytes,
    filename: xFile.name,
  );

  request.files.add(multipartFile);

  request.fields['upload_preset'] = "preset-for-file-upload";
  request.fields['resource_type'] = "raw";

  var response = await request.send();

  var responseBody = await response.stream.bytesToString();

  print(responseBody);

  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(responseBody);
    print("Upload successful!");
    return jsonResponse["secure_url"];
  } else {
    print("Upload failed with status: ${response.statusCode}");
    return null;
  }
}
