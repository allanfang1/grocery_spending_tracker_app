import 'package:flutter/material.dart';
import 'package:grocery_spending_tracker_app/src/grocery_trip.dart';
import 'package:grocery_spending_tracker_app/src/item.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:intl/intl.dart';

class ConfirmReceipt extends StatefulWidget {
  final GroceryTrip tripData;

  const ConfirmReceipt({Key? key, required this.tripData}) : super(key: key);

  @override
  State<ConfirmReceipt> createState() => _ConfirmReceiptState();
}

class _ConfirmReceiptState extends State<ConfirmReceipt> {
  final DateFormat _dateFormat = DateFormat.yMMMMd('en_US').add_Hms();
  final List<Widget> _itemFields = [];

  late int _dateTime;
  late ValueNotifier<String> _dateTimeString; // for user display of dateTime
  late String _location;
  late List<Item> _items;
  late int _itemCount; // for tracking added/deleted items
  late double _subtotal;
  late double _total;
  late String? _tripDesc;

  final _confirmReceiptKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _dateTime = widget.tripData.dateTime;
    _dateTimeString = ValueNotifier<String>(_dateFormat.format(
        DateTime.fromMillisecondsSinceEpoch(widget.tripData.dateTime * 1000)));
    _location = widget.tripData.location;
    _items = widget.tripData.items;
    _itemCount = _items.length;
    _subtotal = widget.tripData.subtotal;
    _total = widget.tripData.total;
    _tripDesc = widget.tripData.tripDesc;

    for (int i = 0; i < _items.length; i++) {
      _itemFields.add(_buildItem(i));
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildDateTime(BuildContext context) {
    var textValue = TextEditingController();
    textValue.text = _dateTimeString.value;

    return ListTile(
        title: ValueListenableBuilder<String>(
            valueListenable: _dateTimeString,
            builder: (context, String value, Widget? child) {
              return TextField(
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Date and Time of Purchase',
                ),
                controller: textValue,
              );
            }),
        trailing: Material(
          child: Ink(
            decoration: ShapeDecoration(
                color: Colors.purple[50], shape: const CircleBorder()),
            child: IconButton(
              onPressed: () {
                return DatePicker.showDatePicker(context,
                    pickerTheme: DateTimePickerTheme(
                        pickerHeight: MediaQuery.of(context).size.height / 2),
                    dateFormat: 'MMM dd yyyy HH:mm:ss',
                    initialDateTime:
                        DateTime.fromMillisecondsSinceEpoch(_dateTime * 1000),
                    minDateTime: DateTime(2000),
                    maxDateTime: DateTime.now(),
                    onMonthChangeStartWithFirstDate: false,
                    onConfirm: (DateTime selected, List<int> index) {
                  setState(() {
                    _dateTime = selected.millisecondsSinceEpoch ~/ 1000;
                    _dateTimeString.value = _dateFormat.format(selected);
                    textValue.text = _dateTimeString.value;
                  });
                });
              },
              icon: const Icon(Icons.edit_calendar_outlined),
              color: Colors.purple[900],
            ),
          ),
        ));
  }

  Widget _buildLocation() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Location (Address)'),
      initialValue: _location,
      validator: (String? value) {
        if (value == null || value.isEmpty) return 'Location is required';
        return null;
      },
      onSaved: (String? value) {
        setState(() {
          _location = value!;
        });
      },
    );
  }

  Widget _buildItem(int index) {
    Color getColor(Set<MaterialState> states) {
      if (_items[index].taxed) return Colors.purple;
      return Colors.white;
    }

    return Container(
        padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
        child: Column(
          children: [
            Text(
              "Item ${index + 1}",
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Item ID (SKU)'),
              initialValue: _items[index].itemKey,
              keyboardType: TextInputType.number,
              onChanged: (String? value) {
                _items[index].itemKey = value!;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Item Name'),
              initialValue: _items[index].itemDesc,
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Item Name is required';
                }
                return null;
              },
              onChanged: (String? value) {
                _items[index].itemDesc = value!;
              },
            ),
            CheckboxListTile(
              title: const Text('Taxed?'),
              checkColor: Colors.white,
              fillColor: MaterialStateProperty.resolveWith(getColor),
              value: _items[index].taxed,
              onChanged: (bool? value) {
                _items[index].taxed = !_items[index].taxed;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Price'),
              initialValue: _items[index].price.toString(),
              keyboardType: const TextInputType.numberWithOptions(
                  decimal: true, signed: false),
              validator: (String? value) {
                final priceRegex = RegExp(r'^\d+(.\d{2})?$');

                if (value == null || value.isEmpty) {
                  return 'Item price is required';
                } else if (!priceRegex.hasMatch(value)) {
                  return 'Price should follow format X.XX';
                }
                return null;
              },
              onChanged: (String? value) {
                _items[index].price = double.parse(value!);
              },
            ),
          ],
        ));
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
        final priceRegex = RegExp(r'^\d+(.\d{2})?$');

        if (value == null || value.isEmpty) {
          return 'Subtotal is required';
        } else if (!priceRegex.hasMatch(value)) {
          return 'Subtotal should follow format X.XX';
        }
        return null;
      },
      onSaved: (String? value) {
        setState(() {
          _subtotal = double.parse(value!);
        });
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
        final priceRegex = RegExp(r'^\d+(.\d{2})?$');

        if (value == null || value.isEmpty) {
          return 'Total is required';
        } else if (!priceRegex.hasMatch(value)) {
          return 'Total should follow format X.XX';
        }
        return null;
      },
      onSaved: (String? value) {
        setState(() {
          _total = double.parse(value!);
        });
      },
    );
  }

  Widget _buildTripDesc() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Trip Description'),
      initialValue: _tripDesc,
      onSaved: (String? value) {
        setState(() {
          _tripDesc = value!;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Scanned Receipt'),
      ),
      body: Container(
        margin: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Form(
              key: _confirmReceiptKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildDateTime(context),
                  _buildLocation(),
                  _itemCount == 0
                      ? const Padding(
                          padding: EdgeInsets.all(15),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "No grocery items found.",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ))
                      : ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _itemFields.length,
                          shrinkWrap: true,
                          separatorBuilder: (context, index) {
                            return const Divider();
                          },
                          itemBuilder: (context, index) {
                            return Dismissible(
                              background: Container(
                                color: Colors.red,
                              ),
                              key: UniqueKey(),
                              onDismissed: (DismissDirection direction) {
                                setState(() {
                                  _itemCount--;
                                  _itemFields[index] = Container();
                                });
                              },
                              child: _itemFields[index],
                            );
                          },
                        ),
                  _buildSubtotal(),
                  _buildTotal(),
                  _buildTripDesc(),
                  const SizedBox(height: 20),
                  ElevatedButton(
                      onPressed: () => {
                            if (_confirmReceiptKey.currentState!.validate())
                              {
                                // TODO Save Data, Update Grocery Trip, Send Data
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Processing Data')),
                                )
                              }
                          },
                      child: const Text('Confirm Receipt'))
                ],
              )),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _itemCount++;
            _items.add(Item('', '', 0.00, false));
            _itemFields.add(_buildItem(_items.length-1));
          });
        },
        child: const Text('NEW\nITEM'),
      ),
    );
  }
}
