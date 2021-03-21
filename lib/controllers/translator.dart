import 'package:morse_code_translator/models/alphabet.dart';

//https://en.wikipedia.org/wiki/Morse_code

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

    for(int i = 0; i < textToTranslate.length; i++){
      if(alphabet.containsCharTranslation(textToTranslate[i])){
        try{
          morseString += alphabet.getCharTranslation(textToTranslate[i]) + _letter_gap;
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
    for(int i = 0; i < textToTranslate.length;){
      if(!(textToTranslate[i] == '.' || textToTranslate[i] =='-' || textToTranslate[i] ==' ')){
        print(textToTranslate[i]);
        throw new TranslationError("Invalid symbol found");  //If char isn't valid morse symbol
      }
      if(textToTranslate[i] == ' '){
        if(textToTranslate.substring(i, i + 2) == '   ' && textToTranslate[i + 3] != ' '){  //If is letter gap
          i += 3;
          continue;
        }
        else if(textToTranslate.substring(i, i + 6) == '   ' && textToTranslate[i + 7] != ' '){  //If is word gap
          i += 7;
          continue;
        } else {  //Probably malformed
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
          //TODO stop returning null! Throw errors!
          throw new TranslationError("This morse snippet doesn't seem to match any character translation");
        }
      }

      i += 1;
    }

    return alphaNumericString;
  }
}