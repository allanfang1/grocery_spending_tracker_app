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
                suffixIcon: Icon(Icons.calendar_today)),
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
      if (_items[index].taxed) return Theme.of(context).colorScheme.primary;
      return Colors.white;
    }

    return ListenableBuilder(
        listenable: _items[index],
        builder: (context, Widget? child) {
          return GestureDetector(
            child: Card(
              elevation: 0,
              margin: EdgeInsets.zero,
              child: Container(
                margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          width: 1,
                          color: Theme.of(context).colorScheme.outlineVariant)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _items[index].itemDesc,
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Item ID: ${_items[index].itemKey}, Price: ${_items[index].price}, Taxed: ${_items[index].taxed}',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant),
                        )
                      ],
                    ),
                    Icon(Icons.edit),
                  ],
                ),
              ),
            ),
            onTap: () async {
              await showDialog(
                  context: context,
                  builder: (context) {
                    return StatefulBuilder(builder: (context, setState) {
                      return Center(
                        child: GestureDetector(
                          behavior: HitTestBehavior.deferToChild,
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: SingleChildScrollView(
                            child: GestureDetector(
                              child: AlertDialog(
                                content: Form(
                                  key: _confirmItemKey,
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        decoration: const InputDecoration(
                                            labelText: Constants.ITEM_ID_LABEL),
                                        initialValue: _items[index].itemKey,
                                        keyboardType: TextInputType.number,
                                        onSaved: (String? value) {
                                          setState(() {
                                            _items[index].updateItem(
                                                value!, null, null, null, null);
                                          });
                                        },
                                      ),
                                      TextFormField(
                                        decoration: const InputDecoration(
                                            labelText:
                                                Constants.ITEM_NAME_LABEL),
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
                                                null, value!, null, null, null);
                                          });
                                        },
                                      ),
                                      CheckboxListTile(
                                        shape: Border(
                                          bottom: BorderSide(
                                              width: 1,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface),
                                        ),
                                        contentPadding: EdgeInsets.zero,
                                        title: Text(
                                          Constants.TAXED_LABEL,
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurfaceVariant),
                                        ),
                                        checkColor: Colors.white,
                                        fillColor:
                                            MaterialStateProperty.resolveWith(
                                                getColor),
                                        value: _items[index].taxed,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            _items[index].updateItem(
                                                null, null, null, value!, null);
                                          });
                                        },
                                      ),
                                      TextFormField(
                                        decoration: const InputDecoration(
                                            labelText:
                                                Constants.ITEM_PRICE_LABEL),
                                        initialValue:
                                            _items[index].price.toString(),
                                        keyboardType: const TextInputType
                                            .numberWithOptions(
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
                                            _items[index].updateItem(
                                                null,
                                                null,
                                                double.parse(value!),
                                                null,
                                                null);
                                          });
                                        },
                                      ),
                                      SizedBox(height: 12),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          disabledBackgroundColor:
                                              Theme.of(context)
                                                  .colorScheme
                                                  .surfaceTint
                                                  .withOpacity(0.5),
                                          elevation: 0,
                                          padding: EdgeInsets.fromLTRB(
                                              22, 12, 22, 12),
                                        ),
                                        onPressed: () {
                                          if (_confirmItemKey.currentState!
                                              .validate()) {
                                            _confirmItemKey.currentState!
                                                .save();
                                            Navigator.of(context).pop();
                                          }
                                        },
                                        child: Text(
                                          Constants.SAVE_LABEL,
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
                                              fontSize: 16),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    });
                  });
            },
          );
        });
  }

  Widget _buildItems(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 4),
          child: Text(
            'Swipe left or right to remove an item',
            style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
        ),
        GestureDetector(
          child: Card(
            elevation: 0,
            margin: EdgeInsets.zero,
            child: Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
              decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(
                        width: 1,
                        color: Theme.of(context).colorScheme.outlineVariant),
                    bottom: BorderSide(
                        width: 1,
                        color: Theme.of(context).colorScheme.outlineVariant)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add,
                    size: 22,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  Text(
                    "ADD ITEM",
                    style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                ],
              ),
            ),
          ),
          onTap: () {
            setState(() {
              _items.add(Item('-', 'NEW ITEM', 0.00, false));
              _itemFields.add(_buildItem(context, _items.length - 1));
            });
          },
        ),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _itemFields.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Dismissible(
              background: Container(
                color: Theme.of(context).colorScheme.error,
              ),
              key: UniqueKey(),
              onDismissed: (DismissDirection direction) {
                Widget deletedField = _itemFields[index];
                setState(() {
                  _items[index].updateItem(null, null, null, null, true);
                  _itemFields[index] = Container();
                });
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Deleted ${_items[index].itemDesc}'),
                    action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () {
                        setState(() {
                          _itemFields[index] = deletedField;
                          _items[index]
                              .updateItem(null, null, null, null, false);
                        });
                      },
                    )));
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
        } else if (!_validateTotal(false)) {
          return 'Sum of item prices should equal subtotal';
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
        } else if (!_validateTotal(true)) {
          return 'Sum of taxed item prices should equal total';
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
      scrollPadding: EdgeInsets.only(bottom: 200),
      decoration: const InputDecoration(labelText: Constants.TRIP_DESC_LABEL),
      initialValue: _tripDesc,
      onChanged: (String? value) {
        setState(() {
          _tripDesc = value!;
        });
      },
    );
  }

  bool _validateTotal(bool includeTax) {
    double localTotal = 0.00;

    for (Item item in _items) {
      if (!item.deleted) {
        if (!includeTax || !item.taxed) {
          localTotal += item.price;
        } else if (includeTax && item.taxed) {
          localTotal += double.parse((item.price * 1.13).toStringAsFixed(2));
        }
      }
    }

    if (includeTax) {
      return _total == double.parse(localTotal.toStringAsFixed(2));
    }
    return _subtotal == double.parse(localTotal.toStringAsFixed(2));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text(
          Constants.CONFIRM_RECEIPT_LABEL,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Form(
          key: _confirmReceiptKey,
          child: Column(
            children: [
              Container(
                color: Theme.of(context).colorScheme.surface,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Column(children: [
                        _buildDateTime(context),
                        _buildLocation(),
                      ]),
                    ),
                    _buildItems(context),
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Column(children: [
                        _buildSubtotal(),
                        _buildTotal(),
                        _buildTripDesc(),
                      ]),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    disabledBackgroundColor: Theme.of(context)
                        .colorScheme
                        .surfaceTint
                        .withOpacity(0.5),
                    elevation: 0,
                    padding: EdgeInsets.fromLTRB(22, 12, 22, 12),
                  ),
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
                  child: Text(Constants.CONFIRM_LABEL,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 16))),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> handleSubmit() async {
    final loading = LoadingOverlay.of(context);
    final navigator = Navigator.of(context, rootNavigator: true);
    final scaffold = ScaffoldMessenger.of(context);
    List<Item> updatedItems = [];

    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();

    loading.show();

    for (Item item in _items) {
      if (!item.deleted) updatedItems.add(item);
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

      await navigator.pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const AppNavigation()),
          (route) => false);
    } else {
      loading.hide();
      scaffold.showSnackBar(const SnackBar(
        content: Text('An error occurred submitting the receipt.'),
      ));
    }
  }
}
