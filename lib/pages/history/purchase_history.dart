import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_spending_tracker_app/common/constants.dart';
import 'package:grocery_spending_tracker_app/common/helper.dart';
import 'package:grocery_spending_tracker_app/controller/history_controller.dart';
import 'package:grocery_spending_tracker_app/model/transaction.dart';
import 'package:grocery_spending_tracker_app/pages/history/receipt_view.dart';

// This class represents the widget for displaying the purchase history tab.
class PurchaseHistory extends ConsumerWidget {
  const PurchaseHistory({super.key});

  // Build method responsible for constructing the UI based on the provided context and ref.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(historyControllerProvider);
    return transactionsAsync.when(data: (void data) {
      final List<Transaction> _transactions =
          ref.watch(historyControllerProvider.notifier).getTransactions();
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          title: const Text(
            Constants.PURCHASE_HISTORY,
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        body: _transactions.isNotEmpty
            ? ListView.builder(
                padding: const EdgeInsets.only(top: 4),
                itemCount: _transactions.length,
                //TODO: prototypeItem:
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
                      color: Theme.of(context).colorScheme.surface,
                      margin: EdgeInsets.zero,
                      elevation: 0,
                      shape: Border(
                          bottom: BorderSide(
                              width: 1,
                              color: Theme.of(context)
                                  .colorScheme
                                  .outlineVariant)),
                      child: Dismissible(
                        key: Key(index.toString()),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          ref
                              .watch(historyControllerProvider.notifier)
                              .deleteGoal(index);
                        },
                        background: Container(
                            color: Theme.of(context).colorScheme.error),
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(_transactions[index].location ?? "",
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18)),
                                    Text(Helper.dateTimeToString(
                                        _transactions[index].dateTime)),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                Helper.currencyFormat(
                                    _transactions[index].total),
                                style: const TextStyle(fontSize: 17),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )
            : const Text(
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
          title: const Text(
            Constants.PURCHASE_HISTORY,
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        body: Center(
          child: Container(
            margin: const EdgeInsets.fromLTRB(24, 0, 24, 0),
            child: const CircularProgressIndicator(),
          ),
        ),
      );
    });
  }
}
