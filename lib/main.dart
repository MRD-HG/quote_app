import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          child: Stack(children: [
            Image.asset("assets/background.jpg",
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit:BoxFit.cover,
            ),
            Container(
              margin: EdgeInsets.only(top:50),
              child: Column(
                children: [
                  Center(
                    child: Text("Quotes",

                      style: GoogleFonts.raleway(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,vertical: 5
                        ),
                        margin: EdgeInsets.only(left: 20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                          borderRadius: BorderRadius.circular(15)

                        ),
                        child: Text("Business",
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontWeight:FontWeight.bold ,
                            fontSize: 18,
                          ),

                        ),
                      )
                    ],
                  )
                ],
              ),
            )
      
      
      
          ],),
        ),
      
      ),
    );
  }
}
