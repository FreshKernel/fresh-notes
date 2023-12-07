import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../components/auth/w_email_field.dart';

class ForgotPasswordDialog extends StatefulWidget {
  const ForgotPasswordDialog({required this.initEmail, super.key});

  final String initEmail;

  @override
  State<ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
  late final TextEditingController _emailController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(
      text: widget.initEmail,
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: const Text('Forgot password'),
      content: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.always,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            EmailTextField(
              emailController: _emailController,
            )
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(null),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final isValid = _formKey.currentState?.validate() ?? false;
            if (!isValid) {
              return;
            }
            _formKey.currentState?.save();
            context.pop(_emailController.text);
          },
          child: const Text('Send'),
        ),
      ],
    );
  }
}
