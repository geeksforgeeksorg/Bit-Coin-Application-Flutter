import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp()); // Start the app
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Hide the debug banner
      home: BitCoinTracker(), // Set the home screen to BitCoinTracker
    );
  }
}

class BitCoinTracker extends StatefulWidget {
  const BitCoinTracker({super.key});

  @override
  _BitCoinTrackerState createState() => _BitCoinTrackerState();
}

class _BitCoinTrackerState extends State<BitCoinTracker> {
  final String apiKey = 'YOUR_API_KEY'; // API key for coinlayer
  String selectedCurrency = 'USD'; // Default currency
  String bitcoinPrice = 'Fetching...'; // Initial bitcoin price

  final List<String> currencies = [
    'AUD', 'BRL', 'CAD', 'CNY', 'EUR', 'GBP', 'HKD', 'JPY', 'PLN', 'RUB', 'SEK', 'USD', 'ZAR'
  ]; // List of currencies

  @override
  void initState() {
    super.initState();
    fetchBitcoinPrice(selectedCurrency); // Fetch bitcoin price when the app starts
  }

  Future<void> fetchBitcoinPrice(String currency) async {
    final url = 'https://api.coinlayer.com/live?access_key=$apiKey&target=$currency&symbols=BTC';
    try {
      final response = await http.get(Uri.parse(url)); // Make HTTP GET request
      setState(() {
        if (response.statusCode == 200) {
          final data = json.decode(response.body); // Decode JSON response
          bitcoinPrice = data['rates']['BTC'].toString(); // Update bitcoin price
        } else {
          bitcoinPrice = 'Error fetching data'; // Handle error
        }
      });
    } catch (e) {
      setState(() {
        bitcoinPrice = 'Error fetching data'; // Handle exception
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bitcoin Tracker'), // App bar title
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/bitcoin_img.jpeg', height: 200, width: 200), // Bitcoin image
              SizedBox(height: 32),
              Text(
                '$bitcoinPrice',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange), // Display bitcoin price
              ),
              SizedBox(height: 32),
              Text(
                'Base Currency',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), // Base currency label
              ),
              SizedBox(height: 16),
              DropdownButton<String>(
                value: selectedCurrency,
                items: currencies.map((String currency) {
                  return DropdownMenuItem<String>(
                    value: currency,
                    child: Text(currency), // Currency options
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCurrency = newValue!; // Update selected currency
                    fetchBitcoinPrice(selectedCurrency); // Fetch new bitcoin price
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}