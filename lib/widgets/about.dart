import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:auto_localization/auto_localization.dart';

class AboutWidget extends StatelessWidget {
  static const TextStyle headerStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
  static const TextStyle subHeaderStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 15);
  static const TextStyle paraStyle = TextStyle(fontSize: 15, color: Colors.black);

  final List<Widget> privacyPolicy = [
    Text('Privacy Policy', style: headerStyle),
    Text("""Third party vendors, including Google, use cookies to serve ads based on a user's prior visits to your website or other websites. Google's use of advertising cookies enables it and its partners to serve ads to your users based on their visit to your sites and/or other sites on the Internet. You may opt out by visiting your Google Ads Settings.\n""", style: paraStyle)
  ];

  final List<Widget> about = [
    RichText(
      text: new TextSpan(
        children: [
          new TextSpan(text: 'Please visit the ', style: paraStyle,),
          new TextSpan(text: 'Morse Wikipedia page ', style: new TextStyle(color: Colors.blue),
            recognizer: new TapGestureRecognizer()
              ..onTap = () { launch('https://en.wikipedia.org/wiki/Morse_code');
              },
          ),
          new TextSpan(text: 'for more information on how morse works.', style: paraStyle,),
        ],
      ),
    ),
    Text("""This app will help you translate text into morse code, and vice versa.\n""", style: paraStyle),
    Text("""It also can flash your morse code with your device's light, play it with your buzzer, or with audio!\n""", style: paraStyle),
    Text("""\nTranslating to morse code""", style: headerStyle),
    Text("""\nJust type what you want to translate, and tap translate! The Morse Code translation will appear underneath.""", style: paraStyle),
    Text("""\nTranslating from morse code""", style: headerStyle),
    Text("""\nType the morse code you want translated, simplified with buttons to add standard morse symbols (dots and dashes).""", style: paraStyle),
    Text("""\nPlaying morse audiovisually""", style: headerStyle),
    Text("""\nJust tap the light, vibrate, and audio icons for the audiovisual representations you want, and hit the play button!""", style: paraStyle),
    Text("""\nAudiovisual methods may not work well if you set the element duration too small due to device limitations.""", style: paraStyle),
    Text("""\nCopy to clipboard""", style: headerStyle),
    Text("""\nEasily use the translation results by clicking the 'Copy to clipboard' button at the bottom!""", style: paraStyle),
    Text("""\nSettings""", style: headerStyle),
    Text("""\nElement duration""", style: subHeaderStyle),
    Text("""\nThe duration of Morse signals is defined by element duration. A dot is one element long, while a dash is three elements long. You can set how many milliseconds an element is, which can be needed if you want to use vibrations."""),
    Text("""\nMorse 'Alphabets'""", style: subHeaderStyle),
    Text("""\nYou can choose one of the three main Morse alphabets to translate with: the original Morse code, Gerke, and the modern ITU"""),
  ];

  Widget _buildWithPadding(Widget widget){
    return Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 20), child: widget,);
  }

  Widget _buildWithPaddingHeader(Widget widget){
    return Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0), child: widget,);
  }

  Widget _buildTranslated() {
    return AutoLocalBuilder(
        text: const [
        "Please visit the ",
        'Morse Wikipedia page ',
        'for more information on how morse works.',
        """This app will help you translate text into morse code, and vice versa.\n""",
        """It also can flash your morse code with your device's light, play it with your buzzer, or with audio!\n""",
        """\nTranslating to morse code""",
        """\nJust type what you want to translate, and tap translate! The Morse Code translation will appear underneath.""",
        """\nTranslating from morse code""",
        """\nType the morse code you want translated, simplified with buttons to add standard morse symbols (dots and dashes).""",
        """\nPlaying morse audiovisually""",
        """\nJust tap the light, vibrate, and audio icons for the audiovisual representations you want, and hit the play button!""",
        """\nAudiovisual methods may not work well if you set the element duration too small due to device limitations.""",
        """\nSettings""",
        """\nElement duration""",
        """\nThe duration of Morse signals is defined by element duration. A dot is one element long, while a dash is three elements long. You can set how many milliseconds an element is, which can be needed if you want to use vibrations.""",
        """\nMorse 'Alphabets'""",
        """\nYou can choose one of the three main Morse alphabets to translate with: the original Morse code, Gerke, and the modern ITU"""
      ]
      , builder: (TranslationWorker tw) {
      return Column(
        children: [
          _buildWithPadding(RichText(
            text: new TextSpan(
              children: [
                new TextSpan(text: tw.getById(0), style: paraStyle,),
                new TextSpan(
                  text: tw.getById(1), style: new TextStyle(color: Colors.blue),
                  recognizer: new TapGestureRecognizer()
                    ..onTap = () {
                      launch('https://en.wikipedia.org/wiki/Morse_code');
                    },
                ),
                new TextSpan(text: tw.getById(2), style: paraStyle,),
              ],
            ),
          )),
          _buildWithPadding(Text(tw.getById(3), style: paraStyle)),
          _buildWithPadding(Text(tw.getById(4), style: paraStyle)),
          _buildWithPaddingHeader(Text(tw.getById(5), style: headerStyle)),
          _buildWithPadding(Text(tw.getById(6), style: paraStyle)),
          _buildWithPaddingHeader(Text(tw.getById(7), style: headerStyle)),
          _buildWithPadding(Text(tw.getById(8), style: paraStyle)),
          _buildWithPaddingHeader(Text(tw.getById(9), style: headerStyle)),
          _buildWithPadding(Text(tw.getById(10), style: paraStyle)),
          _buildWithPadding(Text(tw.getById(11), style: paraStyle)),
          _buildWithPadding(Text(tw.getById(12), style: headerStyle)),
          _buildWithPaddingHeader(Text(tw.getById(13), style: subHeaderStyle)),
          _buildWithPadding(Text(tw.getById(14))),
          _buildWithPaddingHeader(Text(tw.getById(15), style: subHeaderStyle)),
          _buildWithPadding(Text(tw.getById(16))),
        ],
      );
    },);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: _buildTranslated()
    );
  }
}
