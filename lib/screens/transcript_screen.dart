import 'package:flutter/material.dart';
import '../service/api_service.dart';

class TranscriptScreen extends StatelessWidget {
  final Map<String, dynamic> quarterData;

  TranscriptScreen({required this.quarterData});

  Future<String> fetchEarningsTranscript() async {
    final apiService = ApiService();
    final ticker = quarterData['ticker'];
    final year = DateTime.parse(quarterData['pricedate']).year;
    final month = DateTime.parse(quarterData['pricedate']).month;
    final quarter = ((month - 1) ~/ 3) + 1;

    try {
      final transcript = await apiService.fetchTranscript(
        ticker: ticker,
        year: year,
        quarter: quarter,
      );
      return transcript;
    } catch (e) {
      return 'Failed to load transcript';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        title: Text('${quarterData['ticker']} Earnings Transcript'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<String>(
          future: fetchEarningsTranscript(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error fetching transcript.'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No transcript available.'));
            } else {
              return ListView(
                children: [
                  Text(
                    '${quarterData['ticker']} Earnings Call',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Date: ${quarterData['pricedate']}',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Quarter: Q${((DateTime.parse(quarterData['pricedate']).month - 1) ~/ 3) + 1}',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                  const Divider(height: 30, thickness: 1.5),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Transcript:',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      snapshot.data!,
                      style: const TextStyle(
                          fontSize: 16, height: 1.5, color: Colors.black87),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
