import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_spending_tracker_app/common/constants.dart';
import 'package:flutter/material.dart';
import 'package:grocery_spending_tracker_app/common/error_alert.dart';
import 'package:grocery_spending_tracker_app/controller/profile_controller.dart';
import 'package:grocery_spending_tracker_app/pages/home.dart';

// ignore_for_file: prefer_const_constructors

class EditProfile extends ConsumerStatefulWidget {
  const EditProfile({super.key});

  @override
  EditProfileState createState() => EditProfileState();
}

class EditProfileState extends ConsumerState<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  bool? _enableBtn;
  String? _firstname;
  String? _lastname;

  @override
  Widget build(BuildContext context) {
    final initUser = ref.watch(profileControllerProvider.notifier).getUser();
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
            onChanged: () =>
                setState(() => _enableBtn = _formKey.currentState?.validate()),
            child: Column(
              children: [
                TextFormField(
                  onSaved: (newValue) => setState(() => _firstname = newValue),
                  initialValue: initUser.firstName,
                  decoration: InputDecoration(
                    labelText: Constants.FIRST_NAME_LABEL,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Invalid input';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  onSaved: (newValue) => setState(() => _lastname = newValue),
                  initialValue: initUser.lastName,
                  decoration: InputDecoration(
                    labelText: Constants.LAST_NAME_LABEL,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Invalid input';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                OutlinedButton(
                    onPressed: _enableBtn ?? false
                        ? () async {
                            _formKey.currentState!.save();
                            setState(() => _enableBtn = false);
                            final response = await ref
                                .watch(profileControllerProvider.notifier)
                                .updateUser(
                                  _firstname!,
                                  _lastname!,
                                );
                            if (response.statusCode == 200 && context.mounted) {
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
                    child: Text("Save"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
