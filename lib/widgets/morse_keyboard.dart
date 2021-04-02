import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:keyboard_actions/keyboard_custom.dart';

class MorseKeyboard extends StatelessWidget
    with KeyboardCustomPanelMixin<String>
    implements PreferredSizeWidget {
  final ValueNotifier<String> notifier;

  MorseKeyboard({Key key, this.notifier}) : super(key: key);

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
