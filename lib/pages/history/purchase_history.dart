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
        body: _transactions.isNotEmpty
            ? ListView.builder(
                padding: EdgeInsets.fromLTRB(20, 14, 20, 6),
                itemCount: _transactions.length,
                //TODO: prototypeItem:
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Dismissible(
                        key: Key(index.toString()),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {}, //TODO
                        background: Container(color: Colors.red),
                        child: GestureDetector(
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
                            color: Color.fromARGB(255, 250, 240, 255),
                            padding: EdgeInsets.fromLTRB(12, 10, 12, 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                  Helper.currencyFormat(
                                      _transactions[index].total),
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )
            : Text(
                'You don\'t have any trips yet.',
                style:
                    TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
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
