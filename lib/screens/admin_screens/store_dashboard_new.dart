import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: DashboardScreen(),
  ));
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white,
    body: SafeArea(
      child: Column(
        children: [
          // Static Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
         decoration: const BoxDecoration(
  color: Colors.white,
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      offset: Offset(0, 4), // x: 0, y: 4 → bottom shadow
      blurRadius: 6,
      spreadRadius: 0,
    ),
  ],
),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Welcome, James',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.circle, size: 10, color: Colors.blue),
                              SizedBox(width: 5),
                              Text("Online", style: TextStyle(color: Colors.blue)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Icon(Icons.notifications_none),
                      ],
                    )
                  ],
                ),

                const SizedBox(height: 10),

                // Search Bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search),
                      const Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: TextField(
                            decoration: InputDecoration(
                                border: InputBorder.none, hintText: "Search orders..."),
                          ),
                        ),
                      ),
                      const Icon(Icons.filter_list),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Scrollable Dashboard Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),

                  // Stats Cards
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      StatCard(
                        title: 'Total Orders',
                        value: '2,453',
                        percent: '+12.5%',
                        color: Colors.green,
                      ),
                      StatCard(
                        title: 'Revenue',
                        value: '\$8,234',
                        percent: '+8.2%',
                        color: Colors.green,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Revenue Chart
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text("Revenue Trend",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            Text("This Week", style: TextStyle(color: Colors.black54)),
                          ],
                        ),
                        const SizedBox(height: 200, child: LineChartWidget()),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Order Status Cards
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      StatusCard(label: 'Pending', value: '24', color: Colors.orange),
                      StatusCard(label: 'Processing', value: '18', color: Colors.blue),
                      StatusCard(label: 'Completed', value: '156', color: Colors.green),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Recent Orders
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text("Recent Orders",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text("View All", style: TextStyle(color: Colors.blue)),
                    ],
                  ),
                  const SizedBox(height: 10),

                  const OrderTile(
                    orderId: '#ORD-2345',
                    details: '2 items • \$24.00',
                    status: 'Pending',
                    color: Colors.orange,
                  ),
                  const OrderTile(
                    orderId: '#ORD-2344',
                    details: '1 item • \$12.00',
                    status: 'Completed',
                    color: Colors.green,
                  ),
                  const OrderTile(
                    orderId: '#ORD-2343',
                    details: '3 items • \$36.00',
                    status: 'Processing',
                    color: Colors.blue,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

}

// ==================== COMPONENTS ========================

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String percent;
  final Color color;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.percent,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2 - 24,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
          Text(title, style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 4),
          Text(percent, style: TextStyle(color: color, fontSize: 12)),
        ],
      ),
    );
  }
}

class StatusCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const StatusCard({
    super.key,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        children: [
          Text(value,
              style: TextStyle(
                  color: color, fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }
}

class OrderTile extends StatelessWidget {
  final String orderId;
  final String details;
  final String status;
  final Color color;

  const OrderTile({
    super.key,
    required this.orderId,
    required this.details,
    required this.status,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0.5,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(orderId, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(details),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20)),
          child: Text(status,
              style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}

class LineChartWidget extends StatelessWidget {
  const LineChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return LineChart(LineChartData(
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(),
        topTitles: AxisTitles(),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, _) {
              const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(days[value.toInt()], style: const TextStyle(fontSize: 10)),
              );
            },
            interval: 1,
          ),
        ),
      ),
      gridData: FlGridData(show: false),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 1000),
            FlSpot(1, 1100),
            FlSpot(2, 1050),
            FlSpot(3, 1100),
            FlSpot(4, 1300),
            FlSpot(5, 1280),
            FlSpot(6, 1290),
          ],
          isCurved: true,
          color: Colors.blue,
          dotData: FlDotData(show: true),
          belowBarData: BarAreaData(show: true, color: Colors.blue.withOpacity(0.2)),
        )
      ],
    ));
  }
}
