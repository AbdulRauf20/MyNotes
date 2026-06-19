import 'package:flutter/material.dart';
import 'package:mynotes/utilities/dialog/genric_dialog.dart';

Future<void> showCannotShareEmptyNotesDialog(BuildContext context){
  return showGenericDialog(
    context: context,
    title: 'Cannot Share a Note',
    content: 'You cannot share an empty note!',
    optionsBuilder: () => {
      'OK': null,
    },
  );
}