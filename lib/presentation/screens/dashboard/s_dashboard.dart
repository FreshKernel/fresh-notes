import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../logic/note/cubit/note_cubit.dart';
import '../../../logic/settings/cubit/settings_cubit.dart';
import '../../../logic/settings/cubit/settings_data.dart';
import '../../l10n/extensions/localizations.dart';
import '../../utils/dialog/w_yes_cancel_dialog.dart';
import '../save_note/s_save_note.dart';
import 'models/m_navigation_item.dart';
import 'w_logout.dart';
import 'widgets/w_drawer.dart';
import 'widgets/w_notes_list.dart';
import 'widgets/w_settings.dart';
import 'widgets/w_trash_list.dart';

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
          body: const NotesListPage(),
          actionsBuilder: (context) {
            return [
              IconButton(
                tooltip: context.loc.toggleGridItem,
                onPressed: () {
                  final settingsBloc = context.read<SettingsCubit>();
                  settingsBloc.updateSettings(
                    settingsBloc.state.copyWith(
                      useNoteGridTile: !settingsBloc.state.useNoteGridTile,
                    ),
                  );
                },
                icon: const Icon(Icons.list),
              ),
              const LogoutIconButton(),
              IconButton(
                tooltip: context.loc.deleteAll,
                onPressed: () async {
                  final noteBloc = context.read<NoteCubit>();
                  final deletedAllConfirmed = await showYesCancelDialog(
                    context: context,
                    options: YesOrCancelDialogOptions(
                      title: context.loc.moveAllNotesToTrash,
                      message: context.loc.moveAllNotesToTrashDesc,
                      yesLabel: context.loc.deleteAll,
                    ),
                  );
                  if (!deletedAllConfirmed) {
                    return;
                  }
                  noteBloc.deleteAll();
                },
                icon: const Icon(Icons.delete_forever),
              ),
            ];
          },
          actionButtonBuilder: (context) {
            return FloatingActionButton(
              onPressed: () => context.push(
                SaveNoteScreen.routeName,
                extra: const SaveNoteScreenArgs(),
              ),
              child: const Icon(Icons.add),
            );
          },
        ),
        NavigationItem(
          title: context.loc.trash,
          label: context.loc.trash,
          icon: const Icon(Icons.delete),
          body: const TrashPage(),
        ),
        NavigationItem(
          title: context.loc.changeSettings,
          label: context.loc.settings,
          icon: const Icon(Icons.settings),
          body: const SettingsPage(),
        ),
      ];

  var _selectedNavItemIndex = 0;
  final _pageController = PageController();

  bool _isNavRailBar(Size size, AppLayoutMode layoutMode) {
    switch (layoutMode) {
      // TODO: Update this
      case AppLayoutMode.auto:
        return size.width >= 480;
      case AppLayoutMode.small:
        return false;
      case AppLayoutMode.large:
        return true;
    }
  }

  void _onDestinationSelected(int newPageIndex) {
    if (_pageController.hasClients) {
      _pageController.jumpToPage(newPageIndex);
    }
    setState(() => _selectedNavItemIndex = newPageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
                final widget = _navigationItems[_selectedNavItemIndex].body;
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
