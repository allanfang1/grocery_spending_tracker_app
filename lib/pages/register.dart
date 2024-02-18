import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_spending_tracker_app/common/error_alert.dart';
import 'package:grocery_spending_tracker_app/pages/login.dart';
import 'package:grocery_spending_tracker_app/controller/profile_controller.dart';
import 'package:flutter/material.dart';

// ignore_for_file: prefer_const_constructors

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
      border: OutlineInputBorder(),
      hintStyle: TextStyle(color: Colors.black.withOpacity(0.4)),
      contentPadding: EdgeInsets.symmetric(
        vertical: 0.0,
        horizontal: 10.0,
      ),
      errorStyle: TextStyle(
        color: Colors.transparent,
        fontSize: 0,
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black54),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.deepPurple, width: 2.0),
      ),
    );

    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 300.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'New Account',
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
                      decoration:
                          _hiddenValidation.copyWith(hintText: "First Name"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Invalid input';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onSaved: (newValue) =>
                          setState(() => _lastname = newValue),
                      decoration:
                          _hiddenValidation.copyWith(hintText: "Last Name"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Invalid input';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onSaved: (newValue) => setState(() => _email = newValue),
                      decoration: _hiddenValidation.copyWith(hintText: "Email"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Invalid input';
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
                      decoration:
                          _hiddenValidation.copyWith(hintText: "Password"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Invalid input';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    Consumer(
                      builder: (_, WidgetRef ref, __) {
                        return OutlinedButton(
                          onPressed: _enableBtn ?? false
                              ? () async {
                                  _formKey.currentState!.save();
                                  setState(() => _enableBtn = false);
                                  final response = await ref
                                      .read(profileControllerProvider.notifier)
                                      .register(_firstname!, _lastname!,
                                          _email!, _password!);
                                  if (context.mounted) {
                                    if (response.statusCode == 200) {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginPage(),
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
                          child: const Text('Create Account'),
                        );
                      },
                    ),
                  ],
                ),
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
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
