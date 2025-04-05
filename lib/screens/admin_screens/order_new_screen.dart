import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const OrdersScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget buildTab(String label, int count, IconData? icon) {
    return Tab(
      child: Row(
        children: [
          if (icon != null) const SizedBox(width: 4),
          Text(label),
          const SizedBox(width: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              count.toString(),
              style: const TextStyle(fontSize: 12),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Orders', style: TextStyle(color: Colors.black)),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.black54,
          indicatorColor: Colors.blue,
          
          tabs: [
            buildTab("Pending", 12, Icons.access_time),
            buildTab("Completed", 45, Icons.check),
            buildTab("Cancelled", 3, Icons.close),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildOrderList(),
          const Center(child: Text("Completed Orders")),
          const Center(child: Text("Cancelled Orders")),
        ],
      ),
    );
  }

  Widget buildOrderList() {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      children: [
        buildOrderCard(
          orderId: "#WTR2025000014",
          date: "April 4, 2025 16:46",
          name: "James Wilson",
          phone: "+1 234-567-8900",
          price: "\$30.00",
        ),
        buildOrderCard(
          orderId: "#WTR2025000015",
          date: "April 4, 2025 16:46",
          name: "Emily Thompson",
          phone: "+1 345-678-9012",
          price: "\$900.00",
        ),
      ],
    );
  }

  Widget buildOrderCard({
    required String orderId,
    required String date,
    required String name,
    required String phone,
    required String price,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 4), // Bottom only shadow
            blurRadius: 6,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order ID + Price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Order $orderId",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD6E9FF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    price,
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              date,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
            const SizedBox(height: 12),
            // Person + Phone
            Row(
              children: [
                const Icon(Icons.person, size: 18, color: Colors.black54),
                const SizedBox(width: 6),
                Text(name),
                const SizedBox(width: 12),
                const Icon(Icons.phone, size: 18, color: Colors.black54),
                const SizedBox(width: 6),
                Text(phone),
              ],
            ),
            const Divider(height: 20),
            // Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.check),
                    label: const Text("Accept"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.close, color: Colors.black54),
                    label: const Text(
                      "Reject",
                      style: TextStyle(color: Colors.black54),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
