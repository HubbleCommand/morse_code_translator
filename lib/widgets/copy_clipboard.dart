import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/*
Use like:
CopyToClipboardWidget(
                  onTapCopy: (){
                    return _textTranslated;
                  },
                ),
 */
class CopyToClipboardWidget extends StatelessWidget{
  CopyToClipboardWidget({@required this.onTapCopy});
  final Function onTapCopy;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextButton.icon(
          onPressed: () async {
            var text = onTapCopy();
            // Respond to button press
            print('Received text $text');
            ClipboardData data = ClipboardData(text: '$text');
            await Clipboard.setData(data);

            ScaffoldMessenger
                .of(context)
                .showSnackBar(SnackBar(content: Text('Morse Code copied to clipboard')));
          },
          icon: Icon(Icons.sticky_note_2, size: 18),
          label: Text("Copy to Clipboard"),
        )
      ],
    );
  }
}
