import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:morse_code_translator/services/preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/alphabet.dart';


class SettingsService extends ChangeNotifier {
  int elementDuration = Preferences.elementDuration.defaultValue;
  Alphabet alphabet = Preferences.alphabet.defaultValue;
  FilteringTextInputFormatter alphabetFilter = FilteringTextInputFormatter.allow(RegExp("[a-z A-Z 0-9]"));

  SettingsService() {
    _loadFromPreferences();
  }

  void _loadFromPreferences() async {
    SharedPreferencesAsync prefs = SharedPreferencesAsync();
    elementDuration = await Preferences.elementDuration.get(prefs: prefs);
    alphabet = await Preferences.alphabet.get(prefs: prefs);
    alphabetFilter = FilteringTextInputFormatter.allow(RegExp(alphabet.getValidRegex()));
    notifyListeners();
  }

  void writeToPreferences() async {
    SharedPreferencesAsync prefs = SharedPreferencesAsync();
    await Preferences.alphabet.set(alphabet, prefs: prefs);
    await Preferences.elementDuration.set(elementDuration, prefs: prefs);
  }

  void setAlphabet(Alphabet alphabet) {
    this.alphabet = alphabet;
    alphabetFilter = FilteringTextInputFormatter.allow(RegExp(alphabet.getValidRegex()));
    notifyListeners();
  }

  void setDuration(int duration) {
    elementDuration = duration;
    notifyListeners();
  }
}