import 'package:difwa/order_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Your Orders',
          style: TextStyle(color: Colors.blue), // Change to your primary color
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.blue, // Change to your primary color
          labelColor: Colors.blue, // Change to your primary color
          unselectedLabelColor: Colors.grey,
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

class OrderListPage extends StatefulWidget {
  final String status;

  const OrderListPage({super.key, required this.status});

  @override
  _OrderListPageState createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
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
          return Container(
            color: Colors.white,
            child: Center(
              child: Text(
                'No ${widget.status} orders found.',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          );
        }

        final orders = snapshot.data!.docs;

        final filteredOrders = orders.where((orderDoc) {
          final order = orderDoc.data() as Map<String, dynamic>;

          // Ensure selectedDates is a List<Map<String, dynamic>>.
          final selectedDates = order['selectedDates'] is List
              ? order['selectedDates'] as List<dynamic>
              : []; // Default to empty list if not a List

          if (selectedDates.isEmpty) {
            return false;
          }

          // Iterate over the selectedDates list, which should be a List<Map<String, dynamic>>.
          return selectedDates.any((selectedDate) {
            if (selectedDate is Map<String, dynamic>) {
              final statusHistory =
                  selectedDate['statusHistory'] as Map<String, dynamic>?;

              // Ensure statusHistory exists before accessing.
              if (statusHistory != null && statusHistory.isNotEmpty) {
                return statusHistory['status'] == widget.status;
              }
            }
            return false;
          });
        }).toList();

        if (filteredOrders.isEmpty) {
          return Container(
            color: Colors.white,
            child: Center(
              child: Text(
                'No ${widget.status} orders found.',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: filteredOrders.length,
          itemBuilder: (context, index) {
            final order = filteredOrders[index].data() as Map<String, dynamic>;
            final orderId = filteredOrders[index].id;
            final selectedDates = order['selectedDates'] is List
                ? order['selectedDates'] as List<dynamic>
                : []; // Default to empty list if not a List

            return Container(
              color: Colors.white,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ExpansionTile(
                title: Text('Order ID: $orderId'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Price: ₹ ${order['totalPrice']}'),
                    Text(
                      'Order Date: ${formatDateTime(DateTime.fromMillisecondsSinceEpoch(order['timestamp'].millisecondsSinceEpoch))}',
                    ),
                  ],
                ),
                children: selectedDates.map<Widget>((selectedDate) {
                  if (selectedDate is Map<String, dynamic>) {
                    final date = selectedDate['date'] ?? '';
                    final statusHistory =
                        selectedDate['statusHistory'] as Map<String, dynamic>?;

                    // Ensure statusHistory exists and has status.
                    if (statusHistory == null || statusHistory.isEmpty) {
                      return const ListTile(
                        title: Text('No Status History Available'),
                      );
                    }

                    List<String> statusList = [statusHistory['status'] ?? ''];

                    return ListTile(
                      title: Text(
                          'Date: ${formatDateTime(DateTime.parse(date).toLocal())}'),
                      subtitle: buildOrderStatusBar(statusHistory),
                    );
                  }
                  return const ListTile(
                    title: Text('Invalid selected date entry'),
                  );
                }).toList(),
              ),
            );
          },
        );
      },
    );
  }

  String formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}';
  }

  Widget buildOrderStatusBar(Map<String, dynamic> statusHistory) {
    // Define status stages
    final statusStages = ['pending', 'confirmed', 'cancelled', 'completed'];
    final currentStatus = statusHistory['status'] ?? 'pending';

    // Calculate progress
    final statusIndex = statusStages.indexOf(currentStatus);
    final progress = (statusIndex + 1);

    return Column(
      children: [
        SizedBox(
          // width: 200,
          height: 155,
          child: ExampleProgressTracker(currentIndex: progress,)),
        // LinearProgressIndicator(
        //   value: progress,
        //   backgroundColor: Colors.grey[300],
        //   color: getStatusColor(currentStatus),
        // ),
        // SizedBox(height: 8),
        // Text(
        //   'Status: $currentStatus',
        //   style: TextStyle(fontWeight: FontWeight.bold),
        // ),
      ],
    );
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.blue;
      case 'cancelled':
        return Colors.red;
      case 'completed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
