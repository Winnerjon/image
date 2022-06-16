import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_ml_vision/google_ml_vision.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? imageFile;

  /// Get from gallery
  _getFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        imageFile = File(image.path);

        getImageText();
      });
    }
  }


  getImageText() async {
    final GoogleVisionImage visionImage = GoogleVisionImage.fromFile(imageFile!);
    final TextRecognizer textRecognizer = GoogleVision.instance.textRecognizer();
    final VisionText visionText = await textRecognizer.processImage(visionImage);
    String imgText = "";

    String? text = visionText.text;
    for (TextBlock block in visionText.blocks) {
      final Rect? boundingBox = block.boundingBox;
      final List<Offset> cornerPoints = block.cornerPoints;
      final String? text = block.text;
      final List<RecognizedLanguage> languages = block.recognizedLanguages;

      for (TextLine line in block.lines) {
        imgText = imgText + line.text.toString() + "\n";
        for (TextElement element in line.elements) {

        }
      }
    }

    print("Text: $imgText");

    textRecognizer.close();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 500,
            width: double.infinity,
            child: imageFile != null ? Image(image: FileImage(imageFile!)) : SizedBox(),
          ),

          MaterialButton(
            height: 50,
            minWidth: 200,
            color: Colors.blue,
            child: Text("Get Image"),
            onPressed: _getFromGallery,
          ),
        ],
      ),
    );
  }
}
