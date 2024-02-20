import 'package:flutter/material.dart';
import 'package:grocery_spending_tracker_app/common/loading_overlay.dart';
import 'package:grocery_spending_tracker_app/controller/confirm_receipt_controller.dart';
import 'package:grocery_spending_tracker_app/model/grocery_trip.dart';
import 'package:grocery_spending_tracker_app/model/capture_item.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_spending_tracker_app/pages/app_nav.dart';
import 'package:intl/intl.dart';
import 'package:grocery_spending_tracker_app/common/constants.dart';

class ConfirmReceipt extends ConsumerStatefulWidget {
  final GroceryTrip tripData;

  const ConfirmReceipt({Key? key, required this.tripData}) : super(key: key);

  @override
  ConsumerState<ConfirmReceipt> createState() => _ConfirmReceiptState();
}

class _ConfirmReceiptState extends ConsumerState<ConfirmReceipt> {
  final DateFormat _dateFormat = DateFormat.yMMMMd('en_US').add_Hms();
  final List<Widget> _itemFields = [];

  late int _dateTime;
  late ValueNotifier<String> _dateTimeString; // for user display of dateTime
  late String _location;
  late List<Item> _items;
  late double _subtotal;
  late double _total;
  late String? _tripDesc;

  final _confirmReceiptKey = GlobalKey<FormState>();
  final _confirmItemKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _dateTime = widget.tripData.dateTime;
    _dateTimeString = ValueNotifier<String>(_dateFormat.format(
        DateTime.fromMillisecondsSinceEpoch(widget.tripData.dateTime * 1000)));
    _location = widget.tripData.location;
    _items = widget.tripData.items;
    _subtotal = widget.tripData.subtotal;
    _total = widget.tripData.total;
    _tripDesc = widget.tripData.tripDesc;

    Future.delayed(Duration.zero, () {
      for (int i = 0; i < _items.length; i++) {
        setState(() {
          _itemFields.add(_buildItem(context, i));
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildDateTime(BuildContext context) {
    var textValue = TextEditingController();
    textValue.text = _dateTimeString.value;

    return ValueListenableBuilder<String>(
        valueListenable: _dateTimeString,
        builder: (context, String value, Widget? child) {
          return TextField(
            readOnly: true,
            decoration: const InputDecoration(
              labelText: Constants.DATE_TIME_LABEL,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: Icon(Icons.calendar_today)
            ),
            onTap: () {
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
            controller: textValue,
          );
        });
  }

  Widget _buildLocation() {
    return TextFormField(
      decoration: const InputDecoration(labelText: Constants.LOCATION_LABEL),
      initialValue: _location,
      validator: (String? value) {
        if (value == null || value.isEmpty) return 'Location is required';
        return null;
      },
      onChanged: (String? value) {
        setState(() {
          _location = value!;
        });
      },
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    Color getColor(Set<MaterialState> states) {
      if (_items[index].taxed) return Colors.purple;
      return Colors.white;
    }

    return ListenableBuilder(
        listenable: _items[index],
        builder: (context, Widget? child) {
          return Card(
              child: ListTile(
            title: Text(_items[index].itemDesc),
            subtitle: Text(
                'Item ID: ${_items[index].itemKey}, Price: ${_items[index].price}, Taxed: ${_items[index].taxed}'),
            trailing: const Icon(Icons.edit),
            onTap: () async {
              await showDialog(
                  context: context,
                  builder: (context) {
                    return StatefulBuilder(builder: (context, setState) {
                      return AlertDialog(
                        title: const Text(Constants.EDIT_ITEM_LABEL),
                        content: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                                right: -40,
                                top: -40,
                                child: InkResponse(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const CircleAvatar(
                                    backgroundColor: Colors.red,
                                    child: Icon(Icons.close),
                                  ),
                                )),
                            Form(
                                key: _confirmItemKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextFormField(
                                      decoration: const InputDecoration(
                                          labelText: Constants.ITEM_ID_LABEL),
                                      initialValue: _items[index].itemKey,
                                      keyboardType: TextInputType.number,
                                      onSaved: (String? value) {
                                        setState(() {
                                          _items[index].updateItem(
                                              value!, null, null, null);
                                        });
                                      },
                                    ),
                                    TextFormField(
                                      decoration: const InputDecoration(
                                          labelText: Constants.ITEM_NAME_LABEL),
                                      initialValue: _items[index].itemDesc,
                                      validator: (String? value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Item Name is required';
                                        }
                                        return null;
                                      },
                                      onSaved: (String? value) {
                                        setState(() {
                                          _items[index].updateItem(
                                              null, value!, null, null);
                                        });
                                      },
                                    ),
                                    CheckboxListTile(
                                      title: const Text(Constants.TAXED_LABEL),
                                      checkColor: Colors.white,
                                      fillColor:
                                          MaterialStateProperty.resolveWith(
                                              getColor),
                                      value: _items[index].taxed,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          _items[index].updateItem(
                                              null, null, null, value!);
                                        });
                                      },
                                    ),
                                    TextFormField(
                                      decoration: const InputDecoration(
                                          labelText:
                                              Constants.ITEM_PRICE_LABEL),
                                      initialValue:
                                          _items[index].price.toString(),
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                              decimal: true, signed: false),
                                      validator: (String? value) {
                                        final priceRegex =
                                            RegExp(r'^\d+(.\d{2})?$');

                                        if (value == null || value.isEmpty) {
                                          return 'Item price is required';
                                        } else if (!priceRegex
                                            .hasMatch(value)) {
                                          return 'Price should follow format X.XX';
                                        }
                                        return null;
                                      },
                                      onSaved: (String? value) {
                                        setState(() {
                                          _items[index].updateItem(null, null,
                                              double.parse(value!), null);
                                        });
                                      },
                                    ),
                                    ElevatedButton(
                                        onPressed: () {
                                          if (_confirmItemKey.currentState!
                                              .validate()) {
                                            _confirmItemKey.currentState!
                                                .save();
                                            Navigator.of(context).pop();
                                          }
                                        },
                                        child:
                                            const Text(Constants.CONFIRM_LABEL))
                                  ],
                                ))
                          ],
                        ),
                      );
                    });
                  });
            },
          ));
        });
  }

  Widget _buildItems(BuildContext context) {
    return Column(
      children: [
        const Padding(
            padding: EdgeInsets.only(top: 15),
            child: Text(
              Constants.ITEM_LIST_LABEL,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline),
            )),
        const Text(
          'Swipe left or right to remove an item',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _itemFields.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Dismissible(
              background: Container(
                color: Colors.red,
              ),
              key: UniqueKey(),
              onDismissed: (DismissDirection direction) {
                setState(() {
                  _items[index].updateItem(null, 'USER REMOVED', null, null);
                  _itemFields[index] = Container();
                });
              },
              child: _itemFields[index],
            );
          },
        ),
      ],
    );
  }

  Widget _buildSubtotal() {
    return TextFormField(
      decoration:
          const InputDecoration(labelText: Constants.TRIP_SUBTOTAL_LABEL),
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
      onChanged: (String? value) {
        setState(() {
          _subtotal = double.parse(value!);
        });
      },
    );
  }

  Widget _buildTotal() {
    return TextFormField(
      decoration: const InputDecoration(labelText: Constants.TRIP_TOTAL_LABEL),
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
      onChanged: (String? value) {
        setState(() {
          _total = double.parse(value!);
        });
      },
    );
  }

  Widget _buildTripDesc() {
    return TextFormField(
      decoration: const InputDecoration(labelText: Constants.TRIP_DESC_LABEL),
      initialValue: _tripDesc,
      onChanged: (String? value) {
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
        title: const Text(Constants.CONFIRM_RECEIPT_LABEL),
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
                  _buildItems(context),
                  _buildSubtotal(),
                  _buildTotal(),
                  _buildTripDesc(),
                  const SizedBox(height: 20),
                  ElevatedButton(
                      onPressed: () => {
                            if (_confirmReceiptKey.currentState!.validate())
                              {handleSubmit()}
                            else
                              {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'An error occurred. Please check inputs.')),
                                )
                              }
                          },
                      child: const Text(Constants.CONFIRM_LABEL))
                ],
              )),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _items.add(Item('-', 'NEW ITEM', 0.00, false));
            _itemFields.add(_buildItem(context, _items.length - 1));
          });
        },
        child: const Text(Constants.NEW_ITEM_LABEL),
      ),
    );
  }

  Future<void> handleSubmit() async {
    final loading = LoadingOverlay.of(context);
    final navigator = Navigator.of(context);
    final scaffold = ScaffoldMessenger.of(context);
    List<Item> updatedItems = [];

    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();

    loading.show();

    for (Item item in _items) {
      if (item.itemDesc != 'USER REMOVED') updatedItems.add(item);
    }

    widget.tripData.updateGroceryTrip(
        _dateTime, _location, updatedItems, _subtotal, _total, _tripDesc);

    int status = await ref
        .watch(confirmReceiptControllerProvider.notifier)
        .submitTrip(widget.tripData);

    if (status == 200) {
      scaffold.showSnackBar(const SnackBar(
        content: Text('Receipt submitted successfully.'),
      ));

      loading.hide();

      await navigator
          .push(MaterialPageRoute(builder: (context) => const AppNavigation()));
    } else {
      loading.hide();
      scaffold.showSnackBar(const SnackBar(
        content: Text('An error occurred submitting the receipt.'),
      ));
    }
  }
}
