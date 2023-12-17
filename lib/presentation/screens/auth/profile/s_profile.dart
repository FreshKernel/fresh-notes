import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../logic/auth/cubit/auth_cubit.dart';
import '../../../../logic/note/cubit/note_cubit.dart';
import '../../../l10n/extensions/localizations.dart';
import '../../../utils/extensions/build_context_ext.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const routeName = '/profile';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc.profile),
      ),
      body: const SaveProfileScreenBody(),
    );
  }
}

class SaveProfileScreenBody extends StatefulWidget {
  const SaveProfileScreenBody({super.key});

  @override
  State<SaveProfileScreenBody> createState() => _SaveProfileScreenBodyState();
}

class _SaveProfileScreenBodyState extends State<SaveProfileScreenBody> {
  final _nameController = TextEditingController();
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthStateAuthenticated) {
      _nameController.text = authState.user.data.displayName ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Builder(
            builder: (context) {
              if (_isLoading) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: context.loc.pleaseEnterYourName,
                      labelText: context.loc.name,
                      border: const OutlineInputBorder(),
                    ),
                    controller: _nameController,
                    enableSuggestions: false,
                    autocorrect: true,
                    inputFormatters: [
                      FilteringTextInputFormatter.singleLineFormatter
                    ],
                    maxLines: 1,
                    autofillHints: const [AutofillHints.name],
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        setState(() => _isLoading = true);
                        await context.read<AuthCubit>().updateUserProfile(
                              displayName: _nameController.text,
                            );
                        setState(() => _isLoading = false);
                      },
                      child: Text(context.loc.send),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () async {
                        setState(() => _isLoading = true);
                        await context.read<AuthCubit>().logout();
                        setState(() => _isLoading = false);
                      },
                      child: Text(context.loc.logout),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () async {
                        final noteCubit = context.read<NoteCubit>();
                        final authCubit = context.read<AuthCubit>();
                        final navigator = context.navigator;

                        await noteCubit.deleteAll();
                        await authCubit.deleteTheUser();

                        if (navigator.canPop()) {
                          navigator.pop();
                        }
                      },
                      child: Text(context.loc.deleteAccount),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
