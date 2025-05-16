import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Predicción del Precio del Cacao',
      theme: ThemeData(
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: const Color(0xFF6F4E37), // Café oscuro
          onPrimary: Colors.white,
          secondary: const Color(0xFFD9A066), // Dorado suave
          onSecondary: Colors.white,
          error: Colors.red,
          onError: Colors.white,
          surface: const Color(0xFFF5F3EE), // Usar surface en vez de background
          onSurface: const Color(0xFF6F4E37), // Usar onSurface en vez de onBackground
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F3EE),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFF6F4E37),
          elevation: 0,
          titleTextStyle: GoogleFonts.montserrat(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        textTheme: GoogleFonts.montserratTextTheme().copyWith(
          bodyLarge: GoogleFonts.montserrat(fontSize: 18, color: const Color(0xFF6F4E37)),
          bodyMedium: GoogleFonts.montserrat(fontSize: 16, color: const Color(0xFF6F4E37)),
          titleLarge: GoogleFonts.montserrat(fontSize: 24, fontWeight: FontWeight.bold, color: const Color(0xFF6F4E37)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD9A066),
            foregroundColor: Colors.white,
            textStyle: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 18),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            elevation: 4,
            shadowColor: const Color(0xFFD9A066).withAlpha((0.3 * 255).toInt()),
          ),
        ),
        cardTheme: CardTheme(
          color: Colors.white,
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          filled: true,
          fillColor: const Color(0xFFEDEDED),
          labelStyle: GoogleFonts.montserrat(color: const Color(0xFF6F4E37)),
        ),
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
