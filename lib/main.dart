import 'package:flutter/material.dart';
import 'quote.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Quote> quotes=[
    Quote(text: 'The greatest glory in living lies not in never falling, but in rising every time we fall.', author: 'Nelson Mandela'),
    Quote(text: 'The way to get started is to quit talking and begin doing', author: 'Walt Disney'),
    Quote(text: "Your time is limited, so don't waste it living someone else's life. Don't be trapped by dogma – which is living with the results of other people's thinking", author: 'Steve Jobs'),

  ];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    );
  }
}
