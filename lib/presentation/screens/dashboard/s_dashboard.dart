import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../logic/settings/cubit/settings_cubit.dart';
import '../../../logic/settings/cubit/settings_data.dart';
import '../../l10n/extensions/localizations.dart';
import 'models/m_navigation_item.dart';
import 'widgets/w_account_page.dart';
import 'widgets/w_drawer.dart';
import 'widgets/w_note_folders_page.dart';
import 'widgets/w_notes_list.dart';
import 'widgets/w_settings_page.dart';
import 'widgets/w_trash_list_page.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  static const routeName = '/dashboard';

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<NavigationItem> get _navigationItems => [
        NavigationItem(
          title: context.loc.yourNotes,
          label: context.loc.notes,
          icon: const Icon(Icons.notes),
          body: const NotesListPage(
            key: PageStorageKey('NotesListPage'),
          ),
          actionsBuilder: NotesListPage.actionsBuilder,
          actionButtonBuilder: NotesListPage.actionButtonBuilder,
        ),
        // TODO: This feature is not ready
        if (kDebugMode)
          NavigationItem(
            title: context.loc.browse,
            label: context.loc.folders,
            icon: const Icon(Icons.folder),
            body: const NoteFoldersPage(
              key: PageStorageKey('NoteFoldersPage'),
            ),
            actionsBuilder: NoteFoldersPage.actionsBuilder,
            actionButtonBuilder: NoteFoldersPage.actionButtonBuilder,
          ),
        NavigationItem(
          title: context.loc.trash,
          label: context.loc.trash,
          icon: const Icon(Icons.delete),
          body: const TrashPage(
            key: PageStorageKey('TrashPage'),
          ),
          actionsBuilder: TrashPage.actionsBuilder,
        ),
        NavigationItem(
          title: context.loc.changeSettings,
          label: context.loc.settings,
          icon: const Icon(Icons.settings),
          body: const SettingsPage(
            key: PageStorageKey('SettingsPage'),
          ),
        ),
        NavigationItem(
          title: context.loc.yourAccount,
          label: context.loc.account,
          icon: const Icon(Icons.account_circle),
          actionsBuilder: AccountPage.actionsBuilder,
          body: const AccountPage(
            key: PageStorageKey('AccountPage'),
          ),
        ),
      ];

  var _selectedNavItemIndex = 0;
  // PageController? _pageController;
  late final PageStorageBucket _pageStorageBucket;

  @override
  void initState() {
    super.initState();
    // _pageController = PageController();
    _pageStorageBucket = PageStorageBucket();
  }

  @override
  void dispose() {
    // _pageController?.dispose();
    super.dispose();
  }

  bool _isNavRailBar(Size size, AppLayoutMode layoutMode) {
    switch (layoutMode) {
      //  Might want needs to be updated
      case AppLayoutMode.auto:
        return size.width >= 480;
      case AppLayoutMode.small:
        return false;
      case AppLayoutMode.large:
        return true;
    }
  }

  void _onDestinationSelected(int newPageIndex) {
    // if (_pageController?.hasClients ?? false) {
    //   _pageController?.jumpToPage(newPageIndex);
    // }
    setState(() => _selectedNavItemIndex = newPageIndex);
  }

  @override
  Widget build(BuildContext context) {
    final actions =
        _navigationItems[_selectedNavItemIndex].actionsBuilder?.call(context);
    final actionButton = _navigationItems[_selectedNavItemIndex]
        .actionButtonBuilder
        ?.call(context);
    return BlocBuilder<SettingsCubit, SettingsState>(
      buildWhen: (previous, current) =>
          previous.layoutMode != current.layoutMode,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              _navigationItems[_selectedNavItemIndex].title,
            ),
            actions: actions,
          ),
          drawer: const DashboardDrawer(),
          body: SafeArea(
            child: Builder(
              builder: (context) {
                final size = MediaQuery.sizeOf(context);
                // final widget = PageView(
                //   controller: _pageController,
                //   children: _navigationItems.map((e) => e.body).toList(),
                //   onPageChanged: (newPageIndex) {
                //     setState(() => _selectedNavItemIndex = newPageIndex);
                //   },
                // );
                final widget = PageStorage(
                  bucket: _pageStorageBucket,
                  child: _navigationItems[_selectedNavItemIndex].body,
                );
                if (!_isNavRailBar(size, state.layoutMode)) {
                  return widget;
                }
                return Row(
                  children: [
                    NavigationRail(
                      onDestinationSelected: _onDestinationSelected,
                      labelType: NavigationRailLabelType.all,
                      destinations: _navigationItems.map((e) {
                        return NavigationRailDestination(
                          icon: e.icon,
                          label: Text(e.label),
                          selectedIcon: e.selectedIcon,
                        );
                      }).toList(),
                      selectedIndex: _selectedNavItemIndex,
                    ),
                    Expanded(
                      child: widget,
                    )
                  ],
                );
              },
            ),
          ),
          floatingActionButton: actionButton,
          bottomNavigationBar: Builder(
            builder: (context) {
              final size = MediaQuery.sizeOf(context);
              if (_isNavRailBar(size, state.layoutMode)) {
                return const SizedBox.shrink();
              }
              return NavigationBar(
                selectedIndex: _selectedNavItemIndex,
                onDestinationSelected: _onDestinationSelected,
                destinations: _navigationItems.map((e) {
                  return NavigationDestination(
                    icon: e.icon,
                    label: e.label,
                    selectedIcon: e.selectedIcon,
                    tooltip: e.tooltip,
                    key: ValueKey(e.label),
                  );
                }).toList(),
              );
            },
          ),
        );
      },
    );
  }
}
