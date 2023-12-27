import 'package:flutter/material.dart';
import '../../../logic/utils/validators/auth.dart';
import '../../l10n/extensions/localizations.dart';

class EmailTextField extends StatelessWidget {
  const EmailTextField({
    required this.emailController,
    this.inputDecoration,
    super.key,
    this.textInputAction = TextInputAction.next,
  });

  final TextEditingController emailController;
  final TextInputAction textInputAction;
  final InputDecoration? inputDecoration;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: emailController,
      decoration: (inputDecoration ?? const InputDecoration()).copyWith(
        hintText: context.loc.pleaseEnterYourEmailAddress,
        labelText: context.loc.emailAddress,
      ),
      validator: (email) {
        final errorMessage = AuthValidator.validateEmail(
          email ?? '',
          pleaseEnterYourEmailAddress: context.loc.pleaseEnterYourEmailAddress,
          pleaseEnterAValidEmailAddress:
              context.loc.pleaseEnterAValidEmailAddress,
        );
        if (errorMessage != null) {
          return errorMessage;
        }
        return null;
      },
      autocorrect: false,
      autofillHints: const [AutofillHints.email],
      keyboardType: TextInputType.emailAddress,
      textInputAction: textInputAction,
    );
  }
}
