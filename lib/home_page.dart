import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'input_size_box.dart';
import 'pallete.dart';
import 'constant.dart';
import 'feature_box.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'openai_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SpeechToText speechToText = SpeechToText();
  String lastWords = '';
  final flutterTts = FlutterTts();
  OpenAIService openAIService = OpenAIService();
  String? generatedContent;
  String? generatedImageURL;
  final TextEditingController _textEditingController = TextEditingController();
  bool showText = false;
  bool isResponding = false;

  @override
  void initState() {
    super.initState();
    initSpeechToText();
    initTextToSpeech();
  }

  Future<void> initSpeechToText() async {
    if (await speechToText.initialize()) {
      setState(() {});
    }
  }

  Future<void> initTextToSpeech() async {
    await flutterTts.setSharedInstance(true);
    setState(() {});
  }

  // Future<void> startListening() async {
  //   await speechToText.listen(onResult: onSpeechResult);
  //   setState(() {});
  // }

  // Future<void> stopListening() async {
  //   await speechToText.stop();
  // }

  // void onSpeechResult(SpeechRecognitionResult result) {
  //   setState(() {
  //     lastWords = result.recognizedWords;
  //   });
  // }

  Future<void> systemSpeak(String content) async {
    await flutterTts.speak(content);
  }

  @override
  void dispose() {
    super.dispose();
    speechToText.stop();
    flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Jarvis"),
        leading: const Icon(
          Icons.menu,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Center(
                  child: Container(
                    height: 120,
                    width: 120,
                    margin: const EdgeInsets.only(top: 4),
                    decoration: const BoxDecoration(
                      color: Pallete.assistantCircleColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Container(
                  height: 123,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('assets/images/virtualAssistant.png'),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              margin: const EdgeInsets.symmetric(
                horizontal: 40,
              ).copyWith(top: 30),
              decoration: BoxDecoration(
                color: Colors.grey,
                border: Border.all(color: Pallete.borderColor),
                borderRadius: kBorderRadius,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                ),
                child: Column(
                  children: [
                    Visibility(
                      visible: isResponding,
                      child: const Text(
                        "Responding...",
                        style: TextStyle(
                          color: Pallete.mainFontColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: !isResponding,
                      child: generatedContent == null
                          ? const Text(
                              "Good morning how can I assist you today?",
                              style: TextStyle(
                                color: Pallete.mainFontColor,
                                fontSize: 25,
                                fontFamily: 'Cera Pro',
                              ),
                            )
                          : AnimatedTextKit(
                              animatedTexts: [
                                TypewriterAnimatedText(
                                  generatedContent!,
                                  textStyle: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Pallete.mainFontColor,
                                  ),
                                  speed: const Duration(milliseconds: 10),
                                ),
                              ],
                              totalRepeatCount: 1,
                              pause: const Duration(milliseconds: 1000),
                              displayFullTextOnTap: true,
                              stopPauseOnTap: true,
                            ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.only(
                right: 80,
              ),
              child: const Text(
                "Here are a few commands",
                style: TextStyle(
                  fontFamily: 'Cera Pro',
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Column(
              children: [
                const FeatureBox(
                  colour: Pallete.firstSuggestionBoxColor,
                  title: 'Chat-GPT',
                  description:
                      'A smarter way to stay organized and informed with ChatGPT',
                ),
                const FeatureBox(
                  colour: Pallete.secondSuggestionBoxColor,
                  title: 'Dall-E',
                  description:
                      'Get inspired and stayed creative with your personal assistant powered by Dall-E',
                ),
                InputSizedBox(
                  textEditingController: _textEditingController,
                  onPressed: () async {
                    setState(() {
                      isResponding = true;
                      generatedContent = null;
                      generatedImageURL = '';
                    });

                    final userText = _textEditingController.text;

                    if (userText.contains('https://')) {
                      // If the user   input is a URL, display the image
                      setState(() {
                        generatedImageURL = userText;
                        generatedContent = null;
                        isResponding = false;
                      });
                    } else {
                      // If it's not a URL, request the OpenAI API for a response
                      final response =
                          await openAIService.isArtPromptAPI(userText);
                      await systemSpeak(response);

                      setState(() {
                        if (response.contains('https')) {
                          // If the API response is a URL, display the image
                          generatedImageURL = response;
                          generatedContent = null;
                          isResponding = false;
                        } else {
                          // If it's not a URL, display the response as text
                          generatedImageURL = null;
                          generatedContent = response;
                          isResponding = false;
                        }
                      });
                    }
                  },
                ),
                // InputSizedBox(
                //   textEditingController: _textEditingController,
                //   onPressed: () async {
                //     setState(() {
                //       generatedContent = null;
                //
                //       generatedImageURL = '';
                //     });
                //     final userText = _textEditingController.text;
                //     final response =
                //         await openAIService.isArtPromptAPI(userText);
                //
                //     if (response != generatedImageURL) {
                //       await systemSpeak(response);
                //     }
                //
                //     setState(() {
                //       if (response.contains('https')) {
                //         setState(() {});
                //         Image.network(generatedImageURL!);
                //         generatedContent = null;
                //       } else {
                //         setState(() {});
                //         generatedImageURL = null;
                //         generatedContent = response;
                //       }
                //     });
                //   },
                // ),
              ],
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Pallete.firstSuggestionBoxColor,
      //   onPressed: () async {
      //     if (await speechToText.hasPermission && speechToText.isNotListening) {
      //       await startListening();
      //     } else if (speechToText.isListening) {
      //       final speech = await openAIService.isArtPromptAPI(lastWords);
      //       await systemSpeak(speech);
      //       await stopListening();
      //       if (speech.contains('https')) {
      //         setState(() {
      //           generatedImageURL = speech;
      //           generatedContent = null;
      //         });
      //       } else {
      //         setState(() {
      //           generatedImageURL = null;
      //           generatedContent = speech;
      //         });
      //         await systemSpeak(speech);
      //       }
      //     } else {
      //       initSpeechToText();
      //     }
      //   },
      //   child: const Icon(Icons.mic),
      // ),
    );
  }
}

// child: Image.asset(
//   'assets/images/virtualAssistant.png',
// ),
