import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
import 'package:flutter_tts/flutter_tts.dart';

class LanguageTranslatingPage extends StatefulWidget {
  const LanguageTranslatingPage({super.key});

  @override
  State<LanguageTranslatingPage> createState() => _LanguageTranslatingPageState();
}

class _LanguageTranslatingPageState extends State<LanguageTranslatingPage> {
  final FlutterTts flutterTts = FlutterTts();
  var languages = ['Hindi', 'English', 'French', 'Kannada'];
  var languageFlags = {
    'Hindi': '🇮🇳',
    'English': '🇺🇸',
    'French': '🇫🇷',
    'Kannada': '🇮🇳'
  };
  var originLanguage = "From";
  var destinationLanguage = 'To';
  var output = "";
  TextEditingController languageController = TextEditingController();
  TextEditingController outputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initializeTts();
  }

  void initializeTts() async {
    // Initialize Text to Speech
    await flutterTts.setSpeechRate(0.5); // Set speech rate
    await flutterTts.setVolume(1.0); // Set volume
    await flutterTts.setPitch(1.0); // Set pitch
  }

  String getLanguageCode(String language) {
    switch (language) {
      case 'English':
        return 'en';
      case 'Hindi':
        return 'hi';
      case 'French':
        return 'fr';
      case 'Kannada':
        return 'kn';
      default:
        return '--';
    }
  }

  void speakText(String text, String language) async {
    await flutterTts.setLanguage(getLanguageCode(language));
    await flutterTts.speak(text);
  }

  void translateText() async {
    String src = getLanguageCode(originLanguage);
    String dest = getLanguageCode(destinationLanguage);
    String input = languageController.text.trim();

    if (input.isEmpty) {
      setState(() {
        output = "Please enter some text to translate.";
        outputController.text = output;
      });
      return;
    }

    GoogleTranslator translator = GoogleTranslator();

    try {
      var translation = await translator.translate(input, from: src, to: dest);
      setState(() {
        output = translation.text;
        outputController.text = output;
      });
    } catch (e) {
      setState(() {
        output = "Translation failed. Please try again.";
        outputController.text = output;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff10223d),
      appBar: AppBar(
        title: const Text(
          'Language Translator',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: () {
            Navigator.pop(context); // Handle back press
          },
        ),
        centerTitle: true,
        backgroundColor: const Color(0xff10223d),
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // "From" Dropdown
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 0),
                      DropdownButton<String>(
                        focusColor: Colors.white,
                        iconDisabledColor: Colors.white,
                        iconEnabledColor: Colors.blue,
                        hint: Text(
                          originLanguage,
                          style: const TextStyle(color: Colors.white),
                        ),
                        dropdownColor: Colors.blue,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: languages.map((String dropDownStringItem) {
                          return DropdownMenuItem<String>(
                            value: dropDownStringItem,
                            child: Row(
                              children: [
                                Text(languageFlags[dropDownStringItem] ?? ''),
                                const SizedBox(width: 8),
                                Text(dropDownStringItem),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            originLanguage = newValue!;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(width: 120),

                  // "To" Dropdown
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      DropdownButton<String>(
                        focusColor: Colors.white,
                        iconDisabledColor: Colors.white,
                        iconEnabledColor: Colors.blue,
                        hint: Text(
                          destinationLanguage,
                          style: const TextStyle(color: Colors.white),
                        ),
                        dropdownColor: Colors.blue,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: languages.map((String dropDownStringItem) {
                          return DropdownMenuItem<String>(
                            value: dropDownStringItem,
                            child: Row(
                              children: [
                                Text(languageFlags[dropDownStringItem] ?? ''),
                                const SizedBox(width: 8),
                                Text(dropDownStringItem),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            destinationLanguage = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 1),

              // Input text field with speaker button
              Padding(
                padding: const EdgeInsets.all(50),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        cursorColor: Colors.white,
                        autofocus: false,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Please Enter Your Text',
                          labelStyle: TextStyle(fontSize: 15, color: Colors.white),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white, width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white, width: 1),
                          ),
                          errorStyle: TextStyle(color: Colors.red, fontSize: 15),
                        ),
                        controller: languageController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter text';
                          }
                          return null;
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.volume_up, color: Colors.white),
                      onPressed: () {
                        speakText(languageController.text, originLanguage);
                      },
                    ),
                  ],
                ),
              ),

              // Translate button
              Padding(
                padding: const EdgeInsets.all(30),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                  ),
                  onPressed: () {
                    translateText(); // Directly call translateText
                  },
                  child: const Text(
                    'Translate',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 5),

              // Translated text field with speaker button in the same line
              Padding(
                padding: const EdgeInsets.all(50),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        cursorColor: Colors.white,
                        autofocus: false,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Translated Text',
                          labelStyle: TextStyle(fontSize: 15, color: Colors.white),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white, width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white, width: 1),
                          ),
                          errorStyle: TextStyle(color: Colors.red, fontSize: 15),
                        ),
                        controller: outputController,
                        readOnly: true, // Make the translated text field read-only
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.volume_up, color: Colors.white),
                      onPressed: () {
                        speakText(output, destinationLanguage);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
