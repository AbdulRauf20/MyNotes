import 'package:flutter/widgets.dart';
import 'package:mynotes/utilities/dialog/genric_dialog.dart';

Future<void> showErrorDialog(BuildContext context, String text) {
  return showGenericDialog<void>(
    context: context,
    title: 'An error occurred!',
    content: text,
    optionsBuilder: () {
      return {'Ok': null};
    },
  );
}
