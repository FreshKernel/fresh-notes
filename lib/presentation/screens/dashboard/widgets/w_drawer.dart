import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../logic/auth/cubit/auth_cubit.dart';
import '../../../components/auth/w_user_image.dart';
import '../../settings/s_settings.dart';

class DashboardDrawer extends StatelessWidget {
  const DashboardDrawer({super.key});

  Widget _buildItem({
    required BuildContext context,
    required String title,
    required String subtitle,
    required Widget icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      onTap: () {
        context.pop();
        onTap();
      },
      leading: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                if (state is! AuthStateAuthenticated) {
                  return const Text('Authentication is required');
                }
                final user = state.user;
                return UserAccountsDrawerHeader(
                  accountName: Text(user.data.displayName.toString()),
                  accountEmail: Text(user.emailAddress.toString()),
                  onDetailsPressed: () {},
                  currentAccountPicture: UserProfileImage(
                    user: user,
                    iconSize: 30,
                  ),
                );
              },
            ),
            _buildItem(
              context: context,
              title: 'Settings',
              subtitle: 'Edit your settings',
              icon: const Icon(Icons.settings),
              onTap: () {
                context.push(
                  SettingsScreen.routeName,
                );
              },
            ),
            const ListBody(),
          ],
        ),
      ),
    );
  }
}
