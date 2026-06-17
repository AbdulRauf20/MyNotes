import 'package:flutter/widgets.dart';
import 'package:mynotes/utilities/dialog/genric_dialog.dart';

Future<bool> showLogOutDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Logout',
    content: 'Are you sure you want to logout?',
    optionsBuilder: () => {'Cancel': false, 'Logout': true},
  ).then((value) => value ?? false);
}
