import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../logic/utils/validators/global.dart';
import '../../l10n/extensions/localizations.dart';
import '../../utils/dialog/w_dialog_action.dart';
import '../../utils/extensions/build_context_ext.dart';

class SaveNoteFolderDialog extends StatefulWidget {
  const SaveNoteFolderDialog({super.key});

  @override
  State<SaveNoteFolderDialog> createState() => _SaveNoteFolderDialogState();
}

class _SaveNoteFolderDialogState extends State<SaveNoteFolderDialog> {
  final _folderNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _folderNameController.dispose();
    super.dispose();
  }

  void _submit() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }
    context.pop(_folderNameController.text);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: Text(context.loc.createFolder),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _folderNameController,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  hintText: context.loc.pleaseEnterANameForTheFolder,
                  labelText: context.loc.folderName,
                  prefixIcon: const Icon(Icons.folder_copy),
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  return GlobalValidator.validateTextIsEmpty(
                    value ?? '',
                    errorMessage: context.loc.pleaseEnterANameForTheFolder,
                  );
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        AppDialogAction(
          child: Text(context.loc.cancel),
          onPressed: () => context.navigator.pop(null),
        ),
        AppDialogAction(
          onPressed: _submit,
          child: Text(context.loc.create),
        ),
      ],
    );
  }
}
