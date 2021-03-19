abstract class Alphabet{
  static const Map<String, String> alphabet = {};
  bool containsCharTranslation(String char);
  String getCharTranslation(String char);
}

//class AlphabetITU <T extends Alphabet>{
class AlphabetITU extends Alphabet{
  static const Map<String, String> alphabet = {
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

  @override
  bool containsCharTranslation(String char){
    if(alphabet.containsKey(char.toLowerCase())){
      return true;
    } else {
      return false;
    }
  }

  @override
  String getCharTranslation(String char) {
    // TODO: implement getCharTranslation
    //throw UnimplementedError();
    if(containsCharTranslation(char)){
      return alphabet[char];
    } else {
      return null;
    }
  }
}

/*class AlphabetGerke extends Alphabet{

}*/

class AlphabetOriginal extends Alphabet{
  static const Map<String, String> alphabet = {
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

  @override
  bool containsCharTranslation(String char) {

  }

  @override
  String getCharTranslation(String char) {

  }
}