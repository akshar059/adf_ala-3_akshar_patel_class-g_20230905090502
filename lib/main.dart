import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'services/theme_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool isDark = await ThemeService.getTheme();
  runApp(ExpenseApp(isDark: isDark));
}

class ExpenseApp extends StatefulWidget {
  final bool isDark;
  const ExpenseApp({super.key, required this.isDark});

  @override
  State<ExpenseApp> createState() => _ExpenseAppState();
}

class _ExpenseAppState extends State<ExpenseApp> {
  late bool isDark;

  @override
  void initState() {
    super.initState();
    isDark = widget.isDark;
  }

  void toggleTheme() async {
    final newState = !isDark;
    setState(() => isDark = newState);
    await ThemeService.setTheme(newState);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Expense Tracker",
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFFF8F9FE), // Consistent light background
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        fontFamily: 'Roboto',
      ),
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      home: HomeScreen(toggleTheme: toggleTheme),
    );
  }
}
