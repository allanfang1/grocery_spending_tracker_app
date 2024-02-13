import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_spending_tracker_app/common/helper.dart';
import 'package:grocery_spending_tracker_app/controller/history_controller.dart';
import 'package:grocery_spending_tracker_app/model/transaction.dart';
import 'package:grocery_spending_tracker_app/pages/receipt_view.dart';
import 'package:grocery_spending_tracker_app/service/analytics_service_controller.dart';

// ignore_for_file: prefer_const_constructors

class Analytics extends ConsumerWidget {
  const Analytics({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final liveGoalsAsync = ref.watch(analyticsServiceControllerProvider);
    return liveGoalsAsync.when(data: (liveGoals) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text("Analytics"),
          actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.edit))],
        ),
        body: Center(
          child: Container(
            margin: EdgeInsets.fromLTRB(24, 30, 24, 0),
            child: ListView.builder(
              padding: EdgeInsets.only(top: 14),
              itemCount: liveGoals.length,
              // prototypeItem: Card(
              //   margin: EdgeInsets.only(bottom: 14),
              //   child: Container(
              //     padding: EdgeInsets.fromLTRB(12, 10, 12, 10),
              //     child: Row(
              //       children: const [
              //         Expanded(
              //           child: Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Text("placeholder",
              //                   style: TextStyle(
              //                       fontWeight: FontWeight.w500, fontSize: 18)),
              //               Text("placeholder"),
              //             ],
              //           ),
              //         ),
              //         SizedBox(width: 10),
              //         Text(
              //           "placeholder",
              //           style: TextStyle(fontSize: 16),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
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
                                Helper.priceFormat(liveGoals[index][1]),
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
                            value: liveGoals[index][3],
                            minHeight: 10,
                          ),
                          SizedBox(height: 6),
                          Text(liveGoals[index][2].toString() + " days left")
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );
    }, error: (Object error, StackTrace stackTrace) {
      return Text('Error: $error');
    }, loading: () {
      return CircularProgressIndicator();
    });
  }
}
