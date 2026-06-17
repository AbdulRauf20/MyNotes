import 'package:flutter/widgets.dart';
import 'package:mynotes/utilities/dialog/genric_dialog.dart';

Future<bool> deleteDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Delete note',
    content: 'Are you sure you want to delete this note?',
    optionsBuilder: () => {'Cancel': false, 'Delete': true},
  ).then((value) => value ?? false);
}
