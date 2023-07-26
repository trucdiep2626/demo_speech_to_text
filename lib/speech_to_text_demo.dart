import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:speech_to_text/speech_recognition_error.dart';
import '';

class SpeechToTextDemo extends StatefulWidget {
  @override
  _SpeechToTextDemoState createState() => _SpeechToTextDemoState();
}

class _SpeechToTextDemoState extends State<SpeechToTextDemo> {
  // late stt.SpeechToText _speechToText;
  // late FlutterTts _flutterTts;
  // bool _isListening = false;
  // String _text = '';
  //
  // @override
  // void initState()  {
  //   super.initState();
  //   _speechToText = stt.SpeechToText();
  //   _flutterTts = FlutterTts();
  //
  //   _respondToHello();
  //  // _listen();
  // }
  //
  // void _listen() async {
  //    if (!_isListening) {
  //     bool available = await _speechToText.initialize(
  //       finalTimeout: const Duration(seconds: 15),
  //       onStatus: (status) {
  //         if (status == 'done') {
  //           setState(() => _isListening = false);
  //           _listen();
  //         }
  //         // Handle status changes, if needed.
  //         print('Status: $status');
  //       },
  //
  //       onError: (SpeechRecognitionError error) {
  //         print("Error: $error");
  //       },
  //     );
  //
  //     if (available) {
  //       setState(() => _isListening = true);
  //       _speechToText.listen(
  //         onResult: (result) {
  //           setState(()  {
  //             _text += '\n- ${result.recognizedWords}';
  //             _isListening = false;
  //           });
  //           log(_text);
  //           if (_text.toLowerCase().contains('hello')) {
  //             _respondToHello(); // Call the response function when "hello" is detected.
  //           }
  //         },
  //       );
  //     }
  //   } else {
  //     setState(() => _isListening = false);
  //     _speechToText.stop();
  //   }
  // }
  //
  // void _respondToHello() async {
  //   setState(() => _text += '\n Response: Hello there!');
  //
  //
  //   // Use the FlutterTts package to speak the response
  //   await _flutterTts.setLanguage("en-US");
  //   await _flutterTts.setSpeechRate(0.5);
  //   await _flutterTts.setVolume(1.0);
  //   await _flutterTts.speak("Welcome to ABC!");
  //   print("Welcome to ABC!");
  //
  //   if(!_isListening)
  //     {
  //       _listen();
  //     }
  // }
  //
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text('Speech to Text Demo'),
  //     ),
  //     body: Center(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: <Widget>[
  //           Text(_text),
  //           SizedBox(height: 20),
  //           ElevatedButton(
  //             onPressed: _listen,
  //             child: Text(_isListening ? 'Stop Listening' : 'Start Listening'),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  final stt.SpeechToText _speechToText = stt.SpeechToText();
  final FlutterTts _textToSpeech = FlutterTts();
  bool _speechEnabled = false;
  bool _speechAvailable = false;
  String _lastWords = '';
  String _currentWords = '';
  final String _selectedLocaleId = 'ja_JP';

  printLocales() async {
    var locales = await _speechToText.locales();
    for (var local in locales) {
      debugPrint(local.name);
      debugPrint(local.localeId);
    }
  }

  @override
  void initState() {
    super.initState();
    _initTextToSpeech();
    _initSpeech();
  }

  void _initTextToSpeech() async{
    // _textToSpeech.setInitHandler(() async => _stopListening());
    // _textToSpeech.setCompletionHandler(() async => _startListening());
    // await _textToSpeech.setLanguage("en-US");
    // await _textToSpeech.setSpeechRate(0.5);
    // await _textToSpeech.setVolume(1.0);
  }

  void errorListener(SpeechRecognitionError error) {
    debugPrint(error.errorMsg.toString());
    _stopListening();
    _startListening();
  }

  void statusListener(String status) async {
    debugPrint("status $status");
    if (status == "done" && _speechEnabled) {
      setState(() {
        _lastWords += " $_currentWords";
        _currentWords = "";
        _speechEnabled = false;
      });
      await _startListening();
    }
  }

  /// This has to happen only once per app
  void _initSpeech() async {
  await  _respondToHello();
    _speechAvailable = await _speechToText.initialize(
        onError: errorListener, onStatus: statusListener);
   await _startListening();
  }

  /// Each time to start a speech recognition session
  Future _startListening() async {
    debugPrint("=================================================");
    await _stopListening();
    await Future.delayed(const Duration(milliseconds: 50));
    await _speechToText.listen(
        onResult: _onSpeechResult,
        localeId: _selectedLocaleId,
        cancelOnError: false,
        partialResults: true,
        listenMode: stt.ListenMode.dictation);
    setState(() {
      _speechEnabled = true;
    });
  }

  Future<void> _respondToHello() async {
   // await _stopListening();
    print('Response: Hello there!');

   if(!_speechEnabled)
     {
       await _textToSpeech.setLanguage(_selectedLocaleId);
       await _textToSpeech.setSpeechRate(0.5);
       await _textToSpeech.setVolume(1.0);
       await _textToSpeech.speak("こんにちは");
     }

    setState(() {
      _lastWords = "";
      _currentWords = "Welcome!";
    });
  }

  Future<void> _respond() async {

    print('Response: Auto');

  if(!(_speechEnabled && _speechToText.isAvailable)) {
    await _textToSpeech.setLanguage("en-US");
    await _textToSpeech.setSpeechRate(0.5);
    await _textToSpeech.setVolume(1.0);
    await _textToSpeech.speak("Thank you");
   // _textToSpeech.
  }
    setState(() {
      _lastWords += " $_currentWords";
      _currentWords = "Response: Thank you!";
    });
  }


  Future<void> _stopListening() async {
    setState(() {
      _speechEnabled = false;
    });
    await _speechToText.stop();

  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) async {
    setState(() {
      if (result.recognizedWords.isNotEmpty) {
        _currentWords = 'Recognized words:${result.recognizedWords}';
      }
    });
    if (result.recognizedWords.isNotEmpty) {
    await  _stopListening();
      if (result.recognizedWords.toLowerCase().contains('hello')) {
        await _respondToHello();
      } else {
        await _respond();
      }


       await _startListening();
    }
  }

  void requestAudioFocus() async {
    await AudioService.connect();
    await AudioService.start(
      backgroundTaskEntrypoint: _audioTaskEntrypoint,
      androidNotificationChannelName: 'Recording Channel',
      androidNotificationColor: 0xFF2196F3,
      androidNotificationIcon: 'mipmap/ic_launcher',
    );
    await AudioService.pause();
  }

  void releaseAudioFocus() async {
    await AudioService.stop();
    await AudioService.disconnect();
  }

  void _audioTaskEntrypoint() async {
    AudioServiceBackground.run(() => AudioTask());
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Speech Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Container(
            //   padding: const EdgeInsets.all(16),
            //   child: const Text(
            //     'Recognized words:',
            //     style: TextStyle(fontSize: 20.0),
            //   ),
            // ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Text(
                   '$_lastWords $_currentWords'

                ),
              ),
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed:
      //   _speechToText.isNotListening ? _startListening : _stopListening,
      //   tooltip: 'Listen',
      //   child: Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic),
      // ),
    );
  }
}
