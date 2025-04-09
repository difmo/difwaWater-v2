import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:difwa/controller/admin_controller/payment_history_controller.dart';
import 'package:difwa/models/stores_models/payment_data_modal.dart';
import 'package:intl/intl.dart';

class LineChartWidget extends StatefulWidget {
  const LineChartWidget({super.key});

  @override
  _LineChartWidgetState createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget> {
  List<PaymentData> paymentData = [];
  PaymentHistoryController paymentHistoryController = Get.put(PaymentHistoryController());

  @override
  void initState() {
    super.initState();
    paymentHistoryController.fetchProcessedPaymentHistory().then((data) {
      setState(() {
        paymentData = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return paymentData.isEmpty
        ? Center(child: CircularProgressIndicator())
        : LineChart(
            LineChartData(
              titlesData: FlTitlesData(
                // leftTitles: AxisTitles(
                //   sideTitles: SideTitles(showTitles: true, getTitlesWidget: (value, _) {
                //     return Text(
                //       '\$${value.toStringAsFixed(2)}',
                //       style: const TextStyle(fontSize: 10),
                //     );
                //   }),
                // ),
                rightTitles: AxisTitles(),
                topTitles: AxisTitles(),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, _) {
                      // Get the day of the week from the date
                      int index = value.toInt();
                      if (index >= 0 && index < paymentData.length) {
                        var date = DateTime.parse(paymentData[index].date);
                        var dayOfWeek = DateFormat('E').format(date); // Get day of the week
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(dayOfWeek, style: const TextStyle(fontSize: 10)),
                        );
                      } else {
                        return const SizedBox.shrink(); // Return empty widget if index is out of range
                      }
                    },
                    interval: 1,
                  ),
                ),
              ),
              gridData: FlGridData(show: false),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: paymentData
                      .asMap()
                      .map((index, data) => MapEntry(
                            index,
                            FlSpot(
                              index.toDouble(), // Use index as x value for spacing
                              data.amount,
                            ),
                          ))
                      .values
                      .toList(),
                  isCurved: true,
                  color: Colors.blue,
                  dotData: FlDotData(show: true),
                  belowBarData: BarAreaData(show: true, color: Colors.blue.withOpacity(0.2)),
                ),
              ],
            ),
          );
  }
}
