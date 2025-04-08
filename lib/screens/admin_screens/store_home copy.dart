import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:difwa/controller/admin_controller/add_items_controller.dart';
import 'package:difwa/controller/order_controller.dart';
import 'package:difwa/utils/app__text_style.dart';
import 'package:difwa/utils/theme_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoreHome extends StatefulWidget {
  const StoreHome({super.key});

  @override
  _StoreHomeState createState() => _StoreHomeState();
}

class _StoreHomeState extends State<StoreHome> {
  final FirebaseController _authController = Get.put(FirebaseController());
  final OrdersController _ordersController = Get.put(OrdersController());
  String merchantIdd = "";

  // Declare variables to hold the counts
  int totalOrders = 0;
  int pendingOrders = 0;
  int completedOrders = 0;
  int preparingOrders = 0;
  int shippedOrders = 0;
  int overallTotalOrders = 0;
  int overallPendingOrders = 0;
  int overallCompletedOrders = 0;

  @override
  void initState() {
    super.initState();
    print("hello");

    // Fetch data and update the state
    _ordersController.fetchTotalTodayOrders().then((ordersCounts) {
      setState(() {
        totalOrders = ordersCounts['totalOrders']!;
        pendingOrders = ordersCounts['pendingOrders']!;
        completedOrders = ordersCounts['completedOrders']!;
        preparingOrders = ordersCounts['preparingOrders']!;
        shippedOrders = ordersCounts['shippedOrders']!;
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: ThemeConstants.whiteColor,
        appBar: AppBar(
          title: const Text(
            'Hello, Pritam',
            style: TextStyle(color: ThemeConstants.whiteColor),
          ),
          backgroundColor: ThemeConstants.blackColor,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
              onPressed: () {
                // Implement logout functionality here
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Order Summary', style: AppTextStyle.Text18700),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _OrderCard(
                      title: 'Total Orders',
                      orderCount: totalOrders,
                      color: Colors.orange,
                    ),
                    _OrderCard(
                      title: 'Pending Orders',
                      orderCount: pendingOrders,
                      color: Colors.red,
                    ),
                    _OrderCard(
                      title: 'Completed Orders',
                      orderCount: completedOrders,
                      color: Colors.green,
                    ),
                    _OrderCard(
                      title: 'Preparing Orders',
                      orderCount: preparingOrders,
                      color: Colors.blue,
                    ),
                    _OrderCard(
                      title: 'Shipped Orders',
                      orderCount: shippedOrders,
                      color: Colors.purple,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Recent Orders',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('difwa-orders')
                      .where('merchantId', isEqualTo: merchantIdd)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return const Center(child: Text('Error loading orders'));
                    }

                    final orders = snapshot.data?.docs ?? [];
                    if (orders.isEmpty) {
                      return const Center(child: Text('No orders available.'));
                    }

                    return ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        final order =
                            orders[index].data() as Map<String, dynamic>;
                        final orderId = orders[index].id;
                        final orderStatus = order['status'] ?? 'pending';

                        return Card(
                          color: Colors.white,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          elevation: 4,
                          child: ListTile(
                            title: Text('Order ID: $orderId'),
                            subtitle: Text('Status: $orderStatus'),
                            trailing: Text(
                              '₹ ${order['totalPrice']}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final String title;
  final int orderCount;
  final Color color;

  const _OrderCard({
    required this.title,
    required this.orderCount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: ThemeConstants.blackColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyle.Text18700.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            '$orderCount',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
