import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  final ImagePicker _picker = ImagePicker();

  final XFile? _file = await _picker.pickImage(source: source);

  if (_file != null) {
    return await _file.readAsBytes();
  }

  print("No image Selected");
}
