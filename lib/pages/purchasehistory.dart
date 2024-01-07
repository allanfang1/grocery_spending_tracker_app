import 'package:flutter/material.dart';

class PurchaseHistory extends StatefulWidget {
  const PurchaseHistory({super.key});

  @override
  State<PurchaseHistory> createState() => _PurchaseHistory();
}

class _PurchaseHistory extends State<PurchaseHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Purchase History"),
        // automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 300.0),
          // child: ListView.builder(
          //   itemCount: ,
          //   prototypeItem: ,
          //   itemBuilder: (context, index) {
          //     return Card();
          //   },
          // ),
        ),
      ),
    );
  }
}
