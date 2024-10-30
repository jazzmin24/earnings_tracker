import 'dart:developer';

import 'package:earnings_tracker/graph_screen.dart';
import 'package:flutter/material.dart';
import 'api_service.dart'; // Import the API service

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _tickerController = TextEditingController();
  String? _errorMessage;

  final ApiService _apiService = ApiService(); // Instance of ApiService

  // Function to fetch earnings data
  Future<void> fetchEarningsData(String ticker) async {
    try {
      final data = await _apiService.fetchEarningsData(ticker);
      // Navigate to Graph Screen with the data
      log("API Data for $ticker: $data");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GraphScreen(data: data),
        ),
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Please check your ticker symbol and try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Earnings Tracker'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _tickerController,
              decoration: InputDecoration(
                labelText: 'Enter Company Ticker',
                border: OutlineInputBorder(),
                errorText: _errorMessage,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final ticker = _tickerController.text.trim().toUpperCase();
                if (ticker.isNotEmpty) {
                  setState(() {
                    _errorMessage = null; // Clear any previous error
                  });
                  fetchEarningsData(ticker);
                } else {
                  setState(() {
                    _errorMessage = 'Please enter a valid ticker symbol';
                  });
                }
              },
              child: Text('Search Earnings Data'),
            ),
          ],
        ),
      ),
    );
  }
}
