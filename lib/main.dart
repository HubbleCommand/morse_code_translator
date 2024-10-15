import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:morse_code_translator/widgets/audiovis_player.dart';
import 'package:morse_code_translator/widgets/banner_ad.dart';
import 'package:morse_code_translator/widgets/copy_clipboard.dart';
import 'package:morse_code_translator/widgets/morse_input.dart';
import 'package:morse_code_translator/widgets/about.dart';
import 'package:morse_code_translator/widgets/settings.dart';
import 'package:morse_code_translator/controllers/translator.dart';
import 'package:morse_code_translator/models/alphabet.dart';

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
  MCTHomePage({super.key, required this.title});

  final String title;

  @override
  _MCTHomePageState createState() => _MCTHomePageState();
}

class _MCTHomePageState extends State<MCTHomePage> {
  //Need default values...
  int elementDuration = 240;                //The user-defined duration of each Morse element (in milliseconds)
  Alphabet alphabet = AlphabetITU();        //User-chosen Morse alphabet used to translate
  bool morseOrNot = false;                  //Whether or not we are translating morse to alpha
  String _translatedText = '';              //The translated text, no matter the type (morse or alphanumeric), needs a default value or shows null
  final _formKey = GlobalKey<FormState>();  //The form key

  //Styles for switch
  MaterialColor selectedAreaColor = Colors.blue;  //The background color if the item is selected
  Color selectedTextColor = Colors.white;

  //Controllers & formatters for alphanumeric input
  //AlphanumericFilter needs to take in any valid symbol OF THE CHOSEN ALPHABET
  FilteringTextInputFormatter alphanumericFilter = FilteringTextInputFormatter.allow(RegExp("[a-z A-Z 0-9]"));  //NOT final as we want to be able to change it to match a user chosen alphabet
  TextEditingController textEditingController = TextEditingController();

  //Controllers & formatters for morse input
  final FilteringTextInputFormatter morseCodeCodeFilter = FilteringTextInputFormatter.allow(RegExp("[. -]"));
  TextEditingController morseEditingController = TextEditingController();

  //Callback function used to sometimes send value to / from morseInputWidget (?)
  Function getMorseInputValue = (String morseInputValue){
    return morseInputValue;
  };

  @override
  void initState() {
    super.initState();
    //Get the user-saved preferences from other sessions
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
      print(alphabet.getValidRegex());
      alphanumericFilter = FilteringTextInputFormatter.allow(RegExp(alphabet.getValidRegex()));
    });
  }

  Widget _buildAlphanumericInput(){
    return TextFormField(
      controller: textEditingController,
      decoration: InputDecoration(
          labelText: "Enter text to translate to Morse"
      ),
      inputFormatters: [alphanumericFilter],
      validator: (value) {
        if (value != null && value.isEmpty) {
          return "Please enter some text";
        }
        return null;  //MUST RETURN NULL
      },
    );
  }

  Widget _buildMorseInput(bool includeCustomInput){
    return MorseInputWidget(
      getValueCallback: getMorseInputValue,
      includeCustomInput: includeCustomInput,
      elementDuration: elementDuration,
      morseEditingController: morseEditingController,
    );
  }

  Widget _buildSwitcher(){  //Builds the Widget that switches between Alphanumeric and Morse input
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            decoration: new BoxDecoration(
                color: morseOrNot ? null : selectedAreaColor,
                borderRadius: new BorderRadius.all(Radius.circular(10.0))
            ),
            child: new Center(
                child: new Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Alphanumeric", style: TextStyle(color: morseOrNot ? null : selectedTextColor)),
                )
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.sync_alt),
          onPressed: (){
            print('Applying new style...');
            print(morseOrNot);
            setState(() {
              morseOrNot = ! morseOrNot;
              _translatedText = '';
            });
          }
        ),
        Expanded(
          child:Container(
            decoration: new BoxDecoration(
                color: morseOrNot ? selectedAreaColor : null,
                borderRadius: new BorderRadius.all(Radius.circular(10.0))
            ),
            child: Center(
                child: new Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Morse", style: TextStyle(color: morseOrNot ? selectedTextColor : null)),
                )
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultingText(){ //Builds the Widget(s) where the translated text is displayed
    return Expanded(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: new BoxDecoration(
                      color: Colors.grey[350],
                      borderRadius: new BorderRadius.all(Radius.circular(10.0))
                  ),
                  child: Center(
                      child: new Padding(
                        padding: EdgeInsets.all(8.0),
                        child: new Text("$_translatedText"),
                      )
                  ),
                ),
              ),
              CopyToClipboardWidget(
                message: 'Text copied to clipboard',
                onTapCopy: (){
                  return _translatedText;
                },
              ),
            ],
          ),
          morseOrNot ? Container() : AudioVisualPlayerWidget(
            elementDuration: elementDuration,
            onPlayCallback: (){
              return _translatedText;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTranslateButton({required Widget icon}){
    return ElevatedButton(
        onPressed: (){
          try {
            print('Translate to morse');
            print('Value: ' + textEditingController.text);

            String temp;
            if(morseOrNot){
              temp = Translator.translateFromMorse(morseEditingController.text, alphabet);
            } else {
              temp = Translator.translateToMorse(textEditingController.text, alphabet);
            }

            setState(() {
              _translatedText = temp;
            });
          } on TranslationError catch (e) {
            setState(() {
              _translatedText = '';
            });
            print(e.cause);
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('Malformed text : ' + e.cause)));
          }
        },
        child: icon
    );
  }

  Widget _buildPortrait(){  //Builds the app for Portrait orientations
    return Container(
      child: Form(
        key: _formKey,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //BannerAdWidget(),
              _buildSwitcher(),
              Expanded(child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: morseOrNot ? _buildMorseInput(true) : _buildAlphanumericInput(),
                  ),
                  CopyToClipboardWidget(
                    message: 'Text copied to clipboard',
                    onTapCopy: (){
                      return morseOrNot ? morseEditingController.text : textEditingController.text;
                    },
                  ),
                ],
              ),),
              _buildTranslateButton(
                icon: Text("Translate"),
              ),
              _buildResultingText(),
            ]
        ),
      ),
    );
  }

  Widget _buildLandscape(){ //Builds the app for Landscape orientations
    return Container(
      child: Form(
        key: _formKey,
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              /*RotatedBox( //Rotates ad 90 degrees while widget is being built, so placement is known, unlike with Transform, where the child will be placed ugily overtop
                quarterTurns: 3,
                child: BannerAdWidget(),
              ),*/
              Expanded(
                child: Column(
                  children: [
                    _buildSwitcher(),
                    Row(
                      children: [
                        Expanded(child:
                          Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: morseOrNot ? _buildMorseInput(true) : _buildAlphanumericInput(),
                                  ),
                                  CopyToClipboardWidget(
                                    message: 'Text copied to clipboard',
                                    onTapCopy: (){
                                      return morseOrNot ? morseEditingController.text : textEditingController.text;
                                    },
                                  ),
                                ],
                              ),
                            ],
                          )
                        ),
                        _buildTranslateButton(icon: Icon(Icons.arrow_forward)),
                        _buildResultingText(),
                      ],
                    ),
                  ],
                ),
              )
            ]
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,//Stops keyboard popping up from resizing screen
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
                          title: Text("About this app"),
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
                            title: Text("App Settings"),
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
                                  print(alphabet.getValidRegex());
                                  this.alphanumericFilter = FilteringTextInputFormatter.allow(RegExp(alphabet.getValidRegex()));
                                });
                              }
                            ),
                          );
                        }
                    );
                  }
            )
          ],
      ),
      body: OrientationBuilder(
        builder: (context, orientation){
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
