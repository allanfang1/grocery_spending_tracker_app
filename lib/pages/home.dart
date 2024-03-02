// ignore_for_file: prefer_const_literals_to_create_immutables
//ignore_for_file: prefer_const_constructors
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_spending_tracker_app/common/constants.dart';
import 'package:grocery_spending_tracker_app/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:grocery_spending_tracker_app/pages/recommendations/recommendation_modal.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final getUser = ref.watch(profileControllerProvider);
    final user = getUser.when(
      data: (user) => user,
      loading: () => null, // Handle loading state (e.g., show a spinner)
      error: (error, stackTrace) {
        // Handle error state (e.g., show an error message)
        print('Error fetching user: $error');
        return null;
      },
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(Constants.APP_NAME),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Text(
                      'Welcome ${user?.firstName} ${user?.lastName}!',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                      textAlign: TextAlign.center,
                    )),
                Container(
                  padding: EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Your Recommendations',
                          style: TextStyle(fontSize: 18))
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Here\'s some products we think you\'ll love',
                        style: TextStyle(
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey))
                  ],
                ),
                RecommendationModal(),
              ],
            )),
      ),
    );
  }
}
