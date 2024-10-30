import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'transcript_screen.dart';

class GraphScreen extends StatelessWidget {
  final List<dynamic> data;

  GraphScreen({required this.data});

  List<FlSpot> getEstimatedEarnings() {
    return List.generate(data.length, (index) {
      final quarterData = data[index];
      final estimatedEarnings = quarterData['estimated_eps'];
      print("Estimated EPS for index $index: $estimatedEarnings"); 
      if (estimatedEarnings != null && estimatedEarnings is double) {
        return FlSpot(index.toDouble(), estimatedEarnings);
      } else {
        return FlSpot(index.toDouble(), 0.0);
      }
    });
  }

  List<FlSpot> getActualEarnings() {
    return List.generate(data.length, (index) {
      final quarterData = data[index];
      final actualEarnings = quarterData['actual_eps'];
      print("Actual EPS for index $index: $actualEarnings"); 
      if (actualEarnings != null && actualEarnings is double) {
        return FlSpot(index.toDouble(), actualEarnings);
      } else {
        return FlSpot(index.toDouble(), 0.0);
      }
    });
  }

  List<String> getXAxisLabels() {
    return data.map<String>((quarterData) {
      final priceDate = quarterData['pricedate'];
      if (priceDate != null) {
        final DateTime date = DateTime.parse(priceDate);
        final year = date.year;
        final month = date.month;
        final quarter = (month - 1) ~/ 3 + 1; 
        return 'Q$quarter $year';
      } else {
        return 'Unknown Date';
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final xLabels = getXAxisLabels();

    return Scaffold(
      appBar: AppBar(
        title: Text("Earnings Comparison"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Estimated vs. Actual Earnings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: getEstimatedEarnings(),
                      isCurved: true,
                      color: Colors.blue,
                      belowBarData: BarAreaData(show: false),
                    ),
                    LineChartBarData(
                      spots: getActualEarnings(),
                      isCurved: true,
                      color: Colors.green,
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final int index = value.toInt();
                          if (index >= 0 && index < xLabels.length) {
                            return Text(xLabels[index]);
                          }
                          return Text('');
                        },
                        interval: 1,
                        reservedSize: 28,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                    ),
                  ),
                  lineTouchData: LineTouchData(
                    touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {
                      if (!event.isInterestedForInteractions || touchResponse == null) return;
                      final tappedSpotIndex = touchResponse.lineBarSpots?.first.spotIndex;
                      if (tappedSpotIndex != null) {
                        final tappedData = data[tappedSpotIndex];
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TranscriptScreen(
                              quarterData: tappedData,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Tap on a data point to view the earnings transcript.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
