import 'package:morse_code_translator/models/alphabet.dart';
import 'package:preftils/preftils.dart';

class Preferences {
  static final Preference<int> elementDuration = Preference("elementDuration", 240);
  static final Preference<Alphabet> alphabet = Preference("alphabet", AlphabetITU());
}
