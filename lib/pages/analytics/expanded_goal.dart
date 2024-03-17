import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_spending_tracker_app/common/helper.dart';
import 'package:grocery_spending_tracker_app/controller/history_controller.dart';
import 'package:grocery_spending_tracker_app/model/live_goal.dart';
import 'package:grocery_spending_tracker_app/model/transaction.dart';
import 'package:grocery_spending_tracker_app/pages/history/receipt_view.dart';
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
  int _showingTooltip = -1;

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
        _showingTooltip = -1;
      });
    }
  }

  BarChartGroupData generateGroupData(int x, double y) {
    return BarChartGroupData(
      x: x,
      showingTooltipIndicators: _showingTooltip == x ? [0] : [],
      barRods: [
        BarChartRodData(toY: y),
      ],
    );
  }

  Map<String, dynamic> chartDataDay(LiveGoal liveGoal, int labelFreq) {
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
      barGroups.add(generateGroupData(resultCounter, barLen));
      resultCounter += 1;
    }
    double barCount = resultCounter.toDouble();
    maxY = ((maxY * 1.1) / 10).ceilToDouble() * 10;
    return {
      'barGroups': barGroups,
      'barCount': barCount,
      'maxY': maxY,
      'bottomTitleFunc': ((value, meta) {
        if (value % labelFreq != 0) {
          return SideTitleWidget(axisSide: meta.axisSide, child: Text(""));
        }
        DateTime date =
            liveGoal.goal.startDate.add(Duration(days: value.toInt()));
        return SideTitleWidget(
            axisSide: meta.axisSide,
            child: Text(
                '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}'));
      })
    };
  }

  Map<String, dynamic> chartDataWeek(LiveGoal liveGoal, int labelFreq) {
    DateTime startDate = liveGoal.goal.startDate
        .subtract(Duration(days: liveGoal.goal.startDate.weekday % 7));
    DateTime endDate = DateTime.now().isBefore(liveGoal.goal.endDate)
        ? DateTime.now()
        : liveGoal.goal.endDate;
    List<BarChartGroupData> barGroups = [];
    int resultCounter = 0;
    double maxY = 0;
    //for every day from start of goal to (today or goal end date)
    while (startDate.isBefore(endDate) || startDate.isAtSameMomentAs(endDate)) {
      double barLen = 0.0;
      for (Transaction transaction in liveGoal.transactions) {
        if ((transaction.dateTime.isAfter(liveGoal.goal.startDate) ||
                DateUtils.isSameDay(
                    liveGoal.goal.startDate, transaction.dateTime)) &&
            (transaction.dateTime.isAfter(startDate) ||
                DateUtils.isSameDay(startDate, transaction.dateTime)) &&
            (transaction.dateTime.isBefore(startDate.add(Duration(days: 6))) ||
                DateUtils.isSameDay(
                    startDate.add(Duration(days: 6)), transaction.dateTime))) {
          barLen += transaction.total;
        }
      }
      maxY = max(barLen, maxY);
      barGroups.add(generateGroupData(resultCounter, barLen));
      startDate = startDate.add(Duration(days: 7));
      resultCounter += 1;
    }
    double barCount = resultCounter.toDouble();
    maxY = ((maxY * 1.1) / 10).ceilToDouble() * 10;
    return {
      'barGroups': barGroups,
      'barCount': barCount,
      'maxY': maxY,
      'bottomTitleFunc': ((value, meta) {
        if (value % labelFreq != 0) {
          return SideTitleWidget(axisSide: meta.axisSide, child: Text(""));
        }
        DateTime date = liveGoal.goal.startDate
            .subtract(Duration(days: liveGoal.goal.startDate.weekday % 7))
            .add(Duration(days: (7 * value).toInt()));
        return SideTitleWidget(
            axisSide: meta.axisSide,
            child: Text(
                '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}'));
      })
    };
  }

  Widget getGraph(LiveGoal liveGoal, int labelFreq, Function chartDataFunc) {
    Map<String, dynamic> chartData = chartDataFunc(liveGoal, labelFreq);
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          reverse: true,
          child: Container(
            padding: EdgeInsets.fromLTRB(3, 10, 3, 0),
            height: 350,
            width: 20 * chartData['barCount'] as double,
            child: BarChart(
              BarChartData(
                  maxY: chartData['maxY'],
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
                              getTitlesWidget: chartData['bottomTitleFunc']))),
                  barGroups: chartData['barGroups'],
                  barTouchData: BarTouchData(
                      handleBuiltInTouches: false,
                      touchCallback: (FlTouchEvent event,
                          BarTouchResponse? touchResponse) {
                        if (touchResponse == null) {
                          return;
                        } else if (event is FlTapUpEvent &&
                            touchResponse.spot == null) {
                          setState(() {
                            _showingTooltip = -1;
                          });
                        } else if (event is FlTapUpEvent) {
                          final sectionIndex =
                              touchResponse.spot!.touchedBarGroupIndex;
                          setState(() {
                            if (_showingTooltip == sectionIndex) {
                              _showingTooltip = -1;
                            } else {
                              _showingTooltip = sectionIndex;
                            }
                          });
                        }
                      },
                      touchTooltipData: BarTouchTooltipData(
                        fitInsideHorizontally: true,
                        tooltipPadding: EdgeInsets.fromLTRB(8, 2, 8, 1),
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          final color = rod.gradient?.colors.first ?? rod.color;
                          final textStyle = TextStyle(
                            color: color,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          );
                          return BarTooltipItem(
                              textAlign: TextAlign.start,
                              "TOTAL",
                              textStyle,
                              children: [
                                TextSpan(
                                    text: '\n${Helper.currencyFormat(rod.toY)}',
                                    style: TextStyle(fontSize: 24)),
                                TextSpan(
                                    text: '\n' +
                                        Helper.dateTimeToString(liveGoal
                                            .goal.startDate
                                            .subtract(Duration(
                                                days: liveGoal.goal.startDate
                                                        .weekday %
                                                    7))
                                            .add(Duration(
                                                days: (7 * group.x).toInt()))))
                              ]);
                        },
                      ))),
            ),
          ),
        ),
      ),
      Container(
          height: 335,
          margin: EdgeInsets.only(left: 2),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(chartData['maxY'].toString()),
                Text((0).toString())
              ]))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final LiveGoal liveGoal = ref
        .watch(analyticsServiceControllerProvider.notifier)
        .getLiveGoalByIndex();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(liveGoal.goal.goalName),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.edit))],
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          setState(() {
            _showingTooltip = -1;
          });
        },
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 2),
                  child: Container(
                    padding: EdgeInsets.all(12),
                    child: Text(liveGoal.goal.goalDescription),
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
                            getGraph(liveGoal, 3, chartDataDay),
                            getGraph(liveGoal, 3, chartDataWeek),
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
                              Helper.currencyFormat(liveGoal.spendingTotal),
                              style: TextStyle(
                                  fontSize: 28), //fix this to be dynamic
                            ),
                            Text(
                              " spent",
                            )
                          ],
                        ),
                        LinearProgressIndicator(
                          value: liveGoal.progressPercent,
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
                                Helper.currencyFormat(liveGoal.goal.budget),
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
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 6),
                  child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: liveGoal.transactions.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            ref
                                .watch(historyControllerProvider.notifier)
                                .transactionIndex = index;
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const ReceiptView(),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.fromLTRB(12, 10, 12, 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          liveGoal.transactions[index]
                                                  .location ??
                                              "",
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18)),
                                      Text(Helper.dateTimeToString(liveGoal
                                          .transactions[index].dateTime)),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  Helper.currencyFormat(
                                      liveGoal.transactions[index].total),
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
