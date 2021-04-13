import 'package:morse_code_translator/models/alphabet.dart';

class TranslationError implements Exception {
  String cause;
  TranslationError(this.cause);
}

class Translator {
  //https://stackoverflow.com/questions/50431055/what-is-the-difference-between-the-const-and-final-keywords-in-dart
  static const _letter_gap = '   ';
  static const _word_gap = '       ';

  static String translateToMorse(String textToTranslate, Alphabet alphabet){
    String morseString = '';

    textToTranslate = textToTranslate.trim();
    for(int i = 0; i < textToTranslate.length; i++){
      if(alphabet.containsCharTranslation(textToTranslate[i])){
        try{
          morseString += alphabet.getCharTranslation(textToTranslate[i]) + ((i == textToTranslate.length - 1) ? '' : _letter_gap);

          //Ads only one element letter gap if the two letters are the same
          //NEVER use, as translateFromMorse doesn't work, and fixing it becomes nearly impossible
          /*if(i < textToTranslate.length - 1){
            if(textToTranslate[i] == textToTranslate[i + 1]){
              //The next character is the same, so the char gap is only 1
              morseString += alphabet.getCharTranslation(textToTranslate[i]) + ' ';
            } else {
              morseString += alphabet.getCharTranslation(textToTranslate[i]) + _letter_gap;
            }
          } else {
            morseString += alphabet.getCharTranslation(textToTranslate[i]) + _letter_gap;
          }*/
        } on AlphabetError{
          throw new TranslationError("No morse translation found for this character");  //If char isn't valid morse symbol
        }
      } else if (textToTranslate[i] == ' ' || textToTranslate[i] == '.') {
        morseString += _word_gap;
      } else {
        throw new TranslationError("No morse translation found for this character");  //If char isn't valid morse symbol
      }
    }

    return morseString;
  }

  static String translateFromMorse(String textToTranslate, Alphabet alphabet){
    String alphaNumericString = '';

    textToTranslate = textToTranslate.trim();
    for(int i = 0; i < textToTranslate.length;){
      if(!(textToTranslate[i] == '.' || textToTranslate[i] =='-' || textToTranslate[i] ==' ')){
        print(textToTranslate[i]);
        throw new TranslationError("Invalid symbol found");  //If char isn't valid morse symbol
      }
      if(textToTranslate[i] == ' '){
        if(textToTranslate.substring(i, i + 3) == _letter_gap && textToTranslate[i + 3] != ' '){  //If is letter gap
          //In alphanumeric, there is no gap between letters of a word, so nothing to do to alphaNumericString
          print('Letter gap');
          i += 3;
          continue;
        }
        else if(textToTranslate.substring(i, i + 7) == _word_gap && textToTranslate[i + 7] != ' '){  //If is word gap
          alphaNumericString += ' ';  //Is word gap, so add space
          i += 7;
          continue;
        }
        else {  //Probably malformed
          // TODO handle if the duration between identical symbols is 1 instead of 3
          // NOTE: don't do it, WAY too complicated, and with Original alphabet doesn't make sense
          throw new TranslationError("Malformed space");  //If char isn't valid morse symbol
        }
      } else {
        //Now we most likely have a valid morse character translation
        String currentString = textToTranslate.substring(i);
        String morseCharacter = currentString.split('   ')[0];  //The character ends at the next word gap i.e. three spaces / blanks
        print(morseCharacter);

        if(alphabet.containsMorseSymbolTranslation(morseCharacter)){
          try{
            alphaNumericString += alphabet.getMorseSymbolTranslation(morseCharacter);
            i += morseCharacter.length;
            continue;
          } on AlphabetError {
            throw new TranslationError("This morse block can't be properly translated, even though one should exist");
          }
        } else {
          //https://stackoverflow.com/questions/13579982/how-to-create-a-custom-exception-and-handle-it-in-dart
          //https://dart.dev/guides/language/language-tour#exceptions
          throw new TranslationError("This morse snippet doesn't seem to match any character translation");
        }
      }
    }

    return alphaNumericString;
  }
}