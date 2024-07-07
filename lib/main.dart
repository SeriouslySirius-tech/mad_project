import 'package:flutter/material.dart';
import 'package:mad_project/tab_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final theme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 139, 4, 206),
    brightness: Brightness.dark,
  ).copyWith(
    primary: Colors.black,
    primaryContainer: const Color.fromARGB(240, 96, 22, 165),
    onPrimaryContainer: const Color.fromARGB(255, 255, 255, 255),
    error: const Color.fromARGB(255, 202, 17, 57),
    onError: Colors.white,
  ),
  textTheme: GoogleFonts.robotoFlexTextTheme(),
);

void main() {
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      home: const TabNavigation(),
      debugShowCheckedModeBanner: false,
    );
  }
}
