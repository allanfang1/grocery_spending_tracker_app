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

// A StatefulWidget responsible for displaying expanded details of a goal in analytics.
class ExpandedGoal extends ConsumerStatefulWidget {
  const ExpandedGoal({super.key});

  @override
  ExpandedGoalState createState() => ExpandedGoalState();
}

// The state class for ExpandedGoal widget.
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

  // Function to handle tab selection.
  _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _tabIndex = _tabController.index;
        _showingTooltip = -1;
      });
    }
  }

  // Function to generate tooltip string for weekly data.
  String tooltipWeekString(BarChartGroupData group, LiveGoal liveGoal) {
    return '\n' +
        Helper.dateTimeToString(liveGoal.goal.startDate
            .subtract(Duration(days: liveGoal.goal.startDate.weekday % 7))
            .add(Duration(days: (7 * group.x).toInt())));
  }

  // Function to generate tooltip string for daily data.
  String tooltipDayString(BarChartGroupData group, LiveGoal liveGoal) {
    return '\n' +
        Helper.dateTimeToString(
            liveGoal.goal.startDate.add(Duration(days: (group.x).toInt())));
  }

  // Function to generate bar chart group data given a data point.
  BarChartGroupData generateGroupData(int x, double y) {
    return BarChartGroupData(
      x: x,
      showingTooltipIndicators: _showingTooltip == x ? [0] : [],
      barRods: [
        BarChartRodData(toY: y, color: Theme.of(context).colorScheme.primary),
      ],
    );
  }

  // Function to generate data for daily chart.
  Map<String, dynamic> chartDataDay(LiveGoal liveGoal, int labelFreq) {
    DateTime endDate = DateTime.now().isBefore(liveGoal.goal.endDate)
        ? DateTime.now()
        : liveGoal.goal.endDate;
    List<BarChartGroupData> barGroups = [];
    int resultCounter = 0;
    double maxY = 0;
    //for every day from start of goal to min(today or goal end date)
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
          return SideTitleWidget(
              axisSide: meta.axisSide, child: const Text(""));
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

  // Function to generate data for weekly chart.
  Map<String, dynamic> chartDataWeek(LiveGoal liveGoal, int labelFreq) {
    DateTime startDate = liveGoal.goal.startDate
        .subtract(Duration(days: liveGoal.goal.startDate.weekday % 7));
    DateTime endDate = DateTime.now().isBefore(liveGoal.goal.endDate)
        ? DateTime.now()
        : liveGoal.goal.endDate;
    List<BarChartGroupData> barGroups = [];
    int resultCounter = 0;
    double maxY = 0;
    //aggregating data by start of the week (sunday)
    while (startDate.isBefore(endDate) || startDate.isAtSameMomentAs(endDate)) {
      double barLen = 0.0;
      for (Transaction transaction in liveGoal.transactions) {
        if ((transaction.dateTime.isAfter(liveGoal.goal.startDate) ||
                DateUtils.isSameDay(
                    liveGoal.goal.startDate, transaction.dateTime)) &&
            (transaction.dateTime.isAfter(startDate) ||
                DateUtils.isSameDay(startDate, transaction.dateTime)) &&
            (transaction.dateTime
                    .isBefore(startDate.add(const Duration(days: 6))) ||
                DateUtils.isSameDay(startDate.add(const Duration(days: 6)),
                    transaction.dateTime))) {
          barLen += transaction.total;
        }
      }
      maxY = max(barLen, maxY);
      barGroups.add(generateGroupData(resultCounter, barLen));
      startDate = startDate.add(const Duration(days: 7));
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
          return SideTitleWidget(
              axisSide: meta.axisSide, child: const Text(""));
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

  // Function to get the graph widget.
  Widget getGraph(LiveGoal liveGoal, int labelFreq, Function chartDataFunc,
      Function tooltipData) {
    Map<String, dynamic> chartData = chartDataFunc(liveGoal, labelFreq);
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          reverse: true,
          child: Container(
            padding: const EdgeInsets.fromLTRB(3, 10, 3, 0),
            height: 350,
            width: 20 * chartData['barCount'] as double,
            child: BarChart(
              BarChartData(
                maxY: chartData['maxY'],
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 25,
                            getTitlesWidget: chartData['bottomTitleFunc']))),
                barGroups: chartData['barGroups'],
                barTouchData: BarTouchData(
                  handleBuiltInTouches: false,
                  touchCallback:
                      (FlTouchEvent event, BarTouchResponse? touchResponse) {
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
                    tooltipBgColor:
                        Theme.of(context).colorScheme.outlineVariant,
                    fitInsideHorizontally: true,
                    fitInsideVertically: true,
                    tooltipPadding: const EdgeInsets.fromLTRB(8, 3, 8, 0),
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
                                style: const TextStyle(fontSize: 24)),
                            TextSpan(text: tooltipData(group, liveGoal))
                          ]);
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      Container(
          height: 335,
          margin: const EdgeInsets.only(left: 2),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(chartData['maxY'].toString()),
                Text((0).toString())
              ]))
    ]);
  }

  // Build method responsible for constructing the UI based on the provided context and ref.
  @override
  Widget build(BuildContext context) {
    final LiveGoal liveGoal = ref
        .watch(analyticsServiceControllerProvider.notifier)
        .getLiveGoalByIndex();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text(
          liveGoal.goal.goalName,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
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
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  elevation: 0,
                  margin: const EdgeInsets.fromLTRB(0, 6, 0, 0),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${Helper.dateTimeToString(liveGoal.goal.startDate)}  -  ${Helper.dateTimeToString(liveGoal.goal.endDate)}",
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          Text(liveGoal.goal.goalDescription)
                        ]),
                  ),
                ),
                Card(
                  elevation: 0,
                  margin: const EdgeInsets.fromLTRB(0, 6, 0, 0),
                  child: DefaultTabController(
                    animationDuration: Duration.zero,
                    length: 2, // Number of tabs
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TabBar(
                          controller: _tabController,
                          labelStyle: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
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
                          margin: const EdgeInsets.fromLTRB(20, 20, 10, 20),
                          child: [
                            getGraph(
                                liveGoal, 3, chartDataDay, tooltipDayString),
                            getGraph(
                                liveGoal, 3, chartDataWeek, tooltipWeekString),
                          ][_tabIndex],
                        )
                      ],
                    ),
                  ),
                ),
                Card(
                  elevation: 0,
                  margin: const EdgeInsets.fromLTRB(0, 6, 0, 0),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.ideographic,
                          children: [
                            Text(
                              Helper.currencyFormat(liveGoal.spendingTotal),
                              style: const TextStyle(
                                  fontSize: 28), //fix this to be dynamic
                            ),
                            const Text(
                              " spent",
                            )
                          ],
                        ),
                        LinearProgressIndicator(
                          value: liveGoal.progressPercent,
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          minHeight: 10,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(Helper.currencyFormat(0)),
                            const SizedBox(width: 16),
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
                  elevation: 0,
                  margin: const EdgeInsets.fromLTRB(0, 6, 0, 10),
                  child: ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: liveGoal.transactions.length,
                      separatorBuilder: (context, index) {
                        return const Divider(
                          height: 0,
                          thickness: 1,
                          indent: 54,
                          endIndent: 54,
                        );
                      },
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            ref
                                .watch(historyControllerProvider.notifier)
                                .setIndexById(
                                    liveGoal.transactions[index].transactionId);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const ReceiptView(),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.receipt_long,
                                  size: 38,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(width: 8),
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
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18)),
                                      Text(Helper.dateTimeToString(liveGoal
                                          .transactions[index].dateTime)),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  Helper.currencyFormat(
                                      liveGoal.transactions[index].total),
                                  style: const TextStyle(fontSize: 17),
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
