import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'quote_service.dart';

class Quotes extends StatefulWidget {
  const Quotes({super.key});

  @override
  State<Quotes> createState() => _QuotesState();
}

class _QuotesState extends State<Quotes> {
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
      if (_scrollController.position.atEdge && _scrollController.position.pixels != 0) {
        if (!_isLoading) {
          fetchQuotes(); // Load more quotes
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Quotes App', style: GoogleFonts.raleway(fontWeight: FontWeight.bold,color: Colors.white)),
        backgroundColor: Colors.black,
        leading: IconButton(
          color: Colors.white,
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Image.asset(
            "assets/background.jpg",
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          Column(
            children: [
              // Category Tabs
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Row(
                  children: _categories.map((category) {
                    final isSelected = _selectedCategory == category;
                    return GestureDetector(
                      onTap: () => selectCategory(category),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white30 : Colors.white,
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
              // Quotes GridView
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    setState(() {
                      _quotes.clear();
                      _page = 1;
                    });
                    fetchQuotes();
                  },
                  child: GridView.builder(
                    controller: _scrollController,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                        child: InkWell(
                          onTap: () {
                            // Navigate to detail page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => QuoteDetail(quote: _quotes[index]),
                              ),
                            );
                          },
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
                        ),
                      );
                    },
                  ),
                ),
              ),
              if (_isLoading) const CircularProgressIndicator(),
            ],
          ),
        ],
      ),
    );
  }
}

class QuoteDetail extends StatelessWidget {
  final String quote;
  const QuoteDetail({required this.quote, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [


          // Content
          SafeArea(
            child: Column(
              children: [
                // Back button
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(8),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                // Quote content
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Quote text
                        Expanded(
                          child: SingleChildScrollView(
                            child: Text(
                              '"$quote"',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lora(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Decorative separator
                        Divider(
                          color: Colors.black.withOpacity(0.6),
                          thickness: 1.5,
                          indent: 50,
                          endIndent: 50,
                        ),
                        const SizedBox(height: 10),
                        // Attribution or footer text
                        Text(
                          'Find inspiration in every word.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ],
      ),
    );
  }
}