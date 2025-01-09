import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'quote_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final QuoteService _quoteService = QuoteService();
  List<String> _quotes = [];
  List<String> _categories = ['Business', 'Love', 'Mindset', 'Happiness'];
  String _selectedCategory = 'Business';
  int _page = 1;
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchQuotes();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !_isLoading) {
        fetchQuotes(); // Fetch more quotes when user scrolls to the bottom
      }
    });
  }

  // Fetch quotes for the selected category and current page
  void fetchQuotes() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<String> quotes = await _quoteService.fetchQuotesByCategory(_selectedCategory, _page);
      setState(() {
        _quotes.addAll(quotes);
        _page++;
      });
    } catch (e) {
      setState(() {
        _quotes = ["Failed to fetch quotes: $e"];
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Called when a category is selected
  void selectCategory(String category) {
    setState(() {
      _selectedCategory = category;
      _page = 1;
      _quotes.clear();
    });
    fetchQuotes();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            // Background image
            Image.asset(
              "assets/background.jpg",
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
            Container(
              margin: const EdgeInsets.only(top: 50),
              child: Column(
                children: [
                  // Header: Category Tabs
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _categories.map((category) {
                          final isSelected = _selectedCategory == category;
                          return GestureDetector(
                            onTap: () => selectCategory(category),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              margin: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.blue : Colors.white.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                category,
                                style: GoogleFonts.poppins(
                                  color: isSelected ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  // Quotes Grid View
                  Expanded(
                    child: _isLoading && _quotes.isEmpty
                        ? Center(child: CircularProgressIndicator())
                        : GridView.builder(
                      controller: _scrollController,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        childAspectRatio: 1.5,
                      ),
                      padding: const EdgeInsets.all(20),
                      itemCount: _quotes.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Center(
                              child: Text(
                                _quotes[index],
                                textAlign: TextAlign.center,
                                style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 14,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // Show loading spinner at the bottom when fetching more quotes
                  if (_isLoading && _quotes.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
