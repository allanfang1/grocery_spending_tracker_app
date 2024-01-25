// ignore_for_file: prefer_const_literals_to_create_immutables
//ignore_for_file: prefer_const_constructors
import 'package:grocery_spending_tracker_app/pages/login.dart';
import 'package:grocery_spending_tracker_app/pages/new_trip.dart';
import 'package:grocery_spending_tracker_app/pages/purchase_history.dart';

import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text("Hola Signora"),
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
                      onPressed: null,
                      child: const Text('Profile'),
                    ),
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    child: OutlinedButton(
                      onPressed: null,
                      child: const Text('Analysis'),
                    ),
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                      child: const Text('Back to login'),
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
