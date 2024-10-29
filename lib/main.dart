import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:morse_code_translator/services/settings_service.dart';
import 'package:morse_code_translator/services/state_service.dart';
import 'package:morse_code_translator/widgets/settings_container.dart';

import 'package:morse_code_translator/widgets/audiovis_player.dart';
import 'package:morse_code_translator/widgets/copy_clipboard.dart';
import 'package:morse_code_translator/widgets/morse_input.dart';
import 'package:morse_code_translator/widgets/about.dart';
import 'package:morse_code_translator/widgets/settings.dart';
import 'package:morse_code_translator/widgets/state_container.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  runApp(MorseCodeTranslatorApp());
}

class MorseCodeTranslatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SettingsContainer(
        settingsService: SettingsService(),
        child: StateContainer(
            stateService: StateService(),
            child: MaterialApp(
              title: 'Morse Code Translator',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              home: MCTHomePage(title: 'Morse Code Translator'),
            )
        )
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
  Widget _buildAlphanumericInput(){
    return TextFormField(
      controller: stateService.textEditingController,
      decoration: InputDecoration(
          labelText: "Enter text to translate to Morse"
      ),
      inputFormatters: [settingsService.alphabetFilter],
      validator: (value) {
        if (value != null && value.isEmpty) {
          return "Please enter some text";
        }
        return null;  //MUST RETURN NULL
      },
    );
  }

  Widget _buildSwitcher(){  //Builds the Widget that switches between Alphanumeric and Morse input
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            decoration: new BoxDecoration(
                color: stateService.toMorse ? null : stateService.selectedAreaColor,
                borderRadius: new BorderRadius.all(Radius.circular(10.0))
            ),
            child: new Center(
                child: new Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Alphanumeric", style: TextStyle(color: stateService.toMorse ? null : stateService.selectedTextColor)),
                )
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.sync_alt),
          onPressed: (){
            stateService.toggleMorse();
          }
        ),
        Expanded(
          child:Container(
            decoration: new BoxDecoration(
                color: stateService.toMorse ? stateService.selectedAreaColor : null,
                borderRadius: new BorderRadius.all(Radius.circular(10.0))
            ),
            child: Center(
                child: new Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Morse", style: TextStyle(color: stateService.toMorse ? stateService.selectedTextColor : null)),
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
                        child: new Text("${stateService.translated}"),
                      )
                  ),
                ),
              ),
              CopyToClipboardWidget(
                message: 'Text copied to clipboard',
                onTapCopy: (){
                  return stateService.translated;
                },
              ),
            ],
          ),
          stateService.toMorse ? Container() : AudioVisualPlayerWidget(),
        ],
      ),
    );
  }

  Widget _buildTranslateButton({required Widget icon}){
    return ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: stateService.error != null ? stateService.errorColor : Colors.blue),
        onPressed: (){
          stateService.translate(settingsService.alphabet);
        },
        child: icon
    );
  }

  Widget _buildPortrait(){  //Builds the app for Portrait orientations
    return Container(
      child: Form(
        key: stateService.formKey,
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
                    child: stateService.toMorse ? MorseInputWidget() : _buildAlphanumericInput(),
                  ),
                  CopyToClipboardWidget(
                    message: 'Text copied to clipboard',
                    onTapCopy: (){
                      return stateService.toMorse ? stateService.morseEditingController.text : stateService.textEditingController.text;
                    },
                  ),
                ],
              ),),
              _buildTranslateButton(
                icon: Text(stateService.error != null ? "Error translating" : "Translate"),
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
        key: stateService.formKey,
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
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
                                    child: stateService.toMorse ? MorseInputWidget() : _buildAlphanumericInput(),
                                  ),
                                  CopyToClipboardWidget(
                                    message: 'Text copied to clipboard',
                                    onTapCopy: (){
                                      return stateService.toMorse ? stateService.morseEditingController.text : stateService.textEditingController.text;
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

  late SettingsService settingsService;
  late StateService stateService;

  @override
  Widget build(BuildContext context) {
    settingsService = SettingsContainer.of(context).settingsService;
    stateService = StateContainer.of(context).stateService;

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
                            content: SettingsWidget(),
                          );
                        }
                    );
                  }
            )
          ],
      ),
      body:
      ListenableBuilder(
        listenable:  Listenable.merge([settingsService, stateService]),
        builder: (BuildContext context, Widget? child){
          return OrientationBuilder(
            builder: (context, orientation){
              if(orientation == Orientation.landscape){
                return _buildLandscape();
              } else {
                return _buildPortrait();
              }
            },
          );
        },
      )
    );
  }
}
