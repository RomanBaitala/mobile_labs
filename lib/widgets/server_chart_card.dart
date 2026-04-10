import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:iot_flutter_lab/models/metric.dart';

class ServerChartCard extends StatelessWidget {
  final List<MetricModel> metrics;

  const ServerChartCard({required this.metrics, super.key});

  @override
  Widget build(BuildContext context) {
    if (metrics.isEmpty) {
      return const Card(child: Center(child: Text('Немає даних')));
    }

    final sortedMetrics = List<MetricModel>.from(metrics);
    sortedMetrics.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    final displayMetrics = sortedMetrics.length > 20 
        ? sortedMetrics.sublist(sortedMetrics.length - 20) 
        : sortedMetrics;

    final reversedMetrics = displayMetrics.toList();

    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Performance History', 
              style: TextStyle(fontWeight: FontWeight.bold)
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: const FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true, reservedSize: 30)
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: reversedMetrics.asMap().entries.map((e) {
                        return FlSpot(e.key.toDouble(), e.value.cpuUsage);
                      }).toList(),
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,
                      dotData: const FlDotData(show: false),
                    ),
                    LineChartBarData(
                      spots: reversedMetrics.asMap().entries.map((e) {
                        return FlSpot(e.key.toDouble(), e.value.cpuTemperature);
                      }).toList(),
                      isCurved: true,
                      color: Colors.red,
                      barWidth: 3,
                      dotData: const FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _legendItem('CPU Load', Colors.blue),
                const SizedBox(width: 20),
                _legendItem('Temperature', Colors.red),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _legendItem(String label, Color color) {
    return Row(
      children: [
        Container(width: 12, height: 12, color: color),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
