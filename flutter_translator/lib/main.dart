import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:translator/translator.dart';

void main() {
  runApp(
    const MaterialApp(debugShowCheckedModeBanner: false, home: SplashScreen()),
  );
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AppTranslator()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFF004AAD),
      body: Center(
        child: Image.asset('assets/img/translator_logo.png', width: 125),
      ),
    );
  }
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
  String _selectedLanguage = 'en';

  final List<Map<String, String>> languages = [
    {'value': 'de', 'label': 'Alemão'},
    {'value': 'ar', 'label': 'Árabe'},
    {'value': 'bn', 'label': 'Bengali'},
    {'value': 'ko', 'label': 'Coreano'},
    {'value': 'es', 'label': 'Espanhol'},
    {'value': 'fr', 'label': 'Francês'},
    {'value': 'hi', 'label': 'Hindi'},
    {'value': 'en', 'label': 'Inglês'},
    {'value': 'ja', 'label': 'Japonês'},
    {'value': 'jv', 'label': 'Javanês'},
    {'value': 'la', 'label': 'Latim'},
    {'value': 'zh-cn', 'label': 'Mandarim'},
    {'value': 'mr', 'label': 'Marata'},
    {'value': 'pa', 'label': 'Punjabi'},
    {'value': 'pt', 'label': 'Português'},
    {'value': 'ru', 'label': 'Russo'},
    {'value': 'ta', 'label': 'Tâmil'},
    {'value': 'te', 'label': 'Telugu'},
    {'value': 'tr', 'label': 'Turco'},
    {'value': 'ur', 'label': 'Urdu'},
    {'value': 'vi', 'label': 'Vietnamita'},
  ];

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
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.only(right: 36.0),
          child: Text(
            'Translator',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EasterEgg()),
              );
            },
            child: Image.asset('assets/img/translator_logo.png', width: 100),
          ),
        ],
        backgroundColor: const Color(0XFF004AAD),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              bool isWide = constraints.maxWidth > 600;

              Widget inputColumn = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 300,
                    height: 300,
                    child: TextField(
                      maxLength: 4000,
                      maxLines: null,
                      controller: _textController,
                      decoration: const InputDecoration(
                        labelText: 'Digite o texto ou use a câmera',
                        border: OutlineInputBorder(),
                        counterText: '',
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              );

              Widget outputColumn = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 300,
                    height: 300,
                    child: TextField(
                      readOnly: true,
                      maxLines: null,
                      controller: TextEditingController(text: translatedText),
                      decoration: const InputDecoration(
                        labelText: 'Tradução',
                        border: OutlineInputBorder(),
                      ),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              );

              Widget mainContent;

              if (isWide) {
                mainContent = Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    inputColumn,
                    const SizedBox(width: 32),
                    outputColumn,
                  ],
                );
              } else {
                mainContent = Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    inputColumn,
                    const SizedBox(height: 24),
                    outputColumn,
                  ],
                );
              }

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Tradutor de Texto",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  mainContent,
                  const SizedBox(height: 24),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: translateText,
                          icon: const Icon(
                            Icons.translate,
                            color: Color(0XFF004AAD),
                          ),
                          label: const Text(
                            "Traduzir",
                            style: TextStyle(color: Color(0XFF004AAD)),
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(left: 16)),
                        ElevatedButton.icon(
                          onPressed: pickImageAndTranslate,
                          icon: const Icon(
                            Icons.camera_alt,
                            color: Color(0XFF004AAD),
                          ),
                          label: const Text(
                            "Usar Câmera",
                            style: TextStyle(color: Color(0XFF004AAD)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 16)),
                  SizedBox(
                    width: 300,
                    child: Autocomplete<String>(
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text.isEmpty) {
                          return const Iterable<String>.empty();
                        }
                        return languages
                            .map((lang) => lang['label']!)
                            .where(
                              (label) => label.toLowerCase().contains(
                                textEditingValue.text.toLowerCase(),
                              ),
                            );
                      },
                      onSelected: (String selection) {
                        final selectedLang = languages.firstWhere(
                          (lang) => lang['label'] == selection,
                          orElse: () => {'value': '', 'label': ''},
                        );

                        setState(() {
                          _selectedLanguage = selectedLang['value']!;
                        });
                      },
                      fieldViewBuilder: (
                        context,
                        controller,
                        focusNode,
                        onEditingComplete,
                      ) {
                        return TextField(
                          controller: controller,
                          focusNode: focusNode,
                          decoration: const InputDecoration(
                            labelText: 'Selecione o idioma',
                            border: OutlineInputBorder(),
                          ),
                          onEditingComplete: onEditingComplete,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Idioma selecionado: $_selectedLanguage',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class EasterEgg extends StatelessWidget {
  const EasterEgg({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Easter Egg', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0XFF004AAD),
      ),
      body: Center(child: Image.asset('assets/img/easter_egg.png')),
      backgroundColor: Colors.white,
    );
  }
}
