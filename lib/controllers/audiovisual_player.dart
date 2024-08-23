import "dart:typed_data";
import 'package:flutter/services.dart';
import 'package:torch_light/torch_light.dart';
import 'package:vibration/vibration.dart';
import 'package:soundpool/soundpool.dart';
import 'package:wave_generator/wave_generator.dart';

class AudioVisualPlayer{
  List<AudioVisualPlayerDecorator> players = List.empty(growable:true);
  late int elementDurationMs;  //http://www.kent-engineers.com/codespeed.htm

  AudioVisualPlayer({this.elementDurationMs = 240});

  void addPlayer(AudioVisualPlayerDecorator hpDecorator){
    this.players.add(hpDecorator);
  }

  void playText(String textToPlay) async {
    print('Playing morse $textToPlay');
    for(int i = 0; i < textToPlay.length; i++){
      if(textToPlay[i] == ' '){
        print('Got to space');
        await Future.delayed(Duration(milliseconds:elementDurationMs)); //https://stackoverflow.com/questions/18449846/how-can-i-sleep-a-dart-program
      } else {
        var futures = <Future>[];
        players.forEach((player) {
          var toPrint = textToPlay[i];
          print('Got to player $i of type $player with symbol $toPrint');

          if(textToPlay[i] == '.'){
            print('Got to short');
            futures.add(player.playTone(elementDurationMs));
          } else if(textToPlay[i] == '-'){
            print('Got to long');
            futures.add(player.playTone(elementDurationMs*3));
          }
        });
        await Future.wait(futures);
      }
    }
  }

  Future<void> playTone(String toneToPlay) async {
    if(toneToPlay == ' '){
      print('Got to space');
      await Future.delayed(Duration(milliseconds:elementDurationMs)); //https://stackoverflow.com/questions/18449846/how-can-i-sleep-a-dart-program
    } else {
      var futures = <Future>[];
      players.forEach((player) {
        if(toneToPlay == '.'){
          print('Got to short');
          futures.add(player.playTone(elementDurationMs));
        } else if(toneToPlay == '-'){
          print('Got to long');
          futures.add(player.playTone(elementDurationMs*3));
        }
      });
      await Future.wait(futures);
    }
  }
}

abstract class AudioVisualPlayerDecorator{
  //void playShortTone();
  //void playLongTone();
  //void playBlankTone();
  Future<void> playTone(int duration);
}

class AudioVisualPlayerLightDecorator extends AudioVisualPlayerDecorator{
  @override
  Future<void> playTone(int duration) async {
    print('Flashing!');
    TorchLight.enableTorch(); //TODO these are futures in the newer package
    await Future.delayed(Duration(milliseconds:duration));
    TorchLight.disableTorch();;
  }
}

class AudioVisualPlayerVibrateDecorator extends AudioVisualPlayerDecorator{
  @override
  Future<void> playTone(int duration) async {
    print('Vibrating!');
    Vibration.vibrate(duration: duration);
    /*Vibration.hasVibrator().then((value) {
      Vibration.vibrate();
      return;
    }).catchError((error){
      print("No vibration device detected...");
      return;
    });*/
  }
}

class AudioVisualPlayerAudioDecorator extends AudioVisualPlayerDecorator{
  ///WARNING !!! If there are weird beeps in between tones, in might just be the computer (which is the case for the tower, frequently beeps when sound comes on & goes off)
  Soundpool pool = Soundpool.fromOptions(options: SoundpoolOptions(streamType: StreamType.notification));

  @override
  Future<void> playTone(int duration) async {
    print('Audioing!');

    //https://medium.com/flutter-community/working-with-bytes-in-dart-6ece83455721
    /*
    Soundpool pool = Soundpool(streamType: StreamType.notification);

    int soundId = await rootBundle.load("res/beep-01a.mp3").then((ByteData soundData) {
      return pool.load(soundData);
    });
    int streamId = await pool.play(soundId);*/

    var generator = WaveGenerator(
      /* sample rate */ 44100,
        BitDepth.depth8Bit);

    var note = Note(
      /* frequency */ 400,
        /* msDuration */ duration,
        /* waveform */ Waveform.square, //Square works best for quick responses to DOT s
        /* volume */ 0.5);

    List<int> bytes = [];
    await for (int byte in generator.generate(note)) {
      bytes.add(byte);
    }

    int soundId = await pool.load(new ByteData.view(new Uint8List.fromList(bytes).buffer));
    //int streamId = await pool.play(soundId);
    await pool.play(soundId);
  }
}