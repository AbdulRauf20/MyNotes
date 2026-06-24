import 'package:flutter/widgets.dart';
import 'package:mynotes/utilities/dialog/genric_dialog.dart';

Future<void> showPasswordResetSentDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: 'Password Reset',
    content: 'We have now sent you a password reset link, Please check you email inbox',
    optionsBuilder: () => {'ok': null},
  );
}