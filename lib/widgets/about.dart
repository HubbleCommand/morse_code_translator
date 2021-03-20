import 'package:flutter/material.dart';

class AboutWidget extends StatelessWidget {
  static const TextStyle headerStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
  static const TextStyle paraStyle = TextStyle(fontSize: 15);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text("""This app will help you translate text into morse code, and vice versa.\n""", style: paraStyle),
          Text("""It also can flash your morse code with your device's light, play it with your buzzer, or with audio!\n""", style: paraStyle),
          Text("""\nTranslating to morse code""", style: headerStyle),
          Text("""\nJust type what you want to translate, and tap translate! The Morse Code translation will appear underneath.""", style: paraStyle),
          Text("""\nTranslating from morse code""", style: headerStyle),
          Text("""\nType the morse code you want translated, simplified with buttons to add standard morse symbols (., -, ).""", style: paraStyle),
          Text("""\nPlaying morse audiovisually""", style: headerStyle),
          Text("""\nJust tap the light, vibrate, and audio icons for each of the audiovisual representations you want (or none), and hit translate!""", style: paraStyle),
          Text("""\nCopy to clipboard""", style: headerStyle),
          Text("""\nEasily use the translation results by clicking the 'Copy to clipboard' button at the bottom!""", style: paraStyle),
        ],
      ),
    );
  }
}