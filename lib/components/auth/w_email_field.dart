import 'package:flutter/material.dart';
import 'package:my_notes/utils/validators/auth.dart';

class EmailTextField extends StatelessWidget {
  const EmailTextField({
    super.key,
    required this.emailController,
    this.textInputAction = TextInputAction.next,
  });

  final TextEditingController emailController;
  final TextInputAction textInputAction;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: emailController,
      decoration: const InputDecoration(
        hintText: 'Enter your email address.',
        labelText: 'Email address',
        border: OutlineInputBorder(),
      ),
      validator: (email) {
        final errorMessage = AuthValidator.validateEmail(email ?? '');
        if (errorMessage != null) {
          return errorMessage;
        }
        return null;
      },
      autocorrect: false,
      enableSuggestions: true,
      autofillHints: const [AutofillHints.email],
      keyboardType: TextInputType.emailAddress,
      textInputAction: textInputAction,
    );
  }
}
