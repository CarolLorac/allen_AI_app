import 'package:allen/feature_box.dart';
import 'package:allen/pallete.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final speechToText = SpeechToText();
  String lastWords = '';

  @override
  void initState() {
    super.initState();
    initSpeechToText();
  }

  /// This has to happen only once per app
  Future<void> initSpeechToText() async 
  {
    await speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  Future<void> startListening() async
  {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  Future<void> stopListening() async
  {
    await speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void onSpeechResult(SpeechRecognitionResult result)
  {
    setState(() {
      lastWords = result.recognizedWords;
      print("Recognized words: $lastWords"); 
    });
  }

  // Dispose executes cleanup tasks, resources liberations, cancels listeners, etc
  @override
  void dispose() {
    super.dispose();
    speechToText.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Allen", style: TextStyle(fontSize: 18),),
        leading: const Icon(Icons.menu),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 10, bottom: 20),
        child: Column(
          children: [
            //assistant picture 
            Stack(
                children: [
                  Center(
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: const BoxDecoration(
                        color: Pallete.assistantCircleColor,
                        shape: BoxShape.circle
                      ),
                    ),
                  ),
                  Container(
                    height: 123,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('assets/images/virtualAssistant.png')
                      )
                    ),
                  )
                ],
              ),
              //chat
              Container(
                padding: const EdgeInsets.all(15),
                margin: const EdgeInsets.symmetric(horizontal: 30).copyWith(top: 20),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Pallete.borderColor,
                  ),
                  borderRadius: BorderRadius.circular(15).copyWith(
                    topLeft: Radius.zero
                  ),
                ),
                child: const Text('Good Morning, what task can I do for you?', 
                  style: TextStyle(
                    fontFamily: 'Cera Pro',
                    fontSize: 18,
                    color: Pallete.mainFontColor
                   ),
                ),
              ),
             Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.symmetric(horizontal: 25).copyWith(top: 30),
                child: const Text('Here are a new features', 
                  style: TextStyle(
                    fontFamily: 'Cera Pro',
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Pallete.mainFontColor
                  ),
                ),
              ),
              //features 
              const FeatureBox(
                color: Pallete.firstSuggestionBoxColor, 
                headerText: "ChatGPT", 
                descriptionText: "A smarter way to stay organized and informed with ChatGPT"
              ),
              const FeatureBox(
                color: Pallete.secondSuggestionBoxColor, 
                headerText: "Dall-E", 
                descriptionText: "Get inspired and stay creative with your personal assistant powered by Dall-E"
              ),
              const FeatureBox(
                color: Pallete.thirdSuggestionBoxColor, 
                headerText: "Smart Voice Assistant", 
                descriptionText: "Get the best of both words with a voice assistant powered by Dall-E and ChatGPT"
              ),
          ]
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async
        {
          if (await speechToText.hasPermission && speechToText.isNotListening)
          {
            await startListening(); 
          }
          else if (speechToText.isListening)
          {
            await stopListening();
          }
          else 
          {
            initSpeechToText();
          }
        },
        backgroundColor: Pallete.firstSuggestionBoxColor,
        child: Icon(
          speechToText.isListening ? Icons.stop : Icons.mic
        ),
      ),
    );
  }
}