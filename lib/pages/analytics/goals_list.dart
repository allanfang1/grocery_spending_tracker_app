import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_spending_tracker_app/common/constants.dart';
import 'package:grocery_spending_tracker_app/common/helper.dart';
import 'package:grocery_spending_tracker_app/pages/analytics/create_goal.dart';
import 'package:grocery_spending_tracker_app/service/analytics_service_controller.dart';

// ignore_for_file: prefer_const_constructors

class GoalsList extends ConsumerWidget {
  const GoalsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final liveGoalsAsync = ref.watch(analyticsServiceControllerProvider);
    return liveGoalsAsync.when(data: (liveGoals) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(Constants.ANALYTICS_LABEL),
          actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.edit))],
        ),
        body: Center(
          child: Container(
            margin: EdgeInsets.fromLTRB(24, 0, 24, 0),
            child: ListView.builder(
              padding: EdgeInsets.only(top: 14),
              itemCount: liveGoals.length,
              prototypeItem: GestureDetector(
                onTap: () {},
                child: Card(
                  margin: EdgeInsets.only(bottom: 14),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(12, 10, 12, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.ideographic,
                          children: [
                            Text(
                              "0",
                              style: TextStyle(
                                  fontSize: 28), //fix this to be dynamic
                            ),
                            Text(
                              "placeholder",
                            )
                          ],
                        ),
                        SizedBox(height: 6),
                        LinearProgressIndicator(
                          value: 0,
                          minHeight: 10,
                        ),
                        SizedBox(height: 6),
                        Text("placeholder")
                      ],
                    ),
                  ),
                ),
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {},
                  child: Card(
                    margin: EdgeInsets.only(bottom: 14),
                    child: Container(
                      padding: EdgeInsets.fromLTRB(12, 10, 12, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.ideographic,
                            children: [
                              Text(
                                Helper.currencyFormat(
                                    liveGoals[index].spendingTotal),
                                style: TextStyle(
                                    fontSize: 28), //fix this to be dynamic
                              ),
                              Text(
                                " spent",
                              )
                            ],
                          ),
                          SizedBox(height: 6),
                          LinearProgressIndicator(
                            value: liveGoals[index].progressPercent,
                            minHeight: 10,
                          ),
                          SizedBox(height: 6),
                          Text("${liveGoals[index].daysRemaining} days left")
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const CreateGoal(),
            ),
          ),
          child: Icon(Icons.add),
        ),
      );
    }, error: (Object error, StackTrace stackTrace) {
      return Text('Error: $error');
    }, loading: () {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(Constants.ANALYTICS_LABEL),
          actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.edit))],
        ),
        body: Center(
          child: Container(
            margin: EdgeInsets.fromLTRB(24, 0, 24, 0),
            child: CircularProgressIndicator(),
          ),
        ),
      );
    });
  }
}
