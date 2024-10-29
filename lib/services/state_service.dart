import 'package:flutter/material.dart';
import 'package:morse_code_translator/models/alphabet.dart';

import '../controllers/translator.dart';

class StateService extends ChangeNotifier {
  bool _toMorse = false;
  String _input = "";
  String _translated = "";
  TranslationError? _error = null;

  bool get toMorse => _toMorse;
  String get input => _input;
  String get translated => _translated;
  TranslationError? get error => _error;

  //State adjacent, final states
  final formKey = GlobalKey<FormState>();  //The form key
  final bool buildCustomMorseInput = false;
  //Styles for switch
  final MaterialColor selectedAreaColor = Colors.blue;  //The background color if the item is selected
  final Color errorColor = Colors.red;  //The background color if the item is selected
  final Color selectedTextColor = Colors.white;

  final TextEditingController textEditingController = TextEditingController();  //Controller for alphanumeric input
  final TextEditingController morseEditingController = TextEditingController(); //Controller for morse input

  void toggleMorse() {
    _toMorse = !_toMorse;
    _translated = "";
    _error = null;

    notifyListeners();
  }

  void translate(Alphabet alphabet) {
    try {
      print('Translate to morse, value: ' + textEditingController.text);
      _error = null;

      _translated = toMorse ?
        Translator.translateFromMorse(morseEditingController.text, alphabet) :
        Translator.translateToMorse(textEditingController.text, alphabet);
      _input = toMorse ? textEditingController.text : morseEditingController.text;
    } on TranslationError catch (e) {
      _translated = '';
      print("Translation error: ${e.cause}");
      _error = e;
    } finally {
      print("update notifies translated");
      notifyListeners();
    }
  }
}
