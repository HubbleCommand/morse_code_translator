import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AlphabetPickerWidget extends StatefulWidget {
  final Function onAlphabetPickedCallback;
  AlphabetPickerWidget({Key key, @required this.onAlphabetPickedCallback}) : super(key: key);

  @override
  _AlphabetPickerWidgetState createState() => _AlphabetPickerWidgetState();
}

class _AlphabetPickerWidgetState extends State<AlphabetPickerWidget> {
  //TODO make more dynamic
  List<Alphabet> alphabets = [AlphabetOriginal(), AlphabetITU(), AlphabetGerke()];
  //List<bool> isSelected = [false, false, false];
  List<bool> isSelected = List.filled(alphabets.length, false);

  _buildButtons(alphabets){
    List<Widget> alphabetButtons;
    
    for(alphabet in alphabets) {
      String alphabetName = alphabet.name;
      alphabetButtons.add(Text('$alphabetName');
    }
    
    return alphabetButtons;
  }


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ToggleButtons(
          /*children: <Widget>[
            Text('Original),
            Text('ITU'),
            Text('Gerke'),
          ],*/
          children: _buildButtons(alphabets),
          onPressed: (int index) {
            setState(() {
              isSelected[index] = !isSelected[index];
              onAlphabetPickedCallback(alphabets[index]);
            });
          },
          isSelected: isSelected,
        ),
      ],
    );
  }
}
