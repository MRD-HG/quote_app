import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'quote_service.dart';
import 'quotes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset("assets/Convesation.jpg"),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Quotes()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              elevation: 1,
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 7),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "Get Started",
                style: GoogleFonts.raleway(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 100),
          Text(
            "“Find Yourself, Find Your Quote”",
            style: GoogleFonts.merriweather(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ],
      ),
    );
  }
}
