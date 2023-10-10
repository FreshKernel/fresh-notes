import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../logic/auth/auth_user.dart';
import '../../../../logic/auth/cubit/auth_cubit.dart';

class SaveProfileScreen extends StatelessWidget {
  const SaveProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Save profile'),
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
                    decoration: const InputDecoration(
                      hintText: 'Please enter your name',
                      labelText: 'Name',
                      border: OutlineInputBorder(),
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
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(
                        onPressed: () async {
                          setState(() => _isLoading = true);
                          await context.read<AuthCubit>().logout();
                          setState(() => _isLoading = false);
                        },
                        child: const Text('Logout'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () async {
                          setState(() => _isLoading = true);
                          await context.read<AuthCubit>().updateUserProfile(
                                displayName: _nameController.text,
                              );
                          setState(() => _isLoading = false);
                        },
                        child: const Text('Submit'),
                      ),
                    ],
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
