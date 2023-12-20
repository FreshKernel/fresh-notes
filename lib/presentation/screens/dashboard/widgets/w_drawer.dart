import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../logic/auth/cubit/auth_cubit.dart';
import '../../../components/auth/w_user_image.dart';
import '../../../l10n/extensions/localizations.dart';
import '../../settings/s_settings.dart';
import '../../story/s_story.dart';

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
                final user =
                    state is AuthStateAuthenticated ? state.user : null;
                return UserAccountsDrawerHeader(
                  accountName: Text(
                      user?.data.displayName.toString() ?? context.loc.guest),
                  accountEmail: user?.emailAddress != null
                      ? Text(user?.emailAddress.toString() ?? '')
                      : const SizedBox.shrink(),
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
              title: context.loc.settings,
              subtitle: context.loc.settingsDesc,
              icon: const Icon(Icons.settings),
              onTap: () {
                context.push(
                  SettingsScreen.routeName,
                );
              },
            ),
            _buildItem(
              context: context,
              title: context.loc.story,
              subtitle: context.loc.storyDesc,
              icon: const Icon(Icons.note),
              onTap: () {
                context.push(
                  StoryScreen.routeName,
                );
              },
            )
            // const ListBody(),
          ],
        ),
      ),
    );
  }
}
