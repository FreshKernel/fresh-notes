import 'package:flutter/material.dart';
import 'package:my_notes/screens/dashboard/models/m_navigation_item.dart';
import 'package:my_notes/screens/dashboard/w_logout.dart';
import 'package:my_notes/screens/dashboard/widgets/w_about.dart';
import 'package:my_notes/screens/dashboard/widgets/notes/w_notes.dart';
import 'package:my_notes/screens/dashboard/widgets/w_settings.dart';
import 'package:my_notes/screens/save_note/s_save_note.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  static const routeName = '/dashboard';

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final navigationItems = [
    const NavigationItem(
      title: 'Manage notes',
      label: 'Notes',
      icon: Icon(Icons.notes),
      body: NotesPage(),
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          navigationItems[_selectedNavItemIndex].title,
        ),
        actions: const [
          LogoutIconButton(),
        ],
      ),
      body: PageView(
        controller: _pageController,
        children: navigationItems.map((e) => Center(child: e.body)).toList(),
        onPageChanged: (newPageIndex) {
          setState(() => _selectedNavItemIndex = newPageIndex);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            settings: const RouteSettings(
              name: SaveNoteScreen.routeName,
            ),
            builder: (context) => const SaveNoteScreen(),
          ));
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedNavItemIndex,
        onDestinationSelected: (newPageIndex) {
          _pageController.jumpToPage(newPageIndex);
          setState(() => _selectedNavItemIndex = newPageIndex);
        },
        destinations: navigationItems.map((e) {
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
