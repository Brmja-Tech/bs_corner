import 'package:flutter/material.dart';
import 'package:pscorner/core/extensions/context_extension.dart';


class HomeDrawer extends StatelessWidget {
  const HomeDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(
          0,
          ModalRoute.of(context)?.settings.name == '/home'
              ? context.height * 0.25
              : context.height * 0.3),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Drawer(
          width: 100,
          elevation: 0,
          backgroundColor: Colors.white,
          child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.indigo,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerIcon({
    required IconData iconData,
    required Widget goTo,
    required String routeName,
    required BuildContext context,
  }) {
    return InkWell(
      onTap: () {
        !_isCurrentRoute(context, routeName)
            ? context.go(goTo,routeName:  routeName)
            : null;
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          children: [
            Icon(
              iconData,
              color: !_isCurrentRoute(context, routeName)
                  ? context.theme.colorScheme.secondary
                  : context.theme.colorScheme.onInverseSurface,
              size: 28,
            )
          ],
        ),
      ),
    );
  }

  bool _isCurrentRoute(BuildContext context, String targetRoute) {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    return currentRoute == targetRoute;
  }
}