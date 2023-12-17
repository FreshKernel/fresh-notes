import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../data/constants/urls.dart';
import '../../../../logic/auth/cubit/auth_cubit.dart';
import '../../../components/auth/w_logout.dart';
import '../../../components/auth/w_user_image.dart';
import '../../../l10n/extensions/localizations.dart';
import '../../auth/profile/s_profile.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  static List<Widget> actionsBuilder(BuildContext context) {
    return [
      const LogoutIconButton(),
    ];
  }

  Widget _buildItem({
    required String title,
    required String desc,
    required IconData iconData,
    required VoidCallback onPressed,
  }) {
    return ListTile(
      title: Text(title),
      subtitle: Text(desc),
      leading: Icon(iconData),
      trailing: const Icon(Icons.keyboard_arrow_right),
      onTap: onPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 18),
        BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is! AuthStateAuthenticated) {
              return const Text('Authentication is required');
            }
            final user = state.user;
            final displayName = state.user.data.displayName;
            return Column(
              children: [
                UserProfileImage(
                  user: user,
                  iconSize: 50,
                  containerSize: 100,
                ),
                const SizedBox(height: 16),
                if (displayName != null)
                  Text(
                    displayName,
                    style: Theme.of(context).textTheme.titleMedium,
                  )
              ],
            );
          },
        ),
        _buildItem(
          title: context.loc.accountData,
          desc: context.loc.accountDataDesc,
          iconData: Icons.account_circle,
          onPressed: () => context.push(ProfileScreen.routeName),
        ),
        _buildItem(
          title: context.loc.privacyPolicy,
          desc: context.loc.privacyPolicyDesc,
          iconData: Icons.lock,
          onPressed: () => launchUrl(
            Uri.parse(UrlConstants.privacyPolicy),
          ),
        ),
        _buildItem(
          title: context.loc.socialMedia,
          desc: context.loc.socialMediaDesc,
          iconData: Icons.share,
          onPressed: () => launchUrl(
            Uri.parse(UrlConstants.githubRepo),
          ),
        ),
      ],
    );
  }
}
