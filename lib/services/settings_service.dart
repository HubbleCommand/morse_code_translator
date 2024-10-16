import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/alphabet.dart';


class SettingsService extends ChangeNotifier {
  int elementDuration = 240;                //The user-defined duration of each Morse element (in milliseconds)
  Alphabet alphabet = AlphabetITU();
  FilteringTextInputFormatter alphanumericFilter = FilteringTextInputFormatter.allow(RegExp("[a-z A-Z 0-9]"));

  SettingsService() {
    _loadFromPreferences();
  }

  void _loadFromPreferences() {
    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      this.elementDuration = prefs.getInt('elementDuration') ?? elementDuration;

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

      notifyListeners();
    });
  }

  void writeToPreferences() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setInt('elementDuration', elementDuration);
      prefs.setString('alphabet', alphabet.name);
    });
  }

  void setAlphabet(Alphabet alphabet) {
    this.alphabet = alphabet;
    alphanumericFilter = FilteringTextInputFormatter.allow(RegExp(alphabet.getValidRegex()));
    notifyListeners();
  }

  void setDuration(int duration) {
    elementDuration = duration;
    notifyListeners();
  }
}