// ignore_for_file: prefer_const_literals_to_create_immutables
//ignore_for_file: prefer_const_constructors
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_spending_tracker_app/common/constants.dart';
import 'package:grocery_spending_tracker_app/controller/profile_controller.dart';
import 'package:grocery_spending_tracker_app/pages/analytics.dart';
import 'package:grocery_spending_tracker_app/pages/edit_profile.dart';
import 'package:grocery_spending_tracker_app/common/loading_overlay.dart';
import 'package:grocery_spending_tracker_app/pages/login.dart';
import 'package:grocery_spending_tracker_app/pages/new_trip.dart';
import 'package:grocery_spending_tracker_app/pages/purchase_history.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(Constants.APP_NAME),
            automaticallyImplyLeading: false,
          ),
          body: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 300.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const SizedBox(height: 20),
                  SizedBox(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const NewTrip(),
                          ),
                        );
                      },
                      child: const Text('New Trip'),
                    ),
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const PurchaseHistory(),
                          ),
                        );
                      },
                      child: const Text('History'),
                    ),
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const EditProfile(),
                          ),
                        );
                      },
                      child: const Text('Profile'),
                    ),
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const Analytics(),
                          ),
                        );
                      },
                      child: const Text('Analytics'),
                    ),
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    child: Consumer(
                      builder: (_, WidgetRef ref, __) {
                        return OutlinedButton(
                          onPressed: () {
                            ref
                                .watch(profileControllerProvider.notifier)
                                .logout();
                            PersistentNavBarNavigator.pushNewScreen(
                                context,
                                screen: LoadingOverlay(child: LoginPage()),
                                withNavBar: false
                            );
                          },
                          child: const Text('Logout'),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        onWillPop: () async {
          return false;
        });
  }
}
