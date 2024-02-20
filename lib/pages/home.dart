// ignore_for_file: prefer_const_literals_to_create_immutables
//ignore_for_file: prefer_const_constructors
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_spending_tracker_app/common/constants.dart';
import 'package:grocery_spending_tracker_app/controller/profile_controller.dart';
import 'package:flutter/material.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final getUser = ref.watch(profileControllerProvider.notifier).getUser();
    return Scaffold(
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
              Container(
                padding: EdgeInsets.only(top: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                        child: Text(
                            'Welcome ${getUser.firstName} ${getUser.lastName}!',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 25)))
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('logout moved to profile page',
                        style: TextStyle(fontSize: 18))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
