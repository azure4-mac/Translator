import 'dart:async';
import "dart:io";
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:translator/translator.dart';

void main() {
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: AppTranslator()));
}

class AppTranslator extends StatefulWidget {
  AppTranslator({Key});
  @override
  State<AppTranslator> createState() => _AppTranslatorState();
}

class _AppTranslatorState extends State<AppTranslator> {
  final TextEditingController _textController = TextEditingController();
  final translator = GoogleTranslator();
  String translatedText = '';
  String _selectedLanguage = 'en'; // por exemplo

  FutureOr<void> translateText() async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("flutter_translator")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Tradutor de Texto"),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: 'Digite o texto para traduzir',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ElevatedButton(onPressed: translateText, child: Text("Traduzir")),
          Text('Tradução:', style: TextStyle(fontWeight: FontWeight.bold)),
          Text(translatedText),
          DropdownButton<String>(
            value: _selectedLanguage,
            onChanged: (String? value) {
              setState(() {
                _selectedLanguage = value!;
              });
            },
            items: const [
              DropdownMenuItem(value: 'en', child: Text('Inglês')),
              DropdownMenuItem(value: 'es', child: Text('Espanhol')),
              DropdownMenuItem(value: 'fr', child: Text('Francês')),
            ],
          ),
        ],
      ),
    );
  }
}
