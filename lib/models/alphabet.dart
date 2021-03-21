class AlphabetError implements Exception {
  String cause;
  AlphabetError(this.cause);
}

abstract class Alphabet{
  Map<String, String> alphabet = {};

  bool containsCharTranslation(String char){
    if(alphabet.containsKey(char.toLowerCase())){
      return true;
    } else {
      return false;
    }
  }

  String getCharTranslation(String char) {
    if(containsCharTranslation(char.toLowerCase())){
      return alphabet[char.toLowerCase()];
    } else {
      throw new AlphabetError('This character cannot be translated to morse');
    }
  }

  Map<String, String> getAlphabet(){
    return alphabet;
  }

  bool containsMorseSymbolTranslation(String morseSymbol) {
    if(alphabet.containsValue(morseSymbol)){
      return true;
    } else {
      return false;
    }
  }

  String getMorseSymbolTranslation(String morseSymbol) {
    if(containsMorseSymbolTranslation(morseSymbol)){
      return alphabet.keys.firstWhere((k) => alphabet[k] == morseSymbol);
    } else {
      throw new AlphabetError('This morse string does not correspond to any known alphanumeric character');
    }
  }
}

//https://morsecode.world/international/morse.html
class AlphabetITU extends Alphabet{
  Map<String, String> get alphabet {
    return {
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
  }
}

class AlphabetOriginal extends Alphabet{
  Map<String, String> get alphabet {
    return {
      'a': '.-',
      'b': '-...',
      'c': '.. .',
      'd': '-..',
      'e': '.',
      'f': '.-.',
      'g': '--.',
      'h': '....',
      'i': '..',
      'j': '-.-.',
      'k': '-.-',
      'l': '-.', //SPECIAL, tone lasts for the full time, no gap
      'm': '--',
      'n': '-.',
      'o': '..',
      'p': '.....',
      'q': '..-.',
      'r': '. ..',
      's': '...',
      't': '-',
      'u': '..-',
      'v': '...-',
      'w': '.--',
      'x': '.-..',
      'y': '.. ..',
      'z': '... .',
      '1': '.--..',
      '2': '..-..',
      '3': '...-.',
      '4': '....-',
      '5': '---',
      '6': '......',
      '7': '--..',
      '8': '-....',
      '9': '-..-',
      '0': '-----', //SPECIAL, tone lasts entire duration
    };
  }
}

class AlphabetGerke extends Alphabet{
  Map<String, String> get alphabet {
    return {
      'a': '.-',
      'b': '-...',
      'c': '-.-.',
      'd': '-..',
      'e': '.',
      'f': '..-.',
      'g': '--.',
      'h': '....',
      'i': '..',
      'j': '..',
      'k': '-.-',
      'l': '.-..',
      'm': '--',
      'n': '-.',
      'o': '.-...',
      'p': '.....',
      'q': '--.-',
      'r': '.-.',
      's': '...',
      't': '-',
      'u': '..-',
      'v': '...-',
      'w': '.--',
      'x': '..-...',
      'y': '--...',
      'z': '.--..',
      '1': '.--.',
      '2': '..-..',
      '3': '...-.',
      '4': '....-',
      '5': '---',
      '6': '......',
      '7': '--..',
      '8': '-....',
      '9': '-..-',
      '0': '-----', //SPECIAL, tone lasts entire duration
    };
  }
}