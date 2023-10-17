import 'package:flutter/material.dart';

import '../../../data/notes/universal/s_universal_notes.dart';
import '../../utils/dialog/w_yes_cancel_dialog.dart';
import '../save_note/s_save_note.dart';
import 'models/m_navigation_item.dart';
import 'w_logout.dart';
import 'widgets/notes/cloud_sync/w_sync_notes.dart';
import 'widgets/notes/w_notes.dart';
import 'widgets/w_about.dart';
import 'widgets/w_drawer.dart';
import 'widgets/w_settings.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  static const routeName = '/dashboard';

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _navigationItems = [
    NavigationItem(
      title: 'Manage notes',
      label: 'Notes',
      icon: const Icon(Icons.notes),
      body: const NotesPage(),
      actionsBuilder: (context) {
        return [
          const SyncNotesIconButton(),
          const LogoutIconButton(),
          IconButton(
            tooltip: 'Delete All',
            onPressed: () async {
              final deletedAllConfirmed = await showYesCancelDialog(
                context: context,
                options: const YesOrCancelDialogOptions(
                  title: 'Delete all notes',
                  message:
                      'Are you sure you want to delete all of your notes??',
                  yesLabel: 'Delete all',
                ),
              );
              if (!deletedAllConfirmed) {
                return;
              }
              UniversalNotesService.getInstance().deleteAll();
            },
            icon: const Icon(Icons.delete_forever),
          )
        ];
      },
      actionButtonBuilder: (context) {
        return FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed(
              SaveNoteScreen.routeName,
              arguments: const SaveNoteScreenArgs(),
            );
          },
          child: const Icon(Icons.add),
        );
      },
    ),
    const NavigationItem(
      title: 'Change the settings',
      label: 'Settings',
      icon: Icon(Icons.settings),
      body: SettingsPage(),
    ),
    const NavigationItem(
      title: 'About the App',
      label: 'About',
      icon: Icon(Icons.info),
      body: AboutPage(),
    ),
  ];

  var _selectedNavItemIndex = 0;
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final actions =
        _navigationItems[_selectedNavItemIndex].actionsBuilder?.call(context);
    final actionButton = _navigationItems[_selectedNavItemIndex]
        .actionButtonBuilder
        ?.call(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _navigationItems[_selectedNavItemIndex].title,
        ),
        actions: actions,
      ),
      drawer: const DashboardDrawer(),
      body: PageView(
        controller: _pageController,
        children: _navigationItems.map((e) => Center(child: e.body)).toList(),
        onPageChanged: (newPageIndex) {
          setState(() => _selectedNavItemIndex = newPageIndex);
        },
      ),
      floatingActionButton: actionButton,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedNavItemIndex,
        onDestinationSelected: (newPageIndex) {
          _pageController.jumpToPage(newPageIndex);
          setState(() => _selectedNavItemIndex = newPageIndex);
        },
        destinations: _navigationItems.map((e) {
          return NavigationDestination(
            icon: e.icon,
            label: e.label,
            selectedIcon: e.selectedIcon,
            tooltip: e.tooltip,
            key: ValueKey(e.label),
          );
        }).toList(),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
