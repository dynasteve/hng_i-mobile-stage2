import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/product_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const StorekeeperApp());
}

class StorekeeperApp extends StatelessWidget {
  const StorekeeperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Storekeeper App',
            themeMode: themeProvider.themeMode,
            theme: ThemeData(
              useMaterial3: true,
              colorSchemeSeed: Colors.blueAccent,
              brightness: Brightness.light,
              scaffoldBackgroundColor: const Color(0xFFF6F7FB),
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                elevation: 0,
              ),
              floatingActionButtonTheme: const FloatingActionButtonThemeData(
                backgroundColor: Colors.blueAccent,
              ),
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              colorSchemeSeed: Colors.blueAccent,
              brightness: Brightness.dark,
            ),
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}

/// Use this helper whenever you want a consistently styled card:
Card buildStyledCard({required Widget child, EdgeInsetsGeometry? margin}) {
  return Card(
    margin: margin ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: child,
  );
}
