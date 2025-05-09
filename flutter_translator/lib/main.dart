import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:translator/translator.dart';

void main() async {
  runApp(
    MaterialApp(debugShowCheckedModeBanner: false, home: const AppTranslator()),
  );
}

class AppTranslator extends StatefulWidget {
  const AppTranslator({super.key});

  @override
  State<AppTranslator> createState() => _AppTranslatorState();
}

class _AppTranslatorState extends State<AppTranslator> {
  final translator = GoogleTranslator();
  final image_picker = ImagePicker();
  final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  String translatedText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Translator')),
      body: const Center(child: Text('Welcome to Translator App')),
    );
  }
}
