import 'package:morse_code_translator/models/alphabet.dart';

class Translator {
  //https://stackoverflow.com/questions/50431055/what-is-the-difference-between-the-const-and-final-keywords-in-dart
  static const _letter_gap = '   ';
  static const _word_gap = '       ';
  static const _alphabetInternationalITU = {
    'a' : '.-',
    'b' : '-...',
    'c' : '-.-.',
    'd' : '-..',
    'e' : '.',
    'f' : '..-.',
    'g' : '--.',
    'h' : '....',
    'i' : '..',
    'j' : '.---',
    'k' : '-.-',
    'l' : '.-..',
    'm' : '--',
    'n' : '-.',
    'o' : '---',
    'p' : '.--.',
    'q' : '--.-',
    'r' : '.-.',
    's' : '...',
    't' : '-',
    'u' : '..-',
    'v' : '...-',
    'w' : '.--',
    'x' : '-..-',
    'y' : '-.--',
    'z' : '--..',
    '1' : '.----',
    '2' : '..---',
    '3' : '...--',
    '4' : '....-',
    '5' : '.....',
    '6' : '-....',
    '7' : '--...',
    '8' : '---..',
    '9' : '----.',
    '0' : '-----',
  };
  static const _alphabetContinentalGerke = {

  };
  static const _alphabetAmericanOriginal = {
    'a' : '.-',
    'b' : '-...',
    'c' : '.. .',
    'd' : '-..',
    'e' : '.',
    'f' : '.-.',
    'g' : '--.',
    'h' : '....',
    'i' : '..',
    'j' : '-.-.',
    'k' : '-.-',
    'l' : '-.', //SPECIAL, tone lasts for the full time, no gap
    'm' : '--',
    'n' : '-.',
    'o' : '..',
    'p' : '.....',
    'q' : '..-.',
    'r' : '. ..',
    's' : '...',
    't' : '-',
    'u' : '..-',
    'v' : '...-',
    'w' : '.--',
    'x' : '.-..',
    'y' : '.. ..',
    'z' : '... .',
    '1' : '.--..',
    '2' : '..-..',
    '3' : '...-.',
    '4' : '....-',
    '5' : '---',
    '6' : '......',
    '7' : '--..',
    '8' : '-....',
    '9' : '-..-',
    '0' : '-----',
  };

  static String translateToMorse(String textToTranslate, Alphabet alphabet){
    String morseString = '';
    for(int i = 0; i < textToTranslate.length; i++){
      //TODO fix redundant checking!
      if(!_alphabetInternationalITU.containsKey(textToTranslate[i].toLowerCase()) && textToTranslate[i] != ' ' && textToTranslate[i] != '.'){
        return null;  //If the character isn't valid, return null
      } else {
        if(textToTranslate[i] == ' ' || textToTranslate[i] == '.'){
          morseString += _word_gap;
        }
        else if(_alphabetInternationalITU.containsKey(textToTranslate[i].toLowerCase())){ //Better to have last? Most characters will NOT be punctuation,
          //charToAdd = _alphabet_international_ITU[textToTranslate[i]];
          morseString += _alphabetInternationalITU[textToTranslate[i].toLowerCase()] + _letter_gap;
        }
        else {
          return null;
        }
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
      else if(Alphabet.alphabet.containsKey(textToTranslate[i].toLowerCase())){ //Better to have last? Most characters will NOT be punctuation,
        //charToAdd = _alphabet_international_ITU[textToTranslate[i]];
        alphaNumericString += Alphabet.alphabet[textToTranslate[i].toLowerCase()] + _letter_gap;
      }
      else {
        return null;
      }
    }

    return alphaNumericString;
  }
}