import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:translator/translator.dart';

void main() {
  runApp(
    const MaterialApp(debugShowCheckedModeBanner: false, home: AppTranslator()),
  );
}

class AppTranslator extends StatefulWidget {
  const AppTranslator({Key? key}) : super(key: key);

  @override
  State<AppTranslator> createState() => _AppTranslatorState();
}

class _AppTranslatorState extends State<AppTranslator> {
  final TextEditingController _textController = TextEditingController();
  final GoogleTranslator translator = GoogleTranslator();
  final ImagePicker picker = ImagePicker();

  String translatedText = '';
  String _selectedLanguage = 'en'; // Idioma padrão: inglês

  // Tradução do texto digitado
  Future<void> translateText() async {
    final input = _textController.text;
    if (input.isEmpty) return;

    final translation = await translator.translate(
      input,
      to: _selectedLanguage,
    );
    setState(() {
      translatedText = translation.text;
    });
  }

  Future<void> pickImageAndTranslate() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile == null) return;

    final inputImage = InputImage.fromFile(File(pickedFile.path));
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    final RecognizedText recognizedText = await textRecognizer.processImage(
      inputImage,
    );
    await textRecognizer.close();

    final extractedText = recognizedText.text;

    _textController.text = extractedText;

    if (extractedText.isNotEmpty) {
      final translation = await translator.translate(
        extractedText,
        to: _selectedLanguage,
      );
      setState(() {
        translatedText = translation.text;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("flutter_translator")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text("Tradutor de Texto", style: TextStyle(fontSize: 20)),
            const SizedBox(height: 16),
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: 'Digite o texto ou use a câmera',
                border: OutlineInputBorder(),
              ),
              maxLines: null,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              children: [
                ElevatedButton.icon(
                  onPressed: translateText,
                  icon: const Icon(Icons.translate),
                  label: const Text("Traduzir"),
                ),
                ElevatedButton.icon(
                  onPressed: pickImageAndTranslate,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text("Usar Câmera"),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Tradução:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(translatedText, textAlign: TextAlign.left),
            const SizedBox(height: 16),
            DropdownButton<String>(
              value: _selectedLanguage,
              onChanged: (String? value) {
                setState(() {
                  _selectedLanguage = value!;
                });
              },
              items: const [
                DropdownMenuItem(value: 'de', child: Text('Alemão')),
                DropdownMenuItem(value: 'ar', child: Text('Árabe')),
                DropdownMenuItem(value: 'bn', child: Text('Bengali')),
                DropdownMenuItem(value: 'ko', child: Text('Coreano')),
                DropdownMenuItem(value: 'es', child: Text('Espanhol')),
                DropdownMenuItem(value: 'fr', child: Text('Francês')),
                DropdownMenuItem(value: 'hi', child: Text('Hindi')),
                DropdownMenuItem(value: 'en', child: Text('Inglês')),
                DropdownMenuItem(value: 'ja', child: Text('Japonês')),
                DropdownMenuItem(value: 'jv', child: Text('Javanês')),
                DropdownMenuItem(value: 'zh-cn', child: Text('Mandarim')),
                DropdownMenuItem(value: 'mr', child: Text('Marata')),
                DropdownMenuItem(value: 'pa', child: Text('Punjabi')),
                DropdownMenuItem(value: 'pt', child: Text('Português')),
                DropdownMenuItem(value: 'ru', child: Text('Russo')),
                DropdownMenuItem(value: 'ta', child: Text('Tâmil')),
                DropdownMenuItem(value: 'te', child: Text('Telugu')),
                DropdownMenuItem(value: 'tr', child: Text('Turco')),
                DropdownMenuItem(value: 'ur', child: Text('Urdu')),
                DropdownMenuItem(value: 'vi', child: Text('Vietnamita')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
