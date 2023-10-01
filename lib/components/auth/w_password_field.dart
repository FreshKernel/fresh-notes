import 'package:flutter/material.dart';
import '../../utils/validators/auth.dart';

class PasswordTextField extends StatelessWidget {
  const PasswordTextField({
    required this.passwordController, super.key,
    this.textInputAction = TextInputAction.done,
    this.onEditingComplete,
  });

  final TextEditingController passwordController;
  final TextInputAction textInputAction;
  final VoidCallback? onEditingComplete;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: passwordController,
      decoration: const InputDecoration(
        hintText: 'Enter your password.',
        labelText: 'Password',
        border: OutlineInputBorder(),
      ),
      validator: (password) {
        final errorMessage = AuthValidator.validatePassword(
          password ?? '',
        );
        if (errorMessage != null) {
          return errorMessage;
        }
        return null;
      },
      obscureText: true,
      enableSuggestions: false,
      autocorrect: false,
      autofillHints: const [AutofillHints.password],
      keyboardType: TextInputType.text,
      textInputAction: textInputAction,
      onEditingComplete: onEditingComplete,
    );
  }
}
