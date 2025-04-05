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
        backgroundColor: ThemeConstants.softgrey,
        appBar: AppBar(
          title:  Text(
            'Hello, Pritam',
            style: AppTextStyle.Text20600.copyWith(color: Colors.black),
          ),
          backgroundColor: ThemeConstants.whiteColor,
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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Order Summary', style: AppTextStyle.Text18700),
                const SizedBox(height: 16),

                // Order Status Cards
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildOrderCard('Total      Orders', totalOrders, Colors.blue),
                    _buildOrderCard('Pending Orders', pendingOrders, Colors.orange),
                    _buildOrderCard('Completed Orders', completedOrders, Colors.green),
                  ],
                ),

                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildOrderCard('Preparing Orders', preparingOrders, const Color.fromARGB(255, 224, 85, 25)),
                    _buildOrderCard('Shipped Orders', shippedOrders, Colors.purple),
                    _buildOrderCard('Overall Orders', overallTotalOrders, Colors.teal),
                  ],
                ),

                const SizedBox(height: 24),
                const Text(
                  'Recent Orders',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),


                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    itemCount: 5, // Sample list count
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        elevation: 4,
                        child: ListTile(
                          title: Text('Order #${index + 1}'),
                          subtitle: Text('Order status: Pending'),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            // Add action when tapping on a particular order
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCard(String title, int count, Color color) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: color,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        width: (MediaQuery.of(context).size.width -57) / 3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: AppTextStyle.Text18500.copyWith(                color: ThemeConstants.whiteColor,              ), ),
            const SizedBox(height: 8),
            Text(
              '$count',
              style:AppTextStyle.Text28600.copyWith(
                color: ThemeConstants.whiteColor,
    )
            ),
          ],
        ),
      ),
    );
  }
}
