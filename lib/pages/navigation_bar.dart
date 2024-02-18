import 'package:flutter/material.dart';
import 'package:grocery_spending_tracker_app/common/constants.dart';
import 'package:grocery_spending_tracker_app/pages/analytics.dart';
import 'package:grocery_spending_tracker_app/pages/edit_profile.dart';
import 'package:grocery_spending_tracker_app/pages/home.dart';
import 'package:grocery_spending_tracker_app/pages/new_trip.dart';
import 'package:grocery_spending_tracker_app/pages/purchase_history.dart';
import "package:persistent_bottom_nav_bar/persistent_tab_view.dart";

class AppNavigation extends StatelessWidget {
  const AppNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PersistentTabController controller =
        PersistentTabController(initialIndex: 0);

    return PersistentTabView(
      context,
      controller: controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows: true,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
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
      navBarStyle:
          NavBarStyle.style9, // Choose the nav bar style with this property.
    );
  }

  List<Widget> _buildScreens() {
    return const [
      HomePage(),
      PurchaseHistory(),
      NewTrip(),
      Analytics(),
      EditProfile(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home),
        title: (Constants.HOME_LABEL),
        activeColorPrimary: Colors.purple,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.history),
        title: (Constants.PURCHASE_HISTORY_LABEL),
        activeColorPrimary: Colors.purple,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.add),
        title: (Constants.NEW_TRIP_LABEL),
        activeColorPrimary: Colors.purple,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.timeline),
        title: (Constants.ANALYTICS_LABEL),
        activeColorPrimary: Colors.purple,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.account_circle),
        title: (Constants.PROFILE_LABEL),
        activeColorPrimary: Colors.purple,
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }
}