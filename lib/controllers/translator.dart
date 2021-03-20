import 'package:morse_code_translator/models/alphabet.dart';

//https://en.wikipedia.org/wiki/Morse_code

class Translator {
  //https://stackoverflow.com/questions/50431055/what-is-the-difference-between-the-const-and-final-keywords-in-dart
  static const _letter_gap = '   ';
  static const _word_gap = '       ';

  static String translateToMorse(String textToTranslate, Alphabet alphabet){
    String morseString = '';

    for(int i = 0; i < textToTranslate.length; i++){
      if(alphabet.containsCharTranslation(textToTranslate[i])){
        morseString += alphabet.getCharTranslation(textToTranslate[i]) + _letter_gap;
      } else if (textToTranslate[i] == ' ' || textToTranslate[i] == '.') {
        morseString += _word_gap;
      } else {
        print("returning null...");
        return null;
      }
    }

    return morseString;
  }

  static String translateFromMorse(String textToTranslate, Alphabet alphabet){
    String alphaNumericString = '';
    for(int i = 0; i < textToTranslate.length; i++){
      if(textToTranslate[i] == ' ' || textToTranslate[i] == '.'){
        alphaNumericString += _word_gap;
      }
      else if(alphabet.alphabet.containsKey(textToTranslate[i].toLowerCase())){ //Better to have last? Most characters will NOT be punctuation,
        //charToAdd = _alphabet_international_ITU[textToTranslate[i]];
        alphaNumericString += alphabet.alphabet[textToTranslate[i].toLowerCase()] + _letter_gap;
      }
      else {
        return null;
      }
    }

    return alphaNumericString;
  }
}