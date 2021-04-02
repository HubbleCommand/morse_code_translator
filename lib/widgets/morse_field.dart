import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:keyboard_actions/keyboard_custom.dart';
import 'package:morse_code_translator/models/alphabet.dart';
import 'package:flutter/services.dart';

//MorseKeyboard2 is the only thing used here
class MorseKeyboard2 extends StatelessWidget
    with KeyboardCustomPanelMixin<String>
    implements PreferredSizeWidget {
  final ValueNotifier<String> notifier;

  MorseKeyboard2({Key key, this.notifier}) : super(key: key);

  Widget _buildButton({String text, String value}){
    return Expanded(
      child: OutlinedButton(
        onPressed: () {
          updateValue(notifier.value + value);
        },
        child: FittedBox(
          child: Text(
            text,
            style: TextStyle(
              //fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(100);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      child: Row(
        children: [
          _buildButton(text: '.', value: '.'),
          _buildButton(text: '-', value: '-'),
          _buildButton(text: 'CHAR SPACE', value: '   '),
          _buildButton(text: 'WORD SPACE', value: '       '),
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                updateValue(notifier.value.substring(0, notifier.value.length - 1));
              },
              onLongPress: () {
                updateValue('');
              },
              child: FittedBox(
                child: Icon(Icons.backspace)
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CounterKeyboard extends StatelessWidget
    with KeyboardCustomPanelMixin<String>
    implements PreferredSizeWidget {
  final ValueNotifier<String> notifier;

  CounterKeyboard({Key key, this.notifier}) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(200);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                int value = int.tryParse(notifier.value) ?? 0;
                value--;
                updateValue(value.toString());
              },
              child: FittedBox(
                child: Text(
                  "-",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                int value = int.tryParse(notifier.value) ?? 0;
                value++;
                updateValue(value.toString());
              },
              child: FittedBox(
                child: Text(
                  ".",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class MorseField extends StatefulWidget {
  final int elementDuration;
  final Alphabet alphabet;
  final Function textCallback;

  MorseField({Key key, this.elementDuration, this.alphabet, this.textCallback}) : super(key: key);

  @override
  _MorseFieldState createState() => _MorseFieldState();
}

class _MorseFieldState extends State<MorseField> {
  final _formKey = GlobalKey<FormState>();
  String _textToTranslate = '';
  String _textTranslated = '';

  TextEditingController textEditingController = TextEditingController();

  final FilteringTextInputFormatter morseCodeFilter = FilteringTextInputFormatter.allow(RegExp("[. -]"));

  _MorseFieldState(){
    //This seems to fix the issue of the cursor inserting chars at the second last index instead of at the end if the user hasn't placed the cursor in the text field
    textEditingController.selection = TextSelection.fromPosition(
      TextPosition(offset: 0, affinity: TextAffinity.upstream),
    );
  }

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

  void updateMorseCodeString(String text){
    var start = textEditingController.selection.start;
    var startWord = textEditingController.selection.toString();
    var fullWord = textEditingController.text;
    print('TEC Selection: $start');
    print('TEC SelectionWord: $startWord');
    print('TEC FullWord: "$fullWord"');

    int currentCursorPosition = textEditingController.selection.start;

    textEditingController.text = insertSymbolAtLocation(textEditingController.selection.start, textEditingController.text, text);

    textEditingController.selection = TextSelection.fromPosition(
      TextPosition(offset: currentCursorPosition + text.length, affinity: TextAffinity.upstream),
    );

    print('Setting text to: ' + textEditingController.text);
    setState(() {
      _textToTranslate = textEditingController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          key: _formKey,
          child: Column(
              children: <Widget>[
                TextFormField(
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
                  //onFieldSubmitted: (String value){_title=value;},
                  onSaved: (value) {
                    setState(() {
                      _textToTranslate = value;
                    });
                  },
                  onChanged: (value){
                    print('Value changed to: $value');
                    setState(() {
                      _textToTranslate = value;
                    });
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                      onPressed: (){
                        this.updateMorseCodeString('.');
                      },
                      child: Text('.'),
                    ),
                    OutlinedButton(
                      onPressed: (){
                        this.updateMorseCodeString('-');
                      },
                      child: Text('-'),
                    ),
                    OutlinedButton(
                      onPressed: (){
                        this.updateMorseCodeString('   ');
                      },
                      child: Text("CHAR SPACE"),
                    ),
                    OutlinedButton(
                      onPressed: (){
                        this.updateMorseCodeString('       ');
                      },
                      child: Text('WORD SPACE'),
                    ),
                  ],
                ),
              ]
          ),
        ),
      ],
    );
  }
}

class MorseKeyboard extends StatelessWidget{
  MorseKeyboard({
    Key key,
    this.onTextInput,
    this.onBackspace,
  }) : super(key: key);

  final ValueSetter<String> onTextInput;
  final VoidCallback onBackspace;

  void _textInputHandler(String value) => onTextInput?.call(value);

  void _backspaceHandler() => onBackspace?.call();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      color: Colors.blue,
      child: Row(
        children: [
          MorseKey(
            text: '.',
            value: '.',
            flex: 4,
            onTextInput: _textInputHandler,
          ),
          MorseKey(
            text: '-',
            value: '-',
            flex: 4,
            onTextInput: _textInputHandler,
          ),
          MorseKey(
            text: 'CHAR SPACE',
            value: '   ',
            flex: 4,
            onTextInput: _textInputHandler,
          ),
          MorseKey(
            text: 'WORD SPACE',
            value: '       ',
            flex: 4,
            onTextInput: _textInputHandler,
          ),
          BackspaceKey(
            onBackspace: _backspaceHandler,
          ),
        ],
      ),
    );
  }
}

class MorseKey extends StatelessWidget {
  const MorseKey({
    Key key,
    @required this.text,
    @required this.value,
    this.onTextInput,
    this.flex = 1,
  }) : super(key: key);

  final String text;
  final String value;
  final ValueSetter<String> onTextInput;
  final int flex;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Material(
          color: Colors.blue.shade300,
          child: InkWell(
            onTap: () {
              onTextInput?.call(value);
            },
            child: Container(
              child: Center(child: Text(text)),
            ),
          ),
        ),
      ),
    );
  }
}

class BackspaceKey extends StatelessWidget {
  const BackspaceKey({
    Key key,
    this.onBackspace,
    this.flex = 1,
  }) : super(key: key);

  final VoidCallback onBackspace;
  final int flex;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Material(
          color: Colors.blue.shade300,
          child: InkWell(
            onTap: () {
              onBackspace?.call();
            },
            child: Container(
              child: Center(
                child: Icon(Icons.backspace),
              ),
            ),
          ),
        ),
      ),
    );
  }
}