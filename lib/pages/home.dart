// ignore_for_file: prefer_const_literals_to_create_immutables
//ignore_for_file: prefer_const_constructors
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_spending_tracker_app/common/constants.dart';
import 'package:grocery_spending_tracker_app/pages/analytics/goals_list.dart';
import 'package:grocery_spending_tracker_app/pages/user/edit_profile.dart';
import 'package:grocery_spending_tracker_app/pages/history/purchase_history.dart';
import 'package:flutter/material.dart';

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
                            builder: (context) => const GoalsList(),
                          ),
                        );
                      },
                      child: const Text('Analytics'),
                    ),
                  ),
                  const SizedBox(height: 6),
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
