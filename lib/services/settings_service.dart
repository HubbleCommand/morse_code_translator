import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:morse_code_translator/services/preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/alphabet.dart';


class SettingsService extends ChangeNotifier {
  int _elementDuration = Preferences.elementDuration.defaultValue;
  Alphabet _alphabet = Preferences.alphabet.defaultValue;
  FilteringTextInputFormatter _alphabetFilter = FilteringTextInputFormatter.allow(RegExp("[a-z A-Z 0-9]"));

  int get elementDuration => _elementDuration;
  Alphabet get alphabet => _alphabet;
  FilteringTextInputFormatter get alphabetFilter => _alphabetFilter;

  SettingsService() {
    _loadFromPreferences();
  }

  void _loadFromPreferences() async {
    SharedPreferencesAsync prefs = SharedPreferencesAsync();
    _elementDuration = await Preferences.elementDuration.get(prefs: prefs);
    _alphabet = await Preferences.alphabet.get(prefs: prefs);
    _alphabetFilter = FilteringTextInputFormatter.allow(RegExp(alphabet.getValidRegex()));
    notifyListeners();
  }

  void writeToPreferences() async {
    SharedPreferencesAsync prefs = SharedPreferencesAsync();
    await Preferences.alphabet.set(alphabet, prefs: prefs);
    await Preferences.elementDuration.set(elementDuration, prefs: prefs);
  }

  void setAlphabet(Alphabet alphabet) {
    this._alphabet = alphabet;
    _alphabetFilter = FilteringTextInputFormatter.allow(RegExp(alphabet.getValidRegex()));
    notifyListeners();
  }

  void setDuration(int duration) {
    _elementDuration = duration;
    notifyListeners();
  }
}