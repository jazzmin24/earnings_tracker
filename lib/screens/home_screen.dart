import 'dart:developer';

import 'package:earnings_tracker/screens/graph_screen.dart';
import 'package:flutter/material.dart';
import '../service/api_service.dart'; 

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _tickerController = TextEditingController();
  String? _errorMessage;

  final ApiService _apiService = ApiService(); 

  Future<void> fetchEarningsData(String ticker) async {
    try {
      final data = await _apiService.fetchEarningsData(ticker);
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
              cursorColor: Colors.blue,
              controller: _tickerController,
              decoration: InputDecoration(
                labelText: 'Enter Company Ticker',
                labelStyle: TextStyle(
                  color: Colors.grey, 
                ),
                filled: true,
                fillColor: Colors.white, 
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0), 
                  borderSide: BorderSide(
                      color: Colors.grey, width: 2), 
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      8.0), 
                  borderSide: BorderSide(
                      color: Colors.blue.shade400,
                      width: 2), 
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                      color: Colors.red.shade300,
                      width: 2), 
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                      color: Colors.red.shade500,
                      width: 2), 
                ),
                errorText: _errorMessage,
                contentPadding: EdgeInsets.symmetric(
                    vertical: 16, horizontal: 12), 
                hintText: 'e.g., AAPL, MSFT',
                hintStyle: TextStyle(
                  color: Colors.grey,
                ),
              ),
              style: TextStyle(
                  fontSize: 18, color: Colors.black87), 
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(
                    vertical: 12, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0), 
                ),
              ),
              onPressed: () {
                final ticker = _tickerController.text.trim().toUpperCase();
                if (ticker.isNotEmpty) {
                  setState(() {
                    _errorMessage = null; 
                  });
                  fetchEarningsData(ticker);
                } else {
                  setState(() {
                    _errorMessage = 'Please enter a valid ticker symbol';
                  });
                }
              },
              child: const Text(
                'Search Earnings Data',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
