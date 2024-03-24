import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:grocery_spending_tracker_app/common/constants.dart';
import 'package:grocery_spending_tracker_app/common/error_alert.dart';
import 'package:grocery_spending_tracker_app/common/loading_overlay.dart';
import 'package:grocery_spending_tracker_app/controller/goals_controller.dart';
import 'package:grocery_spending_tracker_app/service/analytics_service_controller.dart';

// ignore_for_file: prefer_const_constructors

class CreateGoal extends ConsumerStatefulWidget {
  const CreateGoal({super.key});

  @override
  CreateGoalState createState() => CreateGoalState();
}

class CreateGoalState extends ConsumerState<CreateGoal> {
  final _formKey = GlobalKey<FormState>();
  bool? _enableBtn = true;
  String? _name;
  String? _description;
  DateTime? _startDate;
  DateTime? _endDate;
  String? _budget;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text(
          Constants.CREATE_GOAL,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
          child: Form(
            key: _formKey,
            onChanged: () =>
                setState(() => _enableBtn = _formKey.currentState?.validate()),
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Name',
                  ),
                  onChanged: (value) {
                    setState(() {
                      _name = value;
                    });
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Description',
                  ),
                  onChanged: (value) {
                    setState(() {
                      _description = value;
                    });
                  },
                ),
                TextField(
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "Start Date:",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: _startDate == null
                        ? 'Select a date'
                        : _startDate.toString().split(' ')[0],
                    hintStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: _startDate == null
                            ? Theme.of(context).colorScheme.onSurfaceVariant
                            : Theme.of(context).colorScheme.onBackground),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: _startDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (picked != null) {
                      setState(() {
                        _startDate = picked;
                      });
                    }
                  },
                ),
                TextField(
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "End Date:",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: _endDate == null
                        ? 'Select a date'
                        : _endDate.toString().split(' ')[0],
                    hintStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: _startDate == null
                            ? Theme.of(context).colorScheme.onSurfaceVariant
                            : Theme.of(context).colorScheme.onBackground),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: _endDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (picked != null) {
                      setState(() {
                        _endDate = picked;
                      });
                    }
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: InputDecoration(
                    labelText: 'Budget',
                  ),
                  onChanged: (value) {
                    setState(() {
                      _budget = value;
                    });
                  },
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
                      padding: EdgeInsets.fromLTRB(22, 12, 22, 12)),
                  onPressed: (_startDate != null &&
                          _endDate != null &&
                          _startDate!.isBefore(_endDate!) &&
                          _budget != null &&
                          _name != null &&
                          _description != null &&
                          (_enableBtn ?? false))
                      ? () async {
                          FocusScopeNode currentFocus = FocusScope.of(context);
                          final loading = LoadingOverlay.of(context);
                          if (!currentFocus.hasPrimaryFocus) {
                            currentFocus.unfocus();
                          }
                          // _formKey.currentState!.save();
                          setState(() => _enableBtn = false);
                          loading.show();
                          final response = await ref
                              .watch(goalsControllerProvider.notifier)
                              .createGoal(
                                _name!,
                                _description!,
                                _startDate!,
                                _endDate!,
                                _budget!,
                              );
                          if (response.statusCode == 200 && context.mounted) {
                            ref
                                .watch(
                                    analyticsServiceControllerProvider.notifier)
                                .refreshGoals();
                            loading.hide();
                            Navigator.of(context).pop();
                          } else {
                            setState(() {
                              _enableBtn = true;
                            });
                            if (context.mounted) {
                              showErrorAlertDialog(context, response.body);
                            }
                          }
                        }
                      : null,
                  child: Text(
                    "Save",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
