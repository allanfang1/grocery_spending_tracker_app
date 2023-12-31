import 'dart:math';

import 'package:flutter/material.dart';

// ignore_for_file: prefer_const_constructors

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool? enableBtn;

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
                'Grocery Spending Tracker',
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
                    () => enableBtn = _formKey.currentState?.validate()),
                child: Column(
                  children: [
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
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
                        errorStyle: TextStyle(
                          color: Colors.transparent,
                          fontSize: 0,
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black54),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.deepPurple, width: 2.0),
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
                    OutlinedButton(
                      onPressed: enableBtn ?? false
                          ? () => {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Good Data')),
                                )
                              }
                          : null,
                      child: const Text('Login'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
