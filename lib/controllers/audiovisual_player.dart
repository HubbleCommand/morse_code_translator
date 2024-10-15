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

  Future<void> playTone(String toneToPlay) async {
    if(toneToPlay == ' '){
      await Future.delayed(Duration(milliseconds:elementDurationMs*3));
    } else {
      var futures = <Future>[];
      players.forEach((player) {
        if(toneToPlay == '.'){
          futures.add(player.playTone(elementDurationMs));
        } else if(toneToPlay == '-'){
          futures.add(player.playTone(elementDurationMs*3));
        }
      });
      await Future.wait(futures);
    }
  }
}

abstract class AudioVisualPlayerDecorator{
  Future<void> playTone(int duration);
}

class AudioVisualPlayerLightDecorator extends AudioVisualPlayerDecorator{
  @override
  Future<void> playTone(int duration) async {
    TorchLight.enableTorch();
    await Future.delayed(Duration(milliseconds:duration));
    TorchLight.disableTorch();;
  }
}

//No guarantee that this will correctly play, due to hw limits
class AudioVisualPlayerVibrateDecorator extends AudioVisualPlayerDecorator{
  @override
  Future<void> playTone(int duration) async {
    Vibration.vibrate(duration: duration);
  }
}

class AudioVisualPlayerAudioDecorator extends AudioVisualPlayerDecorator{
  Soundpool pool = Soundpool.fromOptions(options: SoundpoolOptions(streamType: StreamType.notification));

  @override
  Future<void> playTone(int duration) async {
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
    await pool.play(soundId);
  }
}