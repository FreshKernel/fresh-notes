import 'package:flutter/cupertino.dart'
    show CupertinoColors, CupertinoListSection;
import 'package:flutter/widgets.dart';

import '../../utils/extensions/build_context_extensions.dart';

class SettingsSection extends StatelessWidget {
  const SettingsSection({required this.title, required this.tiles, super.key});

  final String title;
  final List<Widget> tiles;

  Widget buildTileList() => ListView.builder(
        shrinkWrap: true,
        itemCount: tiles.length,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => tiles[index],
      );

  @override
  Widget build(BuildContext context) {
    final textScaler = MediaQuery.textScalerOf(context);

    if (context.isCupertino) {
      return CupertinoListSection.insetGrouped(
        header: Padding(
          padding: EdgeInsetsDirectional.only(
            start: 15,
            bottom: textScaler.scale(5),
          ),
          child: DefaultTextStyle(
            style: const TextStyle(
              color: CupertinoColors.systemGrey,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
            child: Text(
              title,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        // margin: const EdgeInsets.all(12),
        children: tiles,
      );
    }
    // final materialTheme = Theme.of(context);

    final tileList = buildTileList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.only(
            top: textScaler.scale(24),
            bottom: textScaler.scale(10),
            start: 24,
            end: 24,
          ),
          child: DefaultTextStyle(
            style: TextStyle(
              color: context.isDark
                  ? const Color(0xffd3e3fd)
                  : const Color(0xff0b57d0),
            ),
            child: Text(title),
          ),
        ),
        tileList,
      ],
    );
  }
}
