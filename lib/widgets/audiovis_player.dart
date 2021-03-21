import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:morse_code_translator/controllers/audiovisual_player.dart';

class AudioVisualPlayerWidget extends StatefulWidget {
  final String morseToPlay;
  final Function onPlayCallback;
  AudioVisualPlayerWidget({Key key, @required this.morseToPlay, @required this.onPlayCallback}) : super(key: key);

  @override
  _AudioVisualPlayerWidgetState createState() => _AudioVisualPlayerWidgetState();
}

class _AudioVisualPlayerWidgetState extends State<AudioVisualPlayerWidget> {
  List<bool> isSelected = [false, false, false];

  final FilteringTextInputFormatter morseCodeFilter = FilteringTextInputFormatter.allow(RegExp("[a-z A-Z 0-9]"));

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ToggleButtons(
          children: <Widget>[
            Icon(Icons.lightbulb),
            Icon(Icons.vibration),
            Icon(Icons.audiotrack),
          ],
          onPressed: (int index) {
            setState(() {
              isSelected[index] = !isSelected[index];
            });
          },
          isSelected: isSelected,
        ),
        IconButton(
          onPressed: () {
            String morseToPlay = widget.onPlayCallback();
            print('Preparing to play morse with string: $morseToPlay');
            AudioVisualPlayer audioVisualPlayer = new AudioVisualPlayer();

            if(isSelected[0]){
              print('Turning on light...');
              audioVisualPlayer.addPlayer(new AudioVisualPlayerLightDecorator());
            }

            if(isSelected[1]){
              print('Turning on vibrations...');
              audioVisualPlayer.addPlayer(new AudioVisualPlayerVibrateDecorator());
            }

            if(isSelected[2]){
              print('Turning on audio...');
              audioVisualPlayer.addPlayer(new AudioVisualPlayerAudioDecorator());
            }

            //await compute(audioVisualPlayer.playText, _textTranslated);
            //compute(audioVisualPlayer.playText, _textTranslated);
            if(audioVisualPlayer.players.isNotEmpty){  //If there are players, play
              audioVisualPlayer.playText(morseToPlay);
            }
          },
          icon: Icon(Icons.play_arrow_outlined),
        ),
      ],
    );
  }
}