import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:morse_code_translator/widgets/audiovis_player.dart';
import 'package:morse_code_translator/widgets/banner_ad.dart';
import 'package:morse_code_translator/widgets/copy_clipboard.dart';
import 'package:morse_code_translator/widgets/morse_input.dart';
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
  //Need default values...
  int elementDuration = 240;
  Alphabet alphabet = AlphabetITU();

  final FilteringTextInputFormatter morseCodeFilter = FilteringTextInputFormatter.allow(RegExp("[a-z A-Z 0-9]"));
  TextEditingController textEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
    });
  }

  Widget _buildAlphanumericInput(){
    return TextFormField(
      controller: textEditingController,
      decoration: InputDecoration(
          labelText: 'Enter text to translate to Morse'
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

  final FilteringTextInputFormatter morseCodeCodeFilter = FilteringTextInputFormatter.allow(RegExp("[. -]"));
  TextEditingController morseEditingController = TextEditingController();

  String insertSymbolAtLocation(int index, String text, String symbol){
    if(index <= 0){
      return symbol += text;
    } else if (index >= text.length){
      return text += symbol;
    } else {
      String first = text.substring(0, index);
      String last = text.substring(index);
      return first + symbol + last;
    }
  }

  void doInsertSymbol(String symbol){
    int currentCursorPosition = morseEditingController.selection.start;
    morseEditingController.text = insertSymbolAtLocation(morseEditingController.selection.start, morseEditingController.text, symbol);
    morseEditingController.selection = TextSelection.fromPosition(
      TextPosition(offset: currentCursorPosition + 1),
    );
  }

  Function getMorseInputValue = (String morseInputValue){
    return morseInputValue;
  };

  Widget _buildMorseInput(bool includeCustomInput){
    return MorseInputWidget(
      getValueCallback: getMorseInputValue,
      includeCustomInput: includeCustomInput,
      elementDuration: elementDuration,
      morseEditingController: morseEditingController,
    );
    /*return Column(
      children: [
        TextFormField(
          controller: morseEditingController,
          decoration: InputDecoration(
            labelText: 'Enter Morse to translate to alphanumeric',
          ),
          inputFormatters: [morseCodeCodeFilter],
          toolbarOptions: ToolbarOptions(
            copy: true
          ),
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter some text';
            }
            return null;  //MUST RETURN NULL
          },
        ),

        includeCustomInput ?
        Wrap(
          children: [
            OutlinedButton(
              child: Text('.'),
              onPressed: (){doInsertSymbol('.');},
            ),
            OutlinedButton(
              child: Text('-'),
              onPressed: (){doInsertSymbol('-');},
            ),
            OutlinedButton(
              child: Text("CHAR SPACE"),
              onPressed: (){doInsertSymbol('   ');},
            ),
            OutlinedButton(
              child: Text('WORD SPACE'),
              onPressed: (){doInsertSymbol('       ');},
            ),
          ],
        ) : Container(),
        AudioVisualPlayerWidget(
          elementDuration: elementDuration,
          onPlayCallback: (){
            return morseEditingController.text;
          },
        ),
      ],
    );*/

  }

  Widget _buildTranslateToAlphaButton (Orientation orientation) {
    return IconButton(
        onPressed: (){
          try{
            print('Translate to alphanumeric');
            setState(() {
              var translated = Translator.translateFromMorse(morseEditingController.text, alphabet);
              print('Translated: $translated');
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
            String morseString = Translator.translateToMorse(textEditingController.text, alphabet);
            morseEditingController.text = morseString;
          } on TranslationError catch (e) {
            print(e.cause);
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
      child: /*Form(
        key: _formKey,
        child: */Row(
          children: [
            RotatedBox( //Rotates ad 90 degrees while widget is being built, so placement is known, unlike with Transform, where the child will be placed ugily overtop
              quarterTurns: 3,
              child: BannerAdWidget(adSize: AdSize.banner),
            ),
            Padding(padding: EdgeInsets.all(6.0),), //Creates space between ad and Alphanumeric input area
            Expanded(flex: 5,
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Text('Alphanumeric'),
                  Row(
                    children: [
                      Expanded(child: _buildAlphanumericInput()),
                      CopyToClipboardWidget(
                        message: 'Text copied to clipboard',
                        onTapCopy: (){
                          return textEditingController.text;
                        },
                      ),
                    ],
                  ),
                ],
              )
            ),
            Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTranslateToAlphaButton(Orientation.landscape),
                _buildTranslateToMorseButton(Orientation.landscape),
              ],
            ),
            Expanded(
              flex: 5,
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /*Expanded(
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Text('Morse'),
                    ),
                  ),*/
                  Expanded(
                    flex: 1,
                    child:
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(child: _buildMorseInput(false)),
                        CopyToClipboardWidget(
                          message: 'Morse copied to clipboard',
                          onTapCopy: (){
                            return morseEditingController.text;
                          },
                        ),
                      ],
                    ),
                  ),
                  AudioVisualPlayerWidget(
                    elementDuration: elementDuration,
                    onPlayCallback: (){
                      return morseEditingController.text;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      //),
    );
  }

  bool morseOrNot = false;

  MaterialColor selectedColor = Colors.blue;

  Widget _buildSwitcher(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            decoration: new BoxDecoration(
                color: morseOrNot ? null : selectedColor,
                borderRadius: new BorderRadius.all(Radius.circular(10.0))
            ),
            child: new Center(
                child: new Padding(
                  padding: EdgeInsets.all(8.0),
                  child: new Text("Alphanumeric"),
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
                color: morseOrNot ? selectedColor : null,
                borderRadius: new BorderRadius.all(Radius.circular(10.0))
            ),
            child: Center(
                child: new Padding(
                  padding: EdgeInsets.all(8.0),
                  child: new Text("Morse"),
                )
            ),
          ),
        ),
      ],
    );
  }

  String _translatedText;

  Widget _buildResultingText(){
    return Expanded(
      child: Column(
        children: [
          //Text('$_translatedText'),
          Container(
            decoration: new BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: new BorderRadius.all(Radius.circular(10.0))
            ),
            child: Center(

                child: new Padding(
                  padding: EdgeInsets.all(8.0),
                  child: new Text("$_translatedText"),
                )
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              morseOrNot ? Container() : AudioVisualPlayerWidget(
                elementDuration: elementDuration,
                onPlayCallback: (){
                  return _translatedText;
                },
              ),
              CopyToClipboardWidget(
                message: 'Text copied to clipboard',
                onTapCopy: (){
                  return _translatedText;
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTranslateButton({Widget icon = const Text('Translate')}){
    return ElevatedButton(
        onPressed: (){
          try {
            print('Translate to morse');
            print('Value: ' + textEditingController.text);

            String temp;
            if(morseOrNot){
              String morseString = Translator.translateFromMorse(morseEditingController.text, alphabet);
              temp = morseString;
            } else {
              String morseString = Translator.translateToMorse(textEditingController.text, alphabet);
              temp = morseString;
            }
            setState(() {
              _translatedText = temp;
            });
          } on TranslationError catch (e) {
            print(e.cause);
            ScaffoldMessenger
                .of(context)
                .showSnackBar(SnackBar(content: Text('Malformed text : ' + e.cause)));
          }
        },
        child: icon
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
              _buildSwitcher(),
              //Spacer(),
              Expanded(child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      //child: _buildAlphanumericInput()
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
              /*Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTranslateToAlphaButton(Orientation.portrait),
                  _buildTranslateToMorseButton(Orientation.portrait),
                ],
              ),*/
              _buildTranslateButton(),
              _buildResultingText(),
              /*Expanded(child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildMorseInput(false)),
                  CopyToClipboardWidget(
                    message: 'Morse copied to clipboard',
                    onTapCopy: (){
                      return morseEditingController.text;
                    },
                  ),
                ],
              )),
              AudioVisualPlayerWidget(
                elementDuration: elementDuration,
                onPlayCallback: (){
                  return morseEditingController.text;
                },
              ),*/
            ]
        ),
      ),
    );
  }

  Widget _buildLandscape2(){
    return Container(
      child: Form(
        key: _formKey,
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RotatedBox( //Rotates ad 90 degrees while widget is being built, so placement is known, unlike with Transform, where the child will be placed ugily overtop
                quarterTurns: 3,
                child: BannerAdWidget(adSize: AdSize.banner),
              ),
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
                                    //child: _buildAlphanumericInput()
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
          if(orientation == Orientation.landscape){
            return _buildLandscape2();
          } else {
            return _buildPortrait();
          }
        },
      )
    );
  }
}
