import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:difwa/utils/theme_constant.dart';
import 'package:difwa/widgets/logout_popup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StoreHome extends StatelessWidget {
  const StoreHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Admin Panel',
          style: TextStyle(color: ThemeConstants.whiteColor),
        ),
        backgroundColor: ThemeConstants.primaryColorNew,
        actions: [
          // Logout Button in AppBar
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () {
              LogoutDialog.showLogoutDialog(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order Summary',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 16),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _OrderCard(
                  title: 'Pending Orders',
                  status: 'pending',
                  color: Colors.orange,
                ),
                _OrderCard(
                  title: 'Completed Orders',
                  status: 'completed',
                  color: Colors.green,
                ),
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
            const SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('difwa-orders')
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
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        elevation: 4,
                        child: ListTile(
                          title: Text('Order ID: $orderId'),
                          subtitle: Text('Status: $orderStatus'),
                          trailing: Text(
                            '₹ ${order['totalPrice']}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
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
    );
  }
}

class _OrderCard extends StatelessWidget {
  final String title;
  final String status;
  final Color color;

  const _OrderCard({
    required this.title,
    required this.status,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: _getOrderCount(status),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildCardContent('Loading...', 0);
        }

        if (snapshot.hasError) {
          return _buildCardContent('Error', 0);
        }

        final orderCount = snapshot.data ?? 0;

        return _buildCardContent(title, orderCount);
      },
    );
  }

  Widget _buildCardContent(String title, int orderCount) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
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

  Future<int> _getOrderCount(String status) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('difwa-orders')
        .where('status', isEqualTo: status)
        .get();

    return querySnapshot.docs.length;
  }
}
