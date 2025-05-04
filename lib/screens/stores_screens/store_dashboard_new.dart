import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:difwa/controller/admin_controller/add_items_controller.dart';
import 'package:difwa/controller/admin_controller/order_controller.dart';
import 'package:difwa/controller/admin_controller/vendors_controller.dart';
import 'package:difwa/screens/store_widgets/blinking_status_indicator.dart';
import 'package:difwa/screens/stores_screens/payment_history_graph.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final FirebaseController _authController = Get.put(FirebaseController());
  final OrdersController _ordersController = Get.put(OrdersController());
  final VendorsController _vendorsController = Get.put(VendorsController());
  String merchantIdd = "";
  bool storeStatus = false;

  int todaytotalOrders = 0;
  int todaypendingOrders = 0;
  int todaycompletedOrders = 0;
  int todaypreparingOrders = 0;
  int todayshippedOrders = 0;
  int overallTotalOrders = 0;
  int overallPendingOrders = 0;
  int overallCompletedOrders = 0;
  double balance = 0;

  @override
  void initState() {
    super.initState();
    print("hello");

    _vendorsController.fetchMerchantId().then((merchantId) {
      if (merchantId != null) {
        merchantIdd = merchantId;
        _vendorsController.fetchStoreDataRealTime(merchantId);
      }
    });

    _vendorsController.fetchStoreData().then((vendor) {
      setState(() {
        print("status");
        storeStatus = vendor?.isActive ?? false;
        print(storeStatus);
        balance = vendor?.earnings ??
            0; // Assuming 'balance' is a field in VendorModal
      });
    });
    _ordersController.fetchTotalTodayOrders().then((ordersCounts) {
      setState(() {
        todaytotalOrders = ordersCounts['totalOrders']!; // today
        todaypendingOrders = ordersCounts['pendingOrders']!;
        todaycompletedOrders = ordersCounts['completedOrders']!;
        todaypreparingOrders = ordersCounts['preparingOrders']!;
        todayshippedOrders = ordersCounts['shippedOrders']!;
        overallTotalOrders = ordersCounts['overallTotalOrders']!;
        overallPendingOrders = ordersCounts['overallPendingOrders']!;
        overallCompletedOrders = ordersCounts['overallCompletedOrders']!;
      });
    });

    // Fetch the merchantId
    _authController.fetchMerchantId("").then((merchantId) {
      print(merchantId);
      setState(() {
        merchantIdd = merchantId!;
      });
    });
  }

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
                  Obx(() {
                    final isActive = _vendorsController.storeStatus.value;
                    final vendorName = _vendorsController.vendorName.value;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Welcome, $vendorName',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                        Row(
                          children: [
                            BlinkingStatusIndicator(
                                isActive: isActive), // or false

                            const SizedBox(width: 10),
                            const Icon(Icons.notifications_none),
                          ],
                        ),
                      ],
                    );
                  }),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("Overview",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        // Text("View All", style: TextStyle(color: Colors.blue)),
                      ],
                    ),

                    const SizedBox(height: 20),
                    // Stats Cards
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        StatCard(
                          title: 'All Total Orders',
                          value: overallTotalOrders.toString(),
                          color: Colors.green,
                        ),
                        StatCard(
                          title: 'Revenue',
                          value: '\₹$balance',
                          color: Colors.green,
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                    // Recent Orders
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("Today Status",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        // Text("View All", style: TextStyle(color: Colors.blue)),
                      ],
                    ),

                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        StatusCard(
                            label: 'Pending Orders',
                            value: todaypendingOrders.toString(),
                            color: Colors.orange),
                        StatusCard(
                            label: 'Shipped Orders',
                            value: todayshippedOrders.toString(),
                            color: Colors.blue),
                        StatusCard(
                            label: 'Completed Orders',
                            value: todaycompletedOrders.toString(),
                            color: Colors.green),
                      ],
                    ),

                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(color: Colors.black12, blurRadius: 4)
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Revenue Trend",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              Text("This Week",
                                  style: TextStyle(color: Colors.black54)),
                            ],
                          ),
                          SizedBox(height: 200, child: LineChartWidget()),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                    // Recent Orders
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("Recent Orders",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        // Text("View All", style: TextStyle(color: Colors.blue)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 600,
                      child: Expanded(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('difwa-orders')
                              .where('merchantId', isEqualTo: merchantIdd)
                              .orderBy('timestamp', descending: true)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }

                            if (snapshot.hasError) {
                              return const Center(
                                  child: Text('Error loading orders'));
                            }

                            final orders = snapshot.data?.docs ?? [];
                            if (orders.isEmpty) {
                              return const Center(
                                  child: Text('No orders available.'));
                            }

                            return ListView.builder(
                              itemCount: orders.length,
                              itemBuilder: (context, index) {
                                final order = orders[index].data()
                                    as Map<String, dynamic>;
                                print("test");
                                print(order[0]);
                                final orderId = orders[index].id;
                                final orderStatus =
                                    order['status'] ?? 'pending';
                                // final

                                return OrderTile(
                                  orderId: orderId,
                                  details: '₹ ${order['totalPrice']}',
                                  status: orderStatus,
                                  color: Colors.blue,
                                );
                              },
                            );
                          },
                        ),
                      ),
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

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
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
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
          Text(title, style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 4),
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
      width: 110,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        children: [
          Text(value,
              style: TextStyle(
                  color: color, fontWeight: FontWeight.bold, fontSize: 28)),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
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
        title:
            Text(orderId, style: const TextStyle(fontWeight: FontWeight.bold)),
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
