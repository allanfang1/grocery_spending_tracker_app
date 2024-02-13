// ignore_for_file: prefer_const_literals_to_create_immutables
//ignore_for_file: prefer_const_constructors
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_spending_tracker_app/common/error_alert.dart';
import 'package:grocery_spending_tracker_app/common/helper.dart';
import 'package:grocery_spending_tracker_app/controller/history_controller.dart';
import 'package:grocery_spending_tracker_app/controller/profile_controller.dart';
import 'package:grocery_spending_tracker_app/pages/analytics.dart';
import 'package:grocery_spending_tracker_app/pages/edit_profile.dart';
import 'package:grocery_spending_tracker_app/pages/login.dart';
import 'package:grocery_spending_tracker_app/pages/new_trip.dart';
import 'package:grocery_spending_tracker_app/pages/purchase_history.dart';
import 'package:flutter/material.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text("Grocery Spending Tracker"),
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
                      onPressed: () async {
                        var response = await ref
                            .watch(historyControllerProvider.notifier)
                            .loadTransactions();
                        if (response.statusCode == 200) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const PurchaseHistory(),
                            ),
                          );
                        } else {
                          showErrorAlertDialog(context, response.body);
                        }
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
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
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
