import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:morse_code_translator/controllers/audiovisual_player.dart';
import 'package:morse_code_translator/widgets/settings_container.dart';

class AudioVisualPlayerWidget extends StatefulWidget {
  final Function onPlayCallback;
  AudioVisualPlayerWidget({super.key, required this.onPlayCallback});

  @override
  _AudioVisualPlayerWidgetState createState() => _AudioVisualPlayerWidgetState();
}

class _AudioVisualPlayerWidgetState extends State<AudioVisualPlayerWidget> {
  List<bool> isSelected = [false, false, false];

  bool isPlaying = false;

  final IconData iconPlay = Icons.play_circle_fill_outlined;
  final IconData iconStop = Icons.stop_circle_outlined;

  late IconData iconData;

  _AudioVisualPlayerWidgetState(){
    iconData = iconPlay;
  }

  final FilteringTextInputFormatter morseCodeFilter = FilteringTextInputFormatter.allow(RegExp("[a-z A-Z 0-9]"));

  @override
  Widget build(BuildContext context) {
    final settingsContainer = SettingsContainer.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ToggleButtons(
          renderBorder: false,
          borderRadius: BorderRadius.circular((20)),
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
          onPressed: () async {
            if(isPlaying) {
              print('It appears that the tune is playing, stopping...');
              setState(() {
                isPlaying = false;
                iconData = iconPlay;
              });
            } else {
              String morseToPlay = widget.onPlayCallback();
              print('Preparing to play morse with string: $morseToPlay');
              if(morseToPlay.isEmpty) {
                ScaffoldMessenger
                    .of(context)
                    .showSnackBar(SnackBar(content: Text('Please translate some text')));
                return;
              }

              AudioVisualPlayer audioVisualPlayer = new AudioVisualPlayer(elementDurationMs: settingsContainer.settingsService.elementDuration);

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
              if(audioVisualPlayer.players.isNotEmpty ){  //If there are players, play
                setState(() {
                  isPlaying = true;
                  iconData = iconStop;
                });

                for(int i = 0; i < morseToPlay.length; i++){
                  if(this.isPlaying && this.mounted){
                    await audioVisualPlayer.playTone(morseToPlay[i]);
                    await Future.delayed(Duration(milliseconds: settingsContainer.settingsService.elementDuration));
                  } else {
                    break;  //Quits when isPlaying is set to false elsewhere in the app!
                  }
                }

                //Need to reset
                setState(() {
                  isPlaying = false;
                  iconData = iconPlay;
                });
              } else {
                ScaffoldMessenger
                    .of(context)
                    .showSnackBar(SnackBar(content: Text('Please select a method to play')));
              }
            }
          },
          icon: Icon(iconData),
        ),
      ],
    );
  }
}