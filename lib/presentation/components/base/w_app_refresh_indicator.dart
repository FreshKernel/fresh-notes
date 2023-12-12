// import 'package:flutter/cupertino.dart' show CupertinoSliverRefreshControl;
// import 'package:flutter/material.dart' show RefreshCallback, RefreshIndicator;
// import 'package:flutter/widgets.dart';
// import 'package:fresh_base_package/fresh_base_package.dart';

// class AppRefreshIndicator extends StatelessWidget {
//   const AppRefreshIndicator(
//       {required this.onRefresh, required this.child, super.key});
//   final RefreshCallback onRefresh;

//   /// The child should not be scrollable since it already by default
//   final Widget child;

//   @override
//   Widget build(BuildContext context) {
//     if (PlatformChecker.defaultLogic().isAppleSystem()) {
//       return CustomScrollView(
//         slivers: [
//           CupertinoSliverRefreshControl(
//             onRefresh: onRefresh,
//           ),
//           SliverToBoxAdapter(
//             child: child,
//           )
//         ],
//       );
//     }

//     return RefreshIndicator(
//       onRefresh: onRefresh,
//       child: child,
//     );
//   }
// }
