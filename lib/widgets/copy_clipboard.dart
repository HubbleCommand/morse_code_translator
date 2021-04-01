import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CopyToClipboardWidget extends StatelessWidget{
  CopyToClipboardWidget({@required this.onTapCopy, @required this.message});
  final Function onTapCopy;
  final String message;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () async {
          var text = onTapCopy();
          // Respond to button press
          print('Received text $text');
          ClipboardData data = ClipboardData(text: '$text');
          await Clipboard.setData(data);

          ScaffoldMessenger
              .of(context)
              .showSnackBar(SnackBar(content: Text(message)));
        },
        icon: Icon(Icons.sticky_note_2, size: 18),
    );
  }
}
