import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_spending_tracker_app/common/helper.dart';
import 'package:grocery_spending_tracker_app/controller/history_controller.dart';
import 'package:grocery_spending_tracker_app/model/transaction.dart';

// This class represents the widget for displaying receipt details.
class ReceiptView extends ConsumerWidget {
  const ReceiptView({super.key});

  // Build method responsible for constructing the UI based on the provided context and ref.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Transaction _transaction =
        ref.watch(historyControllerProvider.notifier).getTransactionByIndex();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text(
          _transaction.transactionId.toString(),
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: Card(
        elevation: 0,
        margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _transaction.location ?? "",
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              ),
              Text(Helper.dateTimeToString(_transaction.dateTime)),
              Text(
                _transaction.description ?? "",
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 12),
              ListView.separated(
                  shrinkWrap: true,
                  itemCount: _transaction.items!.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 5),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _transaction.items![index].description ?? "",
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.fromLTRB(20, 0, 4, 0),
                            child: _transaction.items![index].isTaxed ?? false
                                ? const Text("H")
                                : const Text(""),
                          ),
                          Text(
                            Helper.currencyFormat(
                                _transaction.items![index].price),
                          ),
                        ],
                      ),
                    );
                  }),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Subtotal",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                  Text(Helper.currencyFormat(_transaction.subtotal),
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 16))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                  Text(Helper.currencyFormat(_transaction.total),
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 16))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
