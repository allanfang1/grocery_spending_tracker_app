import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
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

  Widget getGraph(LiveGoal liveGoal) {
    DateTime endDate = DateTime.now().isBefore(liveGoal.goal.endDate)
        ? DateTime.now()
        : liveGoal.goal.endDate;
    List<BarChartGroupData> barGroups = [];
    int resultCounter = 0;
    double maxY = 0;
    //for every day from start of goal to (today or goal end date)
    for (DateTime date = liveGoal.goal.startDate;
        date.isBefore(endDate) || date.isAtSameMomentAs(endDate);
        date = date.add(const Duration(days: 1))) {
      double barLen = 0.0;
      for (Transaction transaction in liveGoal.transactions) {
        if (DateUtils.isSameDay(date, transaction.dateTime)) {
          barLen += transaction.total;
        }
      }
      maxY = max(barLen, maxY);
      barGroups.add(BarChartGroupData(
          x: resultCounter, barRods: [BarChartRodData(toY: barLen)]));
      resultCounter += 1;
    }

    double totalBars = resultCounter.toDouble();
    maxY = ((maxY * 1.1) / 10).ceilToDouble() * 10;
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          reverse: true,
          child: Container(
            padding: EdgeInsets.only(top: 10),
            height: 350,
            width: 20 * totalBars,
            child: BarChart(
              BarChartData(
                maxY: maxY,
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                    leftTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 25,
                            getTitlesWidget: ((value, meta) {
                              if (value % 3 != 0) {
                                return SideTitleWidget(
                                    axisSide: meta.axisSide, child: Text(""));
                              }
                              DateTime date = liveGoal.goal.startDate
                                  .add(Duration(days: value.toInt()));
                              return SideTitleWidget(
                                  axisSide: meta.axisSide,
                                  child: Text(
                                      '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}'));
                            })))),
                barGroups: barGroups,
              ),
            ),
          ),
        ),
      ),
      Container(
          height: 336,
          margin: EdgeInsets.only(left: 2),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text(maxY.toString()), Text((0).toString())]))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final LiveGoal? liveGoal = ref
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
        child: SingleChildScrollView(
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
                        labelStyle: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
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
                        margin: EdgeInsets.fromLTRB(20, 20, 10, 20),
                        child: [
                          getGraph(liveGoal!),
                          Text("2st"),
                        ][_tabIndex],
                      )
                    ],
                  ),
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
                            Helper.currencyFormat(liveGoal?.spendingTotal),
                            style: TextStyle(
                                fontSize: 28), //fix this to be dynamic
                          ),
                          Text(
                            " spent",
                          )
                        ],
                      ),
                      LinearProgressIndicator(
                        value: liveGoal?.progressPercent,
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
                              Helper.currencyFormat(liveGoal?.goal.budget),
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
