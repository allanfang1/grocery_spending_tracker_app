import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_spending_tracker_app/common/error_alert.dart';
import 'package:grocery_spending_tracker_app/common/helper.dart';
import 'package:grocery_spending_tracker_app/controller/history_controller.dart';
import 'package:grocery_spending_tracker_app/model/live_goal.dart';
import 'package:grocery_spending_tracker_app/model/transaction.dart';
import 'package:grocery_spending_tracker_app/service/analytics_service_controller.dart';

// ignore_for_file: prefer_const_constructors

class ExpandedGoal extends ConsumerStatefulWidget {
  const ExpandedGoal({super.key});

  @override
  ExpandedGoalState createState() => ExpandedGoalState();
}

class ExpandedGoalState extends ConsumerState<ExpandedGoal>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _tabIndex = 0;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
    super.initState();
  }

  _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _tabIndex = _tabController.index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final LiveGoal? _liveGoal = ref
        .watch(analyticsServiceControllerProvider.notifier)
        .getLiveGoalByIndex();
    // if (_liveGoal == null) {
    //   return showErrorAlertDialog(context, "Invalid Goal");
    // }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("placeholder Goal ID/name"),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.edit))],
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 2),
              child: Container(
                padding: EdgeInsets.all(12),
                child: Text(
                    "Description placeholder i'm in detroit with khadija and my tempo"),
              ),
            ),
            Card(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 2),
              child: Container(
                padding: EdgeInsets.all(12),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.ideographic,
                      children: [
                        Text(
                          Helper.currencyFormat(_liveGoal?.spendingTotal),
                          style:
                              TextStyle(fontSize: 28), //fix this to be dynamic
                        ),
                        Text(
                          " spent",
                        )
                      ],
                    ),
                    LinearProgressIndicator(
                      value: _liveGoal?.progressPercent,
                      minHeight: 10,
                    ),
                    SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(Helper.currencyFormat(0)),
                        SizedBox(width: 16),
                        Flexible(
                          child: Text(
                            Helper.currencyFormat(_liveGoal?.goal.budget),
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Card(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 2),
              child: DefaultTabController(
                animationDuration: Duration.zero,
                length: 2, // Number of tabs
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TabBar(
                      controller: _tabController,
                      labelColor: Colors.deepPurple,
                      unselectedLabelColor: Colors.grey,
                      labelStyle:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                      indicator: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                          color: Colors.white),
                      indicatorSize: TabBarIndicatorSize.tab,
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
                      tabs: const [
                        Tab(
                          height: 32,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text("Day"),
                          ),
                        ),
                        Tab(
                          height: 32,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text("Week"),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      child: [
                        BarChart(
                          BarChartData(
                            barGroups: ref
                                .watch(
                                    analyticsServiceControllerProvider.notifier)
                                .getBarChartGroupDataByIndex(),
                          ),
                          // swapAnimationDuration: Duration(milliseconds: 150), // Optional
                          // swapAnimationCurve: Curves.linear, // Optional
                        ),
                        Text("2st"),
                      ][_tabIndex],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
