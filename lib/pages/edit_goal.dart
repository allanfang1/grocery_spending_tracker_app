import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_spending_tracker_app/common/constants.dart';
import 'package:grocery_spending_tracker_app/pages/register.dart';
import 'package:grocery_spending_tracker_app/controller/profile_controller.dart';
import 'package:grocery_spending_tracker_app/pages/home.dart';
import 'package:flutter/material.dart';

// ignore_for_file: prefer_const_constructors

class EditGoal extends StatefulWidget {
  const EditGoal({super.key});

  @override
  State<EditGoal> createState() => _EditGoal();
}

class _EditGoal extends State<EditGoal> {
  final _formKey = GlobalKey<FormState>();
  bool? _enableBtn;
  String? _firstname;
  String? _lastname;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Edit Profile"),
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  onSaved: (newValue) => setState(() => _firstname = newValue),
                  decoration:
                      InputDecoration(labelText: Constants.FIRST_NAME_LABEL),
                ),
                TextFormField(
                  onSaved: (newValue) => setState(() => _firstname = newValue),
                  decoration:
                      InputDecoration(labelText: Constants.LAST_NAME_LABEL),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
