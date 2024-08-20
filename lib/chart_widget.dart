// lib/chart_widget.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'data_provider.dart';

class ChartWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsyncValue = ref.watch(dataProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Ethanol Production Capacity Chart')),
      body: dataAsyncValue.when(
        data: (data) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
  bottomTitles: AxisTitles(
    sideTitles: SideTitles(
      showTitles: true,
      reservedSize: 30,
      getTitlesWidget: (value, meta) {
        final index = value.toInt();
        if (index < 0 || index >= data.length) return Container();

        // Display every 2nd label to reduce clutter
        if (index % 2 != 0) return Container();

        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Transform.rotate(
            angle: -45 * 3.1415927 / 180, // Rotate labels by -45 degrees
            child: Text(
              data[index]['state_'],
              style: TextStyle(color: Colors.black, fontSize: 10),
            ),
          ),
        );
      },
    ),
  ),
  leftTitles: AxisTitles(
    sideTitles: SideTitles(
      showTitles: true,
      reservedSize: 28,
      getTitlesWidget: (value, meta) {
        return Text(
          value.toString(),
          style: TextStyle(color: Colors.black, fontSize: 10),
        );
      },
    ),
  ),
  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
),

                borderData: FlBorderData(
                  show: true,
                  border: Border.all(
                    color: const Color(0xff37434d),
                    width: 1,
                  ),
                ),
                minX: 0,
                maxX: data.length.toDouble() - 1,
                minY: 0,
                maxY: (data
                        .map((e) => (e['loan_amount_recommended_rs_in_cr_'] as num).toDouble())
                        .reduce((a, b) => a > b ? a : b) *
                    1.1)
                    .toDouble(),
                lineBarsData: [
                  LineChartBarData(
                    spots: data.asMap().entries.map((entry) {
                      final index = entry.key;
                      final value = (entry.value['loan_amount_recommended_rs_in_cr_'] as num).toDouble();
                      return FlSpot(index.toDouble(), value);
                    }).toList(),
                    isCurved: true,
                    color: Colors.blue,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
