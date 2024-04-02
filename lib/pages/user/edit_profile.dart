import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_spending_tracker_app/common/constants.dart';
import 'package:flutter/material.dart';
import 'package:grocery_spending_tracker_app/common/error_alert.dart';
import 'package:grocery_spending_tracker_app/common/loading_overlay.dart';
import 'package:grocery_spending_tracker_app/controller/profile_controller.dart';
import 'package:grocery_spending_tracker_app/controller/recommendations_controller.dart';
import 'package:grocery_spending_tracker_app/pages/user/login.dart';

// This class represents the widget for user profile tab.
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

  // Build method responsible for constructing the UI based on the provided context.
  @override
  Widget build(BuildContext context) {
    final initUser = ref.watch(profileControllerProvider.notifier).getUser();
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          title: Text(
            initUser.email ?? "",
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          actions: [
            IconButton(
                onPressed: _enableBtn ?? false
                    ? () async {
                        final loading = LoadingOverlay.of(context);
                        final scaffold = ScaffoldMessenger.of(context);
                        _formKey.currentState!.save();
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }
                        loading.show();
                        setState(() => _enableBtn = false);
                        final response = await ref
                            .watch(profileControllerProvider.notifier)
                            .updateUser(
                              _firstname!,
                              _lastname!,
                            );
                        loading.hide();
                        if (response.statusCode == 200 && context.mounted) {
                          setState(() {
                            _enableBtn = true;
                          });
                          scaffold.showSnackBar(const SnackBar(
                              content: Text('Profile saved successfully')));
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
                icon: const Icon(Icons.save))
          ]),
      body: Center(
        child: Container(
          margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
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
                    errorStyle: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 0,
                    ),
                    focusedErrorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2),
                    ),
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
                    labelText: Constants.FIRST_NAME_LABEL,
                    errorStyle: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 0,
                    ),
                    focusedErrorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Invalid input';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      disabledBackgroundColor: Theme.of(context)
                          .colorScheme
                          .surfaceTint
                          .withOpacity(0.5),
                      elevation: 0,
                      padding: const EdgeInsets.fromLTRB(22, 12, 22, 12)),
                  onPressed: () {
                    ref.watch(profileControllerProvider.notifier).logout();
                    ref
                        .watch(recommendationsControllerProvider.notifier)
                        .logout();
                    Navigator.of(context, rootNavigator: true)
                        .pushAndRemoveUntil(
                            MaterialPageRoute(builder: (BuildContext context) {
                      return const LoadingOverlay(child: LoginPage());
                    }), (route) => false);
                  },
                  label: Text(
                    Constants.LOGOUT_LABEL,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 16),
                  ),
                  icon: Icon(Icons.logout,
                      color: Theme.of(context).colorScheme.onPrimary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
