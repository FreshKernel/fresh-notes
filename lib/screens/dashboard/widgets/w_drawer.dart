import 'package:flutter/material.dart';

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
        final navigator = Navigator.of(context);
        onTap();
        navigator.pop();
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
            const UserAccountsDrawerHeader(
              accountName: Text('Ahmed Hnewa'),
              accountEmail: Text('ahmed.hnewa@gmail.com'),
            ),
            _buildItem(
              context: context,
              title: 'My title',
              subtitle: 'My sub title',
              icon: const Icon(Icons.add),
              onTap: () {},
            ),
            const ListBody(),
          ],
        ),
      ),
    );
  }
}
