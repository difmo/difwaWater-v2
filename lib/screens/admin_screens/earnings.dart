import 'package:difwa/controller/earning_controller.dart';
import 'package:difwa/routes/app_routes.dart';
import 'package:difwa/utils/theme_constant.dart';
import 'package:difwa/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EarningsDashboard extends StatefulWidget {
  const EarningsDashboard({super.key});

  @override
  _EarningsDashboardState createState() => _EarningsDashboardState();
}

class _EarningsDashboardState extends State<EarningsDashboard> {
  final EarningController _earningController = Get.put(EarningController());

  Map<String, int> earnings = {
    "today": 0,
    "yesterday": 0,
    "weekly": 0,
    "monthly": 0,
    "total": 0,
  };

  List<Map<String, dynamic>> transactions = [
    {"time": "2025-03-29 12:30 PM", "amount": 500},
    {"time": "2025-03-28 03:15 PM", "amount": 1200},
    {"time": "2025-03-27 09:45 AM", "amount": 850},
  ];

  DateTimeRange? selectedDateRange;
  int rangeEarnings = 0;

  @override
  void initState() {
    super.initState();
    _fetchEarnings();
  }

  void _fetchEarnings() async {
    var fetchedEarnings = await _earningController.fetchEarnings();
    setState(() {
      earnings = fetchedEarnings;
    });
  }

  void _fetchEarningsByRange() async {
    if (selectedDateRange != null) {
      int fetchedRangeEarnings =
          await _earningController.fetchEarningsByDateRange(
        selectedDateRange!.start,
        selectedDateRange!.end,
      );
      setState(() {
        rangeEarnings = fetchedRangeEarnings;
      });
    }
  }

  Future<void> _selectDateRange(BuildContext context) async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2024, 1, 1),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        selectedDateRange = picked;
      });
      _fetchEarningsByRange();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 170, 217, 255),
        title: Text(
          "Earnings Dashboard",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 10,
                    spreadRadius: 1,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Total Balance",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "₹${earnings["total"] ?? 0}",
                    style: TextStyle(color: Colors.black, fontSize: 66),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Container(
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                      onPressed: () {
                        Get.toNamed(AppRoutes.requestforwithdraw,
                            arguments: earnings["total"]);
                      },
                      child: const Text(
                        "Withdraw",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildEarningsCard("Today", earnings["today"] ?? 0),
                  _buildEarningsCard("Yesterday", earnings["yesterday"] ?? 0),
                  _buildEarningsCard("This Month", earnings["monthly"] ?? 0),
                  _buildEarningsCard("Last Week", earnings["weekly"] ?? 0),
                ],
              ),
            ),
            SizedBox(height: 16),
            Text("Select Date Range",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Row(
              children: [
                Expanded(
                  child: selectedDateRange == null
                      ? Text("No date range selected",
                          style: TextStyle(color: Colors.grey))
                      : Text(
                          "${DateFormat.yMMMd().format(selectedDateRange!.start)} - ${DateFormat.yMMMd().format(selectedDateRange!.end)}",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
                IconButton(
                  icon: Icon(Icons.date_range),
                  onPressed: () => _selectDateRange(context),
                ),
              ],
            ),
            if (selectedDateRange != null)
              _buildEarningsCard("Custom Range", rangeEarnings),
            SizedBox(height: 16),
            Text("Transactions",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(child: _buildEarningsList()),
            SizedBox(height: 16),
            CustomButton(text: "Refresh", onPressed: _fetchEarnings)
          ],
        ),
      ),
    );
  }

  Widget _buildEarningsCard(String title, int amount) {
    return Card(
      color: ThemeConstants.whiteColor,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: Colors.grey)),
            SizedBox(height: 4),
            Text("₹$amount",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildEarningsList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        var transaction = transactions[index];
        return Card(
          color: ThemeConstants.whiteColor,
          child: ListTile(
            title: Text(transaction['time'],
                style: TextStyle(fontSize: 14, color: Colors.grey)),
            trailing: Text("₹${transaction['amount']}",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        );
      },
    );
  }
}
