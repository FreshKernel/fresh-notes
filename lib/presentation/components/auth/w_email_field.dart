import 'package:flutter/material.dart';
import '../../../logic/utils/validators/auth.dart';

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
        hintText: 'Enter your email address.',
        labelText: 'Email address',
      ),
      validator: (email) {
        final errorMessage = AuthValidator.validateEmail(email ?? '');
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
