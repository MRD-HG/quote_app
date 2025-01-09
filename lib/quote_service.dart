import 'dart:convert';
import 'package:http/http.dart' as http;

class QuoteService {
  final String apiKey = "4d890827125d4e2794d184d8a2614455"; // Your API key

  Future<List<String>> fetchQuotesByCategory(String category, int page) async {
    final url = "https://favqs.com/api/quotes/?filter=${category.toLowerCase()}&page=$page";

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $apiKey", // Use Bearer token if needed
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['quotes']; // Ensure 'quotes' key exists
        return data.map((quote) => quote["body"] as String).toList(); // Extract the quote text
      } else {
        throw Exception("Failed to fetch quotes. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      print('Error: $e'); // Print the error message to help with debugging
      throw Exception("Error occurred while fetching quotes: $e");
    }
  }
}
