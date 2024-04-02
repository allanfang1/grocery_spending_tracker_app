// ignore_for_file: prefer_const_literals_to_create_immutables
//ignore_for_file: prefer_const_constructors
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_spending_tracker_app/common/constants.dart';
import 'package:flutter/material.dart';
import 'package:grocery_spending_tracker_app/pages/recommendations/recommendation_modal.dart';

// The home page or landing page tab of the app, displays the recommendations.
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text(
          Constants.APP_NAME,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 6, 0, 6),
                  child: Text('Some recent products we think you\'ll love',
                      style: TextStyle(
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant)),
                )
              ],
            ),
            RecommendationModal(),
          ],
        ),
      ),
    );
  }
}
