import 'package:flutter/material.dart';
import '../../../logic/utils/validators/auth.dart';
import '../../l10n/extensions/localizations.dart';

class PasswordTextField extends StatefulWidget {
  const PasswordTextField({
    required this.passwordController,
    super.key,
    this.textInputAction = TextInputAction.done,
    this.onEditingComplete,
    this.inputDecoration,
  });

  final TextEditingController passwordController;
  final TextInputAction textInputAction;
  final VoidCallback? onEditingComplete;
  final InputDecoration? inputDecoration;

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  var _isPasswordHidden = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.passwordController,
      decoration: (widget.inputDecoration ?? const InputDecoration()).copyWith(
        hintText: context.loc.pleaseEnterYourPassword,
        labelText: context.loc.password,
        suffixIcon: IconButton(
          onPressed: () =>
              setState(() => _isPasswordHidden = !_isPasswordHidden),
          icon: Icon(!_isPasswordHidden
              ? Icons.remove_red_eye
              : Icons.remove_red_eye_outlined),
        ),
      ),
      validator: (password) {
        final errorMessage = AuthValidator.validatePassword(
          password ?? '',
          passwordShouldBeMoreThan6: context.loc.pleaseEnterAPassword,
          pleaseEnterAPassword:
              context.loc.thePasswordShouldBeMoreThan6Characters,
        );
        if (errorMessage != null) {
          return errorMessage;
        }
        return null;
      },
      obscureText: _isPasswordHidden,
      enableSuggestions: false,
      autocorrect: false,
      autofillHints: const [AutofillHints.password],
      keyboardType: TextInputType.text,
      textInputAction: widget.textInputAction,
      onEditingComplete: widget.onEditingComplete,
    );
  }
}
