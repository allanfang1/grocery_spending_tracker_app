import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_spending_tracker_app/common/helper.dart';
import 'package:grocery_spending_tracker_app/controller/analytics_controller.dart';
import 'package:grocery_spending_tracker_app/model/transaction.dart';

// ignore_for_file: prefer_const_constructors

class ReceiptView extends ConsumerWidget {
  const ReceiptView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Transaction _transaction =
        ref.watch(analyticsControllerProvider.notifier).getTransactionByIndex();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(_transaction.transactionId.toString() ?? ""),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.edit))],
      ),
      body: Card(
        margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _transaction.location ?? "",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              ),
              Text(Helper.dateTimeToString(_transaction.dateTime)),
              Text(
                _transaction.description ?? "",
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 12),
              ListView.separated(
                  shrinkWrap: true,
                  itemCount: _transaction.items!.length,
                  separatorBuilder: (context, index) => SizedBox(height: 5),
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
                            margin: EdgeInsets.fromLTRB(20, 0, 4, 0),
                            child: _transaction.items![index].isTaxed ?? false
                                ? Text("H")
                                : Text(""),
                          ),
                          Text(
                            Helper.priceFormat(
                                _transaction.items![index].price),
                          ),
                        ],
                      ),
                    );
                  }),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Subtotal",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                  Text(Helper.priceFormat(_transaction.subtotal),
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 16))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                  Text(Helper.priceFormat(_transaction.total),
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 16))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
