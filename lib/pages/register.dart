import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  String? _email;
  String? _password;

  @override
  Widget build(BuildContext context) {
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
                      onSaved: (newValue) => setState(() => _email = newValue),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Email",
                        hintStyle:
                            TextStyle(color: Colors.black.withOpacity(0.4)),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 0.0,
                          horizontal: 10.0,
                        ),
                      ),
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
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Password",
                        hintStyle:
                            TextStyle(color: Colors.black.withOpacity(0.4)),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 0.0,
                          horizontal: 10.0,
                        ),
                        // errorStyle: TextStyle(
                        //   color: Colors.transparent,
                        //   fontSize: 0,
                        // ),
                        // errorBorder: OutlineInputBorder(
                        //   borderSide: BorderSide(color: Colors.black54),
                        // ),
                        // focusedErrorBorder: OutlineInputBorder(
                        //   borderSide:
                        //       BorderSide(color: Colors.deepPurple, width: 2.0),
                        // ),
                      ),
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
                                  final navigator = Navigator.of(context);
                                  _formKey.currentState!.save();
                                  setState(() => _enableBtn = false);
                                  final response = await ref
                                      .read(profileControllerProvider.notifier)
                                      .register(_email!, _password!);
                                  if (response == 200) {
                                    navigator.push(
                                      MaterialPageRoute(
                                        builder: (context) => const LoginPage(),
                                      ),
                                    );
                                  } else {
                                    print('Register failed ${response}');
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