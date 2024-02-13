import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_spending_tracker_app/common/helper.dart';
import 'package:grocery_spending_tracker_app/controller/analytics_controller.dart';
import 'package:grocery_spending_tracker_app/model/transaction.dart';
import 'package:grocery_spending_tracker_app/pages/receipt_view.dart';

// ignore_for_file: prefer_const_constructors

class Goals extends ConsumerWidget {
  const Goals({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Transaction> _transactions =
        ref.watch(analyticsControllerProvider.notifier).getTransactions();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Purchase History"),
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: ListView.builder(
            padding: EdgeInsets.only(top: 14),
            itemCount: _transactions.length,
            prototypeItem: Card(
              margin: EdgeInsets.only(bottom: 14),
              child: Container(
                padding: EdgeInsets.fromLTRB(12, 10, 12, 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_transactions.first.location ?? "",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 18)),
                          Text(Helper.dateTimeToString(
                              _transactions.first.dateTime)),
                        ],
                      ),
                    ),
                    Text(
                      Helper.priceFormat(_transactions.first.total),
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  ref
                      .watch(analyticsControllerProvider.notifier)
                      .transactionIndex = index;
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ReceiptView(),
                    ),
                  );
                },
                child: Card(
                  margin: EdgeInsets.only(bottom: 14),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(12, 10, 12, 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_transactions[index].location ?? "",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18)),
                              Text(Helper.dateTimeToString(
                                  _transactions[index].dateTime)),
                            ],
                          ),
                        ),
                        Text(
                          Helper.priceFormat(_transactions[index].total),
                          style: TextStyle(fontSize: 16),
                        ),
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
  }
}
