import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:mime_type/mime_type.dart';

Future<String> uploadData(String path, Uint8List data) async {
  final storageRef = FirebaseStorage.instance.ref().child(path);
  final metadata = SettableMetadata(contentType: mime(path));

  try {
    final result = await storageRef.putData(data, metadata);
    if (result.state == TaskState.success) {
      return await result.ref.getDownloadURL();
    } else {
      throw Exception("Upload failed");
    }
  } catch (e) {
    // Handle the error, e.g., log it or return an error message
    print("Error uploading data: $e");
    throw e; // You can choose to rethrow the exception or return an error message here
  }
}
