import 'package:flutter/material.dart';
import 'package:morse_code_translator/widgets/about.dart';
import 'package:morse_code_translator/widgets/settings.dart';
import 'package:morse_code_translator/widgets/translate_from.dart';
import 'package:morse_code_translator/widgets/translate_to.dart';

void main() {
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
  int _currentIndex = 0;
  final List<Widget> _children = [
    TranslateToMorsePage(),
    TranslateFromMorsePage(),
  ];

  int elementDuration = 240;

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
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
                //Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new GreenFrog()));
                showDialog(
                    context: context,
                    builder: (BuildContext context){
                      return AlertDialog(
                        title: Text('App Settings'),
                        content: SettingsWidget(elementDuration: elementDuration, onElementDurationCallbackSelect: (int elementDuration){
                          print(elementDuration);
                          setState(() {
                            this.elementDuration = elementDuration;
                          });
                        },),
                      );
                    }
                );
              })
        ],
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.login),
            label: 'To Morse',
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.logout),
            label: 'From Morse',
          ),
        ],
      ),
    );
  }
}
