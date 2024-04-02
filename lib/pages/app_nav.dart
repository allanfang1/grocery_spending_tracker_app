import 'package:flutter/material.dart';
import 'package:grocery_spending_tracker_app/common/loading_overlay.dart';
import 'package:grocery_spending_tracker_app/pages/analytics/goals_list.dart';
import 'package:grocery_spending_tracker_app/pages/user/edit_profile.dart';
import 'package:grocery_spending_tracker_app/pages/home.dart';
import 'package:grocery_spending_tracker_app/pages/trips/new_trip.dart';
import 'package:grocery_spending_tracker_app/pages/history/purchase_history.dart';
import "package:persistent_bottom_nav_bar/persistent_tab_view.dart";

// StatelessWidget that creates and handles the navigation bar found on the bottom of the app.
class AppNavigation extends StatelessWidget {
  const AppNavigation({Key? key}) : super(key: key);

  // Build method responsible for creating the UI for the navigation bar.
  @override
  Widget build(BuildContext context) {
    PersistentTabController controller =
        PersistentTabController(initialIndex: 0);

    return PersistentTabView(
      context,
      controller: controller,
      screens: _buildScreens(),
      items: _navBarsItems(context),
      confineInSafeArea: true,
      backgroundColor: Theme.of(context).colorScheme.background,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows: true,
      decoration: NavBarDecoration(
          border: Border(
              top: BorderSide(
                  width: 1, color: Theme.of(context).colorScheme.onPrimary))),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: const ItemAnimationProperties(
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style6,
      navBarHeight: 65.0,
    );
  }

  // Method for constructing a list of all accessible pages from the navigation bar.
  List<Widget> _buildScreens() {
    return const [
      HomePage(),
      PurchaseHistory(),
      LoadingOverlay(child: NewTrip()),
      GoalsList(),
      LoadingOverlay(child: EditProfile()),
    ];
  }

  // Method for constructing a list of icons for the navigation bar to use.
  List<PersistentBottomNavBarItem> _navBarsItems(BuildContext context) {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home),
        activeColorPrimary: Theme.of(context).colorScheme.primary,
        inactiveColorPrimary: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.history),
        activeColorPrimary: Theme.of(context).colorScheme.primary,
        inactiveColorPrimary: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.add_box),
        activeColorPrimary: Theme.of(context).colorScheme.primary,
        inactiveColorPrimary: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.timeline),
        activeColorPrimary: Theme.of(context).colorScheme.primary,
        inactiveColorPrimary: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.account_circle),
        activeColorPrimary: Theme.of(context).colorScheme.primary,
        inactiveColorPrimary: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    ];
  }
}
