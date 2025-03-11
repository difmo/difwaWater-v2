import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:difwa/utils/theme_constant.dart';
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Your Orders',
          style: TextStyle(color: ThemeConstants.primaryColorNew),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: ThemeConstants.primaryColorNew,
          labelColor: ThemeConstants.primaryColorNew,
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

  const OrderListPage({Key? key, required this.status}) : super(key: key);

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
                      subtitle: DropdownButton<String>(
                        value: statusList.isNotEmpty ? statusList[0] : null,
                        onChanged: (newStatus) {
                          setState(() {
                            // Handle status change if needed
                          });
                        },
                        items: statusList.map((status) {
                          return DropdownMenuItem<String>(
                            value: status,
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(status),
                                  Text(
                                    'Updated At: ${statusHistory['ongoingTime']}',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  Text(
                                    'Updated At: ${statusHistory['cancelledTime']}',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  Text(
                                    'Updated At: ${statusHistory['confirmedTime']}',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  Text(
                                    'Updated At: ${statusHistory['pendingTime']}',
                                    style: const TextStyle(fontSize: 12, color: Colors.deepOrange),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
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
}
