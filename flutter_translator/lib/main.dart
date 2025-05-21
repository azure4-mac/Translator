import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:translator/translator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0XFF004AAD),
        scaffoldBackgroundColor: const Color(0xFFF9F2F8),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Color(0XFF004AAD),
            side: BorderSide(color: Color(0XFF004AAD)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
      home: const SplashScreen(),
    );
  }
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
      backgroundColor: const Color(0XFF004AAD),
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
  bool isLoading = false;

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

    setState(() => isLoading = true);

    final translation = await translator.translate(
      input,
      to: _selectedLanguage,
    );
    setState(() {
      translatedText = translation.text;
      isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Texto traduzido com sucesso!')),
    );
  }

  Future<void> pickImageAndTranslate() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile == null) return;

    final inputImage = InputImage.fromFile(File(pickedFile.path));
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final recognizedText = await textRecognizer.processImage(inputImage);
    await textRecognizer.close();

    final extractedText = recognizedText.text;
    _textController.text = extractedText;

    if (extractedText.isNotEmpty) {
      setState(() => isLoading = true);
      final translation = await translator.translate(
        extractedText,
        to: _selectedLanguage,
      );
      setState(() {
        translatedText = translation.text;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Translator', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0XFF004AAD),
        actions: [
          InkWell(
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EasterEgg()),
                ),
            child: Image.asset('assets/img/translator_logo.png', width: 100),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Tradutor de Texto",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 700;
                return Flex(
                  direction: isWide ? Axis.horizontal : Axis.vertical,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Column(
                        children: [
                          TextField(
                            maxLength: 4000,
                            controller: _textController,
                            decoration: const InputDecoration(
                              labelText: 'Digite o texto ou use a câmera',
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
                          DropdownButtonFormField<String>(
                            value: _selectedLanguage,
                            items:
                                languages.map((lang) {
                                  return DropdownMenuItem<String>(
                                    value: lang['value'],
                                    child: Text(lang['label']!),
                                  );
                                }).toList(),
                            onChanged: (value) {
                              setState(() => _selectedLanguage = value!);
                            },
                            decoration: const InputDecoration(
                              labelText: 'Selecione o idioma',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 32, height: 32),
                    Flexible(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tradução:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 8),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: double.infinity,
                            height: 300,
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child:
                                isLoading
                                    ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                    : SelectableText(
                                      translatedText,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
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
        title: const Text('Easter Egg', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0XFF004AAD),
      ),
      body: Center(child: Image.asset('assets/img/easter_egg.png')),
      backgroundColor: Colors.white,
    );
  }
}
