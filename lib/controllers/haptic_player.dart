import "dart:typed_data";
import 'package:flashlight/flashlight.dart';
import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';
import 'package:soundpool/soundpool.dart';
import 'package:wave_generator/wave_generator.dart';

class HapticPlayer{
  List<HapticPlayerDecorator> players = List.empty(growable:true);
  int elementDurationMs;  //http://www.kent-engineers.com/codespeed.htm

  HapticPlayer({this.elementDurationMs}){
    if(elementDurationMs == null){
      elementDurationMs = 240;
    }
  }

  void addPlayer(HapticPlayerDecorator hpDecorator){
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
}

abstract class HapticPlayerDecorator{
  //void playShortTone();
  //void playLongTone();
  //void playBlankTone();
  Future<void> playTone(int duration);
}

class HapticPlayerLightDecorator extends HapticPlayerDecorator{
  @override
  Future<void> playTone(int duration) async {
    print('Flashing!');
    Flashlight.lightOn();
    await Future.delayed(Duration(milliseconds:duration));
    Flashlight.lightOff();
  }
}

class HapticPlayerVibrateDecorator extends HapticPlayerDecorator{
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

class HapticPlayerAudioDecorator extends HapticPlayerDecorator{
  Soundpool pool = Soundpool(streamType: StreamType.notification);

  @override
  Future<void> playTone(int duration) async {
    print('Audioing!');

    /*
    Soundpool pool = Soundpool(streamType: StreamType.notification);

    int soundId = await rootBundle.load("res/beep-01a.mp3").then((ByteData soundData) {
      return pool.load(soundData);
    });
    int streamId = await pool.play(soundId);*/

    var generator = WaveGenerator(
      /* sample rate */ 44100,
        BitDepth.Depth8bit);

    var note = Note(
      /* frequency */ 220,
        /* msDuration */ duration,
        /* waveform */ Waveform.Sine,
        /* volume */ 0.5);

    List<int> bytes = List<int>();
    await for (int byte in generator.generate(note)) {
      bytes.add(byte);
    }

    int soundId = await pool.load(new ByteData.view(new Uint8List.fromList(bytes).buffer));
    //int streamId = await pool.play(soundId);
    await pool.play(soundId);
  }
}