import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:difwa/config/app_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'History',
          style: TextStyle(color: Colors.blue),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor:Colors.grey,
          tabs: const [
            Tab(icon: Icon(Icons.info), text: 'Pending'),
            Tab(icon: Icon(Icons.check_box), text: 'Completed'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          OrderListPage(status: 'pending'),
          OrderListPage(status: 'completed'),
        ],
      ),
    );
  }
}

class OrderListPage extends StatelessWidget {
  final String status;

  const OrderListPage({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      return const Center(child: Text('User not logged in.'));
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('difwa-orders')
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Error fetching orders'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              'No $status orders found.',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        final orders = snapshot.data!.docs;

        // Filter orders based on selectedDates and statusHistory containing the desired status (pending/completed)
        final filteredOrders = orders.where((orderDoc) {
          final order = orderDoc.data() as Map<String, dynamic>;
          final selectedDates = order['selectedDates'] as List<dynamic>?;

          // If no selectedDates are available, skip this order
          if (selectedDates == null || selectedDates.isEmpty) {
            return false;
          }

          // Check if any selectedDate has the required status
          return selectedDates.any((selectedDate) {
            final statusHistory =
                selectedDate['statusHistory'] as List<dynamic>?;

            // If no statusHistory, skip this selectedDate
            if (statusHistory == null || statusHistory.isEmpty) {
              return false;
            }

            // Look for a matching status in statusHistory
            return statusHistory.any((statusEntry) {
              return statusEntry['status'] == status;
            });
          });
        }).toList();

        if (filteredOrders.isEmpty) {
          return Center(
            child: Text(
              'No $status orders found.',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: filteredOrders.length,
          itemBuilder: (context, index) {
            final order = filteredOrders[index].data() as Map<String, dynamic>;
            final orderId = filteredOrders[index].id;
            final selectedDates = order['selectedDates'] as List<dynamic>;

            return Column(
              children: selectedDates.map<Widget>((selectedDate) {
                final date = selectedDate['date'];
                final statusHistory =
                    selectedDate['statusHistory'] as List<dynamic>;

                String statusText = 'Unknown'; // Default if no status found
                Color statusColor = Colors.grey;

                for (var statusEntry in statusHistory) {
                  if (statusEntry['status'] == 'pending') {
                    statusText = 'Pending';
                    statusColor = Colors.orange;
                    break; // Exit loop once we find 'pending' status
                  } else if (statusEntry['status'] == 'completed') {
                    statusText = 'Completed';
                    statusColor = Colors.green;
                  }
                }

                if (statusText.toLowerCase() != status) {
                  return SizedBox.shrink(); // Skip rendering this card
                }

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: Text('Order ID: $orderId'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Date: ${DateTime.parse(date).toLocal()}'),
                        Text('Total Price: ₹ ${order['totalPrice']}'),
                        Text(
                          'Order Date: ${DateTime.fromMillisecondsSinceEpoch(order['timestamp'].millisecondsSinceEpoch)}',
                        ),
                      ],
                    ),
                    trailing: Text(
                      statusText,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        );
      },
    );
  }
}
