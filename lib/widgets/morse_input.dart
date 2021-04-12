import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:morse_code_translator/widgets/audiovis_player.dart';

class MorseInputWidget extends StatefulWidget {
  final Function getValueCallback;
  final bool includeCustomInput;
  final int elementDuration;
  final TextEditingController morseEditingController;

  MorseInputWidget({Key key, @required this.getValueCallback, @required this.includeCustomInput, @required this.elementDuration, @required this.morseEditingController}) : super(key: key);

  @override
  _MorseInputWidgetState createState() => _MorseInputWidgetState();
}

class _MorseInputWidgetState extends State<MorseInputWidget> {
  final FilteringTextInputFormatter morseCodeCodeFilter = FilteringTextInputFormatter.allow(RegExp("[. -]"));

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
    int currentCursorPosition = widget.morseEditingController.selection.start;
    widget.morseEditingController.text = insertSymbolAtLocation(widget.morseEditingController.selection.start, widget.morseEditingController.text, symbol);
    widget.morseEditingController.selection = TextSelection.fromPosition(
      TextPosition(offset: currentCursorPosition + 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: widget.morseEditingController,
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

        widget.includeCustomInput ?
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
          elementDuration: widget.elementDuration,
          onPlayCallback: (){
            return widget.morseEditingController.text;
          },
        ),
      ],
    );
  }
}