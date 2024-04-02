import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_spending_tracker_app/common/constants.dart';
import 'package:grocery_spending_tracker_app/common/loading_overlay.dart';
import 'package:grocery_spending_tracker_app/pages/user/login.dart';

// Entry point of the application.
Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

// Root widget of the application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Constants.APP_NAME, //Theme.of(context).colorScheme.
      theme: ThemeData(
        dividerColor: Colors.transparent,
        appBarTheme: AppBarTheme(foregroundColor: Color(0xFF333333)),
        colorScheme: const ColorScheme(
          primary: Color(0xFF38A3A5), //used verdigris: anything accented
          secondary: Color(0xFFe2f4e9), //used honeydew:
          surface: Color(0xFFFdfdfd), //used: card background
          onSurfaceVariant:
              Color(0xFF9d9d9d), //used: navbarinactive, text on background
          outlineVariant: Color(0xFFe6e6e6), //used: card bottom border
          background: Color(0xFFF5f5f5), //used: background
          error: Colors.red, //used: error
          onPrimary: Color(0xFFFFFFFF), //used: top navbar border, on buttons
          onSecondary: Color(0xFF000000),
          onSurface: Color(0xFF333333), //used: card content
          onBackground: Color(0xFF333333), // used: textfield border
          onError: Color(0xFFFFFFFF),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const LoadingOverlay(child: LoginPage()),
    );
  }
}
