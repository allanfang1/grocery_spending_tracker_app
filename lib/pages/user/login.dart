import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_spending_tracker_app/common/constants.dart';
import 'package:grocery_spending_tracker_app/common/loading_overlay.dart';
import 'package:grocery_spending_tracker_app/pages/user/register.dart';
import 'package:grocery_spending_tracker_app/controller/profile_controller.dart';
import 'package:grocery_spending_tracker_app/pages/app_nav.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// Login page for the app
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  ConnectivityResult _connectivityResult = ConnectivityResult.none;
  String? _responseMsg;
  bool? _enableBtn;
  String? _email;
  String? _password;

  @override
  void initState() {
    super.initState();
    Connectivity().checkConnectivity().then((result) {
      setState(() {
        _connectivityResult = result;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Builds the login page UI based on connectivity status.
    return Scaffold(
      body: Center(
          child: Container(
              constraints: const BoxConstraints(maxWidth: 300.0),
              child: StreamBuilder(
                  stream: Connectivity().onConnectivityChanged,
                  builder: (context, AsyncSnapshot snapshot) {
                    if (_connectivityResult == ConnectivityResult.none ||
                        (snapshot.hasData &&
                            snapshot.data == ConnectivityResult.none)) {
                      return _noInternetPage();
                    } else {
                      return _loginPage();
                    }
                  }))),
    );
  }

  // Builds the UI for the login page.
  Widget _loginPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text(
          Constants.APP_NAME,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 26),
        Form(
          key: _formKey,
          onChanged: () =>
              setState(() => _enableBtn = _formKey.currentState?.validate()),
          child: Column(
            children: [
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onSaved: (newValue) => setState(() => _email = newValue),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.onPrimary,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none),
                  hintText: Constants.EMAIL_LABEL,
                  hintStyle: TextStyle(color: Colors.black.withOpacity(0.4)),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 0.0,
                    horizontal: 10.0,
                  ),
                ),
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
                onSaved: (newValue) => setState(() => _password = newValue),
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.onPrimary,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none),
                  hintText: Constants.PASSWORD_LABEL,
                  hintStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 0.0,
                    horizontal: 10.0,
                  ),
                  errorStyle: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 0,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return Constants.GENERIC_INVALID_INPUT;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 6),
              if (_responseMsg != null)
                Text(
                  _responseMsg!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              const SizedBox(height: 4),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  disabledBackgroundColor: Theme.of(context)
                      .colorScheme
                      .surfaceTint
                      .withOpacity(0.5),
                  elevation: 0,
                  padding: const EdgeInsets.fromLTRB(22, 12, 22, 12),
                ),
                onPressed: _enableBtn ?? false
                    ? () async {
                        FocusScope.of(context).unfocus();
                        final loading = LoadingOverlay.of(context);
                        _formKey.currentState!.save();
                        setState(() => _enableBtn = false);
                        loading.show();
                        final response = await ref
                            .watch(profileControllerProvider.notifier)
                            .login(_email!, _password!);
                        loading.hide();
                        if (response.statusCode == 200 && context.mounted) {
                          Navigator.of(context, rootNavigator: true)
                              .pushAndRemoveUntil(MaterialPageRoute(
                                  builder: (BuildContext context) {
                            return const AppNavigation();
                          }), (route) => false);
                        } else {
                          setState(() {
                            _enableBtn = true;
                            _responseMsg = response.body;
                          });
                        }
                      }
                    : null,
                child: Text(
                  Constants.LOGIN_BUTTON_LABEL,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 16),
                ),
              ),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          const LoadingOverlay(child: RegisterPage()),
                    ),
                  );
                },
                child: const Text(
                  'Register',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Builds the UI for the no internet page.
  Widget _noInternetPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(Icons.wifi_off, color: Colors.red),
        Container(
            margin: const EdgeInsets.only(top: 20, bottom: 10),
            child: const Text("No Internet Connection",
                style: TextStyle(fontSize: 22))),
        Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: const Text('Check your connection and refresh the page.')),
        ElevatedButton(
            onPressed: () async {
              ConnectivityResult result =
                  await Connectivity().checkConnectivity();
              setState(() {
                _connectivityResult = result;
              });
            },
            child: const Text('Refresh'))
      ],
    );
  }
}
