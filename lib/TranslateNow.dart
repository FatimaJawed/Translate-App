import 'dart:io';
import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

class TranslateNow extends StatefulWidget {
  const TranslateNow({super.key});

  @override
  State<TranslateNow> createState() => _TranslateNowState();
}

class _TranslateNowState extends State<TranslateNow> {
  List<String> languages = [
    'English',
    'Hindi',
    'Spanish',
    'French',
    'German',
    'Korean',
    'Thailand',
    'Urdu',
    'Arabic',
    'Italian',
    'Chinese',
    'Japanese',
    'Portuguese',
    'Russian'
  ];

  List<String> languageCodes = [
    'en',
    'hi',
    'es',
    'fr',
    'de',
    'ko',
    'th',
    'ur',
    'ar',
    'it',
    'zh',
    'ja',
    'pt',
    'ru'
  ];

  final translator = GoogleTranslator();
  String from = 'en';
  String to = 'hi';
  String data = '';
  String selectedvalue = 'English';
  String selectedvalue2 = 'Hindi';
  TextEditingController controller = TextEditingController(text: 'Hello my name is Fatima');

  final formkey = GlobalKey<FormState>();
  bool isLoading = false;

  translate() async {
    if (formkey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      try {
        await translator
            .translate(controller.text, from: from, to: to)
            .then((value) {
          setState(() {
            data = value.text;
            isLoading = false;
          });
        });
      } on SocketException catch (_) {
        setState(() {
          isLoading = false;
        });
        SnackBar mysnackbar = const SnackBar(
          content: Text('Internet not Connected'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
        );
        ScaffoldMessenger.of(context).showSnackBar(mysnackbar);
      }
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Center(
          child:  Text(
            'Translate Now',
            style:  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: DropdownButton<String>(
                    value: selectedvalue,
                    items: languages.map((lang) {
                      return DropdownMenuItem(
                        child: Text(lang),
                        value: lang,
                        onTap: () {
                          setState(() {
                            from = languageCodes[languages.indexOf(lang)];
                          });
                        },
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedvalue = value!;
                      });
                    },
                    isExpanded: true,
                    underline: const SizedBox(),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.blue),
                ),
                child: Form(
                  key: formkey,
                  child: TextFormField(
                    controller: controller,
                    maxLines: null,
                    minLines: 1,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your text';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      enabledBorder: InputBorder.none,
                      border: InputBorder.none,
                      errorBorder: InputBorder.none,
                    ),
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: DropdownButton<String>(
                    value: selectedvalue2,
                    items: languages.map((lang) {
                      return DropdownMenuItem(
                        child: Text(lang),
                        value: lang,
                        onTap: () {
                          setState(() {
                            to = languageCodes[languages.indexOf(lang)];
                          });
                        },
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedvalue2 = value!;
                      });
                    },
                    isExpanded: true,
                    underline: const SizedBox(),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.blue),
                ),
                child: Center(
                  child: SelectableText(
                    data.isEmpty ? "Translation will appear here" : data,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 8,
              ),

              ElevatedButton(
                onPressed: isLoading ? null : translate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(300, 45),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
                    : const Text(
                  'Translate',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 30)
            ],
          ),
        ),
      ),
    );
  }
}
