import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_spending_tracker_app/common/constants.dart';
import 'package:grocery_spending_tracker_app/common/error_alert.dart';
import 'package:grocery_spending_tracker_app/common/loading_overlay.dart';
import 'package:grocery_spending_tracker_app/pages/user/login.dart';
import 'package:grocery_spending_tracker_app/controller/profile_controller.dart';
import 'package:flutter/material.dart';

// Register or create profile page for the app
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPage();
}

class _RegisterPage extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  bool? _enableBtn;
  String? _firstname;
  String? _lastname;
  String? _email;
  String? _password;

  @override
  Widget build(BuildContext context) {
    final InputDecoration _hiddenValidation = InputDecoration(
        filled: true,
        fillColor: Theme.of(context).colorScheme.onPrimary,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none),
        hintStyle:
            TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 0.0,
          horizontal: 10.0,
        ),
        errorStyle: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 0,
        ));

    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 300.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                Constants.NEW_ACCOUNT_TITLE,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 26),
              Form(
                key: _formKey,
                onChanged: () => setState(
                    () => _enableBtn = _formKey.currentState?.validate()),
                child: Column(
                  children: [
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onSaved: (newValue) =>
                          setState(() => _firstname = newValue),
                      decoration: _hiddenValidation.copyWith(
                          hintText: Constants.FIRST_NAME_LABEL),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return Constants.GENERIC_INVALID_INPUT;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onSaved: (newValue) =>
                          setState(() => _lastname = newValue),
                      decoration: _hiddenValidation.copyWith(
                          hintText: Constants.LAST_NAME_LABEL),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return Constants.GENERIC_INVALID_INPUT;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onSaved: (newValue) => setState(() => _email = newValue),
                      decoration: _hiddenValidation.copyWith(
                          hintText: Constants.EMAIL_LABEL),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return Constants.GENERIC_INVALID_INPUT;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onSaved: (newValue) =>
                          setState(() => _password = newValue),
                      obscureText: true,
                      decoration: _hiddenValidation.copyWith(
                          hintText: Constants.PASSWORD_LABEL),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return Constants.GENERIC_INVALID_INPUT;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    Consumer(
                      builder: (_, WidgetRef ref, __) {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              disabledBackgroundColor: Theme.of(context)
                                  .colorScheme
                                  .surfaceTint
                                  .withOpacity(0.5),
                              elevation: 0,
                              padding:
                                  const EdgeInsets.fromLTRB(22, 12, 22, 12)),
                          onPressed: _enableBtn ?? false
                              ? () async {
                                  _formKey.currentState!.save();
                                  setState(() => _enableBtn = false);
                                  final loading = LoadingOverlay.of(context);
                                  loading.show();
                                  final response = await ref
                                      .read(profileControllerProvider.notifier)
                                      .register(_firstname!, _lastname!,
                                          _email!, _password!);
                                  loading.hide();
                                  if (context.mounted) {
                                    if (response.statusCode == 200) {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const LoadingOverlay(
                                                  child: LoginPage()),
                                        ),
                                      );
                                    } else {
                                      showErrorAlertDialog(
                                          context, response.body);
                                    }
                                  }
                                  setState(() => _enableBtn = true);
                                }
                              : null,
                          child: Text(
                            Constants.CREATE_ACCOUNT_BUTTON_LABEL,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: 16),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            const LoadingOverlay(child: LoginPage()),
                      ),
                    );
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Colors.blue),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
