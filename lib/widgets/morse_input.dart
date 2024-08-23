import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:morse_code_translator/widgets/audiovis_player.dart';
import 'package:auto_localization/auto_localization.dart';  //TODO pass the text values, it is bad practice to have an external dependency here... or just ignore?

class MorseInputWidget extends StatefulWidget {
  final Function getValueCallback;
  final bool includeCustomInput;
  final int elementDuration;
  final TextEditingController morseEditingController;
  final FilteringTextInputFormatter _morseCodeCodeFilter = FilteringTextInputFormatter.allow(RegExp("[. -]"));

  MorseInputWidget({super.key, required this.getValueCallback, required this.includeCustomInput, required this.elementDuration, required this.morseEditingController});

  @override
  _MorseInputWidgetState createState() => _MorseInputWidgetState();
}

class _MorseInputWidgetState extends State<MorseInputWidget> {
  String _insertSymbolAtLocation(int index, String text, String symbol){
    print(index);
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

  void _doInsertSymbol(String symbol){
    int currentCursorPosition = widget.morseEditingController.selection.start;
    widget.morseEditingController.text = _insertSymbolAtLocation(currentCursorPosition, widget.morseEditingController.text, symbol);

    if(currentCursorPosition <= 0){//Handles if selection index is -1, i.e. if the user hasn't touched the TextField yet
      widget.morseEditingController.selection = TextSelection.fromPosition(
        TextPosition(offset: symbol.length),
      );
    } else {
      widget.morseEditingController.selection = TextSelection.fromPosition(
        TextPosition(offset: currentCursorPosition + symbol.length),
      );
    }
  }

  Widget _buildButton({required String symbol, required String value}){
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blueAccent),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(symbol),
      ),
      onTap: (){_doInsertSymbol(value);},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /*TextFormField(
          controller: widget.morseEditingController,
          decoration: InputDecoration(
            labelText: 'Enter Morse to translate to alphanumeric',
          ),
          inputFormatters: [widget._morseCodeCodeFilter],
          toolbarOptions: ToolbarOptions(
              copy: true
          ),
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter some text';
            }
            return null;  //MUST RETURN NULL
          },
        ),*/
        /*AutoLocalBuilder(
          text: ['Enter Morse Code to translate to alphanumeric', 'Please enter some text'],
          builder: (TranslationWorker tw){
            return TextFormField(
              controller: widget.morseEditingController,
              decoration: InputDecoration(
                labelText: tw.getById(0),
              ),
              inputFormatters: [widget._morseCodeCodeFilter],
              validator: (value) {
                if (value != null && value.isEmpty) {
                  return tw.getById(1);
                }
                return null;  //MUST RETURN NULL
              },
            );
      },),*/
        TextFormField(
        controller: widget.morseEditingController,
        decoration: InputDecoration(
          labelText: "Enter Morse Code to translate to alphanumeric",
        ),
        inputFormatters: [widget._morseCodeCodeFilter],
        validator: (value) {
          if (value != null && value.isEmpty) {
            return "Please enter some text";
          }
          return null;  //MUST RETURN NULL
        },
      ),

        widget.includeCustomInput ?
        Wrap(
          children: [
            _buildButton(symbol: '.', value: '.'),
            _buildButton(symbol: '-', value: '-'),
            _buildButton(symbol:'CHAR SPACE', value: '   '),
            _buildButton(symbol:'WORD SPACE', value: '       '),
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