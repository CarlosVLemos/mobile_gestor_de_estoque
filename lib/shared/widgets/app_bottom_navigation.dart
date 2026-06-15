import 'package:flutter/material.dart';

class AppBottomNavigationDestination {
  const AppBottomNavigationDestination({
    required this.label,
    required this.icon,
  });

  final String label;
  final IconData icon;
}

class AppBottomNavigation extends StatelessWidget {
  const AppBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.destinations,
    required this.onSelect,
  });

  final int currentIndex;
  final List<AppBottomNavigationDestination> destinations;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        navigationBarTheme: Theme.of(context).navigationBarTheme.copyWith(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
      ),
      child: NavigationBar(
        selectedIndex: currentIndex,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: [
          for (final destination in destinations)
            NavigationDestination(
              icon: Icon(destination.icon),
              label: destination.label,
            ),
        ],
        onDestinationSelected: onSelect,
      ),
    );
  }
}
