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
          backgroundColor: Theme.of(context).colorScheme.background,
          title: Text(
            Constants.PURCHASE_HISTORY,
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        body: _transactions.isNotEmpty
            ? ListView.builder(
                padding: EdgeInsets.only(top: 4),
                itemCount: _transactions.length,
                //TODO: prototypeItem:
                itemBuilder: (context, index) {
                  return Card(
                    color: Theme.of(context).colorScheme.surface,
                    margin: EdgeInsets.zero,
                    elevation: 0,
                    shape: Border(
                        bottom: BorderSide(
                            width: 1,
                            color:
                                Theme.of(context).colorScheme.outlineVariant)),
                    child: Dismissible(
                      key: Key(index.toString()),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {}, //TODO
                      background:
                          Container(color: Theme.of(context).colorScheme.error),
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
                          padding: EdgeInsets.fromLTRB(14, 12, 14, 12),
                          child: Row(
                            children: [
                              Icon(
                                Icons.receipt_long,
                                size: 38,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              SizedBox(width: 8),
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
                              SizedBox(width: 12),
                              Text(
                                Helper.currencyFormat(
                                    _transactions[index].total),
                                style: TextStyle(fontSize: 17),
                              ),
                            ],
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
          backgroundColor: Theme.of(context).colorScheme.background,
          title: Text(
            Constants.PURCHASE_HISTORY,
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
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
