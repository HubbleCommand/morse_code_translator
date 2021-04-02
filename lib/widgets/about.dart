import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AboutWidget extends StatelessWidget {
  static const TextStyle headerStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
  static const TextStyle subHeaderStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 15);
  static const TextStyle paraStyle = TextStyle(fontSize: 15);

  final List<Widget> privacyPolicy = [
    Text('Privacy Policy', style: headerStyle),
    Text("""Third party vendors, including Google, use cookies to serve ads based on a user's prior visits to your website or other websites. Google's use of advertising cookies enables it and its partners to serve ads to your users based on their visit to your sites and/or other sites on the Internet. You may opt out by visiting your Google Ads Settings.\n""", style: paraStyle)
  ];

  final List<Widget> about = [
    Text("""This app will help you translate text into morse code, and vice versa.\n""", style: paraStyle),
    Text("""It also can flash your morse code with your device's light, play it with your buzzer, or with audio!\n""", style: paraStyle),
    Text("""\nTranslating to morse code""", style: headerStyle),
    Text("""\nJust type what you want to translate, and tap translate! The Morse Code translation will appear underneath.""", style: paraStyle),
    Text("""\nTranslating from morse code""", style: headerStyle),
    Text("""\nType the morse code you want translated, simplified with buttons to add standard morse symbols (., -, ).""", style: paraStyle),
    Text("""\nPlaying morse audiovisually""", style: headerStyle),
    Text("""\nJust tap the light, vibrate, and audio icons for the audiovisual representations you want, and hit the play button!""", style: paraStyle),
    Text("""\nAudiovisual methods may not work well if you set the element duration too small.""", style: paraStyle),
    Text("""\nCopy to clipboard""", style: headerStyle),
    Text("""\nEasily use the translation results by clicking the 'Copy to clipboard' button at the bottom!""", style: paraStyle),
    Text("""\nSettings""", style: headerStyle),
    Text("""\nElement duration""", style: subHeaderStyle),
    Text("""\nThe duration of Morse signals is defined by element duration. I.e. a dot is one element long, while a dash is three elements long. You can set how many milliseconds an element is, which can be needed if you want to use vibrations."""),
    Text("""\nMorse 'Alphabets'""", style: subHeaderStyle),
    Text("""\nYou can choose one of the three main Morse alphabets to translate with: the original Morse code,Gerken, and the modern ITU"""),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: kIsWeb ? privacyPolicy + about : about,
      ),
    );
  }
}
