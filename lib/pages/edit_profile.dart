import 'package:grocery_spending_tracker_app/common/constants.dart';
import 'package:flutter/material.dart';

// ignore_for_file: prefer_const_constructors

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfile();
}

class _EditProfile extends State<EditProfile> {
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
