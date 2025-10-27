import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/product_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const HNGStage3App());
}

class HNGStage3App extends StatelessWidget {
  const HNGStage3App({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Storekeeper',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          scaffoldBackgroundColor: Colors.grey[50],
          appBarTheme: const AppBarTheme(
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.black87,
            centerTitle: true,
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          // NOTE: removed cardTheme assignment to avoid SDK type mismatch.
          // We'll style cards locally using the helper below.
        ),
        home: const HomeScreen(),
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
