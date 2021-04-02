import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:morse_code_translator/widgets/audiovis_player.dart';
import 'package:morse_code_translator/widgets/banner_ad.dart';
import 'package:morse_code_translator/widgets/copy_clipboard.dart';
import 'package:morse_code_translator/widgets/morse_keyboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:morse_code_translator/widgets/about.dart';
import 'package:morse_code_translator/widgets/settings.dart';
import 'controllers/translator.dart';
import 'models/alphabet.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  runApp(MorseCodeTranslatorApp());
}

class MorseCodeTranslatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Morse Code Translator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MCTHomePage(title: 'Morse Code Translator'),
    );
  }
}

class MCTHomePage extends StatefulWidget {
  MCTHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MCTHomePageState createState() => _MCTHomePageState();
}

class _MCTHomePageState extends State<MCTHomePage> {
  int elementDuration = 240;  //int elementDuration = 240;
  Alphabet alphabet = AlphabetITU(); //Need default values...

  final FocusNode _nodeText7 = FocusNode();
  //This is only for custom keyboards
  final custom1Notifier = ValueNotifier<String>("");

  final FilteringTextInputFormatter morseCodeFilter = FilteringTextInputFormatter.allow(RegExp("[a-z A-Z 0-9]"));
  TextEditingController textEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  /// Creates the [KeyboardActionsConfig] to hook up the fields
  /// and their focus nodes to our [FormKeyboardActions].
  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey[200],
      nextFocus: false,
      actions: [
        KeyboardActionsItem(
          focusNode: _nodeText7,
          footerBuilder: (_) => MorseKeyboard(
            notifier: custom1Notifier,
          ),
        ),
      ],
    );
  }

  _MCTHomePageState(){
    textEditingController.selection = TextSelection.fromPosition(
      TextPosition(offset: 0, affinity: TextAffinity.upstream),
    );
  }

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      this.elementDuration = prefs.getInt('elementDuration') ?? 240;

      switch(prefs.getString('alphabet') ?? 'ITU'){
        case 'ITU' : {this.alphabet = AlphabetITU();}
        break;
        case 'Original' : {this.alphabet = AlphabetOriginal();}
        break;
        case 'Gerke' : {this.alphabet = AlphabetGerke();}
        break;
        default : {this.alphabet = AlphabetITU();}
        break;
      }
    });
  }

  Widget _buildAlphanumericInput(){
    return TextFormField(
      controller: textEditingController,
      decoration: InputDecoration(
          labelText: 'Enter the text to translate'
      ),
      inputFormatters: [morseCodeFilter],
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter some text';
        }
        return null;  //MUST RETURN NULL
      },
    );
  }

  Widget _buildMorseInput(){
    return KeyboardActions(
      tapOutsideToDismiss: true,
      config: _buildConfig(context),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              KeyboardCustomInput<String>(
                focusNode: _nodeText7,
                //height: 65, //Fixes text overflowing and not showing
                notifier: custom1Notifier,
                builder: (context, val, hasFocus) {
                  return Container(
                    alignment: Alignment.center,
                    color: hasFocus ? Colors.grey[300] : Colors.white,
                    child: Text(
                      val,
                      style:  TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTranslateToAlphaButton (Orientation orientation) {
    return IconButton(
        onPressed: (){
          try{
            print('Translate to alphanumeric');
            print('Value: ' + custom1Notifier.value);
            setState(() {
              var translated = Translator.translateFromMorse(custom1Notifier.value, alphabet);
              print('Translated: $translated');
              //_alphaString = translated;
              textEditingController.text = translated;
            });
          } on TranslationError catch (e) {
            print(e.cause);
            textEditingController.text = '';
            ScaffoldMessenger
                .of(context)
                .showSnackBar(SnackBar(content: Text('Malformed morse code : ' + e.cause)));
          }
        },
        icon: Icon(orientation == Orientation.portrait ? Icons.arrow_upward : Icons.arrow_back)
    );
  }

  Widget _buildTranslateToMorseButton(Orientation orientation) {
    return IconButton(
        onPressed: (){
          try {
            print('Translate to morse');
            print('Value: ' + textEditingController.text);
            custom1Notifier.value = Translator.translateToMorse(textEditingController.text, alphabet);
          } on TranslationError catch (e) {
            print(e.cause);
            custom1Notifier.value = '';
            ScaffoldMessenger
                .of(context)
                .showSnackBar(SnackBar(content: Text('Malformed text : ' + e.cause)));
          }
        },
        icon: Icon(orientation == Orientation.landscape ?  Icons.arrow_forward :  Icons.arrow_downward)
    );
  }

  Widget _buildLandscape(){
    return Container(
      child: Form(
        key: _formKey,
        child: Row(
          children: [
            RotatedBox(
              quarterTurns: 3,
              child: BannerAdWidget(adSize: AdSize.banner),
            ),
            Expanded(flex: 5, child: Row(
              children: [
                Expanded(child: _buildAlphanumericInput()),
                CopyToClipboardWidget(
                  message: 'Text copied to clipboard',
                  onTapCopy: (){
                    return textEditingController.text;
                  },
                ),
              ],
            ),),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTranslateToAlphaButton(Orientation.landscape),
                _buildTranslateToMorseButton(Orientation.landscape),
              ],
            ),
            Expanded(flex: 5, child: Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Expanded(child: Row(
                    children: [
                      Expanded(child: Align(
                          alignment: Alignment.center,
                          child: _buildMorseInput()
                      ),),
                      CopyToClipboardWidget(
                        message: 'Morse copied to clipboard',
                        onTapCopy: (){
                          return custom1Notifier.value;
                        },
                      ),
                    ],
                  ),),
                  AudioVisualPlayerWidget(
                    elementDuration: elementDuration,
                    onPlayCallback: (){
                      return custom1Notifier.value;
                    },
                  ),
                ],
              ),
            ),),
          ],
        ),
      ),
    );
  }

  Widget _buildPortrait(){
    return Container(
      child: Form(
        key: _formKey,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              BannerAdWidget(),
              //Spacer(),
              Expanded(child: Row(
                children: [
                  Expanded(child: Align(
                      alignment: Alignment.center,
                      child: _buildAlphanumericInput()
                  ),),
                  CopyToClipboardWidget(
                    message: 'Text copied to clipboard',
                    onTapCopy: (){
                      return textEditingController.text;
                    },
                  ),
                ],
              ),),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTranslateToAlphaButton(Orientation.landscape),
                  _buildTranslateToMorseButton(Orientation.landscape),
                ],
              ),
              Expanded(child: Row(
                children: [
                  Expanded(child: _buildMorseInput(),),
                  CopyToClipboardWidget(
                    message: 'Morse copied to clipboard',
                    onTapCopy: (){
                      return custom1Notifier.value;
                    },
                  ),
                ],
              )),
              AudioVisualPlayerWidget(
                elementDuration: elementDuration,
                onPlayCallback: (){
                  return custom1Notifier.value;
                },
              ),
            ]
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
              icon: Icon(Icons.info),
              onPressed: (){
                showDialog(
                    context: context,
                    builder: (BuildContext context){
                      return AlertDialog(
                        title: Text('About this app'),
                        content: AboutWidget(),
                      );
                    }
                );
              }
          ),
          IconButton(
              icon: Icon(Icons.settings),
              onPressed: (){
                showDialog(
                    context: context,
                    builder: (BuildContext context){
                      return AlertDialog(
                        title: Text('App Settings'),
                        content: SettingsWidget(
                          alphabet: this.alphabet,
                          elementDuration: this.elementDuration,
                          onElementDurationCallback: (int elementDuration){
                            print(elementDuration);
                            setState(() {
                              this.elementDuration = elementDuration;
                            });
                          },
                          onAlphabetCallback : (Alphabet alphabet) {
                            print(alphabet.name);
                            setState(() {
                              this.alphabet = alphabet;
                            });
                          }
                        ),
                      );
                    }
                );
              })
        ],
      ),
      body: OrientationBuilder(
        builder: (context, orientation){
          _nodeText7.unfocus(); //Fixes keyboard going jank when rotating the phone (when the morse keyboard is present)
          if(orientation == Orientation.landscape){
            return _buildLandscape();
          } else {
            return _buildPortrait();
          }
        },
      )
    );
  }
}
