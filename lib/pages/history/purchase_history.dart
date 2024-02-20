import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_spending_tracker_app/common/constants.dart';
import 'package:grocery_spending_tracker_app/common/helper.dart';
import 'package:grocery_spending_tracker_app/controller/history_controller.dart';
import 'package:grocery_spending_tracker_app/model/transaction.dart';
import 'package:grocery_spending_tracker_app/pages/history/receipt_view.dart';

// ignore_for_file: prefer_const_constructors

class PurchaseHistory extends ConsumerWidget {
  const PurchaseHistory({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(historyControllerProvider);
    return transactionsAsync.when(data: (void data) {
      final List<Transaction> _transactions =
          ref.watch(historyControllerProvider.notifier).getTransactions();
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(Constants.PURCHASE_HISTORY),
        ),
        body: Center(
          child: Container(
            margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: _transactions.isNotEmpty ? ListView.builder(
              padding: EdgeInsets.only(top: 14),
              itemCount: _transactions.length,
              prototypeItem: Card(
                margin: EdgeInsets.only(bottom: 14),
                child: Container(
                  padding: EdgeInsets.fromLTRB(12, 10, 12, 10),
                  child: Row(
                    children: const [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("placeholder",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 18)),
                            Text("placeholder"),
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "placeholder",
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
                        .watch(historyControllerProvider.notifier)
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
                          SizedBox(width: 10),
                          Text(
                            Helper.currencyFormat(_transactions[index].total),
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ) : Text(
              'You don\'t have any trips yet.',
              style: TextStyle(
                  fontStyle: FontStyle.italic, color: Colors.grey),
            ),
          ),
        ),
      );
    }, error: (Object error, StackTrace stackTrace) {
      return Text('Error: $error');
    }, loading: () {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(Constants.PURCHASE_HISTORY),
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
