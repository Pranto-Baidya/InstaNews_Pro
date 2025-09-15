

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart';

final speechStateProvider = StateNotifierProvider<SpeechNotifier,SpeechState>((ref)=>SpeechNotifier());

class SpeechState{
  final bool isListening;
  final String recognizedWords;

  SpeechState({
    this.isListening = false,
    this.recognizedWords = ''
  });

  SpeechState copyWith({bool? isListening, String? recognizedWords}){
    return SpeechState(
        isListening: isListening ?? this.isListening,
        recognizedWords: recognizedWords ?? this.recognizedWords
    );
  }
}

class SpeechNotifier extends StateNotifier<SpeechState>{

  final SpeechToText _speechToText = SpeechToText();

  SpeechNotifier() : super(SpeechState());

  Future<void> startListening()async{

    var status = await Permission.microphone.status;

    if(!status.isGranted){
      status = await Permission.microphone.request();
      if(!status.isGranted){
        return;
      }
    }

    bool available = await _speechToText.initialize(
      onStatus: (status){
        if(status=='done'){
          state = state.copyWith(isListening: false);
        }
      },
      onError: (error){
        state = state.copyWith(isListening: false);
      }
    );

    if(available){
      state = state.copyWith(isListening: true);
      await _speechToText.listen(
        onResult: (result){
          state = state.copyWith(recognizedWords: result.recognizedWords);
        },
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 5),
      );
    }
    else{
      print('speech recognition not available on this device');
    }
  }

  void stopListening(){
    _speechToText.stop();
    state = state.copyWith(isListening: false);
  }

  void clearRecognizedText(){
    state = state.copyWith(recognizedWords: '');
  }
}