import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_spending_tracker_app/common/constants.dart';
import 'package:grocery_spending_tracker_app/common/helper.dart';
import 'package:grocery_spending_tracker_app/common/loading_overlay.dart';
import 'package:grocery_spending_tracker_app/pages/analytics/create_goal.dart';
import 'package:grocery_spending_tracker_app/pages/analytics/expanded_goal.dart';
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
          title: Text(Constants.ANALYTICS),
          // actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.edit))],
        ),
        body: Center(
          child: Container(
            margin: EdgeInsets.fromLTRB(24, 0, 24, 0),
            child: liveGoals.isNotEmpty
                ? ListView.builder(
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
                              Text(
                                "placeholder",
                                overflow: TextOverflow.ellipsis,
                              ),
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
                                    overflow: TextOverflow.ellipsis,
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
                        onTap: () {
                          ref
                              .watch(
                                  analyticsServiceControllerProvider.notifier)
                              .selectedIndex = index;
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  const LoadingOverlay(child: ExpandedGoal()),
                            ),
                          );
                        },
                        child: Card(
                          margin: EdgeInsets.only(bottom: 14),
                          child: Container(
                            padding: EdgeInsets.fromLTRB(12, 10, 12, 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  liveGoals[index].goal.goalName,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.ideographic,
                                  children: [
                                    Text(
                                      Helper.currencyFormat(
                                          liveGoals[index].spendingTotal),
                                      style: TextStyle(
                                          fontSize:
                                              28), //fix this to be dynamic
                                    ),
                                    Text(
                                      " spent / ${Helper.currencyFormat(liveGoals[index].goal.budget - liveGoals[index].spendingTotal)} remaining",
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  ],
                                ),
                                SizedBox(height: 6),
                                LinearProgressIndicator(
                                  value: liveGoals[index].progressPercent,
                                  minHeight: 10,
                                ),
                                SizedBox(height: 6),
                                Text(
                                    "${liveGoals[index].daysRemaining} days left")
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : Text(
                    'You don\'t have any goals yet, try creating one.',
                    style: TextStyle(
                        fontStyle: FontStyle.italic, color: Colors.grey),
                  ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const LoadingOverlay(child: CreateGoal()),
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
          title: Text(Constants.ANALYTICS),
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
