import 'package:flutter/material.dart';
import 'package:grocery_spending_tracker_app/src/grocery_trip.dart';
import 'package:grocery_spending_tracker_app/src/item.dart';

class ConfirmReceipt extends StatefulWidget {
  final GroceryTrip tripData;

  const ConfirmReceipt({Key? key, required this.tripData}) : super(key: key);

  @override
  State<ConfirmReceipt> createState() => _ConfirmReceiptState();
}

class _ConfirmReceiptState extends State<ConfirmReceipt> {
  late int _dateTime;
  late String _location;
  late List<Item> _items;
  late double _subtotal;
  late double _total;
  late String? _tripDesc;

  final _confirmReceiptKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _dateTime = widget.tripData.dateTime;
    _location = widget.tripData.location;
    _items = widget.tripData.items;
    _subtotal = widget.tripData.subtotal;
    _total = widget.tripData.total;
    _tripDesc = widget.tripData.tripDesc;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildDateTime() {
    return Text("hello");
  }

  Widget _buildLocation() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Location'),
      initialValue: _location,
      validator: (String? value) {
        if (value == null || value.isEmpty) return 'Location is required';
        return null;
      },
      onSaved: (String? value) {
        _location = value!;
      },
    );
  }

  Widget _buildItems() {
    return Text("hello");
  }

  Widget _buildSubtotal() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Subtotal'),
      initialValue: _subtotal.toString(),
      keyboardType: const TextInputType.numberWithOptions(
        decimal: true,
        signed: false,
      ),
      validator: (String? value) {
        final priceRegex = RegExp(r'^\d+(.\d{1,2})?$');

        if (value == null || value.isEmpty) {
          return 'Subtotal is required';
        } else if (priceRegex.hasMatch(value)) {
          return 'Subtotal should follow format X.XX';
        }
        return null;
      },
      onSaved: (String? value) {
        _subtotal = double.parse(value!);
      },
    );
  }

  Widget _buildTotal() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Total'),
      initialValue: _total.toString(),
      keyboardType: const TextInputType.numberWithOptions(
        decimal: true,
        signed: false,
      ),
      validator: (String? value) {
        final priceRegex = RegExp(r'^\d+(.\d{1,2})?$');

        if (value == null || value.isEmpty) {
          return 'Total is required';
        } else if (priceRegex.hasMatch(value)) {
          return 'Total should follow format X.XX';
        }
        return null;
      },
      onSaved: (String? value) {
        _total = double.parse(value!);
      },
    );
  }

  Widget _buildTripDesc() {
    return Text("hello");
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Confirm Scanned Receipt'),
        ),
        body: Container(
          margin: const EdgeInsets.all(24.0),
          child: Form(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // _buildDateTime(),
              _buildLocation(),
              // _buildItems(),
              _buildSubtotal(),
              _buildTotal(),
              // _buildTripDesc(),
              SizedBox(height: 100),
              ElevatedButton(
                  onPressed: () => {
                        if (_confirmReceiptKey.currentState!.validate())
                          {
                            // TODO Save Data, Update Grocery Trip, Send Data
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Processing Data')),
                            )
                          }
                      },
                  child: const Text('Confirm Receipt'))
            ],
          )),
        ),
      );
}
