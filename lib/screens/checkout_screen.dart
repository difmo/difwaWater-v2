import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:difwa/controller/admin_controller/add_items_controller.dart';
import 'package:difwa/screens/congratulations_page.dart';
import 'package:difwa/utils/app__text_style.dart';
import 'package:difwa/utils/theme_constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CheckoutScreen extends StatefulWidget {
  final Map<String, dynamic> orderData;
  final double totalPrice;
  final int totalDays;
  final List<DateTime> selectedDates;

  const CheckoutScreen({
    required this.orderData,
    required this.totalPrice,
    required this.totalDays,
    required this.selectedDates,
    Key? key,
  }) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  double walletBalance = 0.0;
  String currentUserId = '';
  String? merchantId;

  @override
  void initState() {
    super.initState();
    _fetchWalletBalance();
    _fetchMerchantId(); // Fetch merchantId when the screen initializes
  }

  void _fetchWalletBalance() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      currentUserId = currentUser.uid;

      if (currentUserId.isNotEmpty) {
        FirebaseFirestore.instance
            .collection('difwa-users')
            .doc(currentUserId)
            .get()
            .then((userDoc) {
          if (userDoc.exists) {
            setState(() {
              walletBalance = (userDoc['walletBalance'] is int)
                  ? (userDoc['walletBalance'] as int).toDouble()
                  : (userDoc['walletBalance'] ?? 0.0);
            });
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('User not logged in or invalid user ID.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No user logged in.')),
      );
    }
  }

  void _fetchMerchantId() async {
    try {
      FirebaseController firebaseController = FirebaseController();
      String? fetchedMerchantId =
          await firebaseController.fetchMerchantId(currentUserId);
      setState(() {
        merchantId = fetchedMerchantId;
      });
    } catch (e) {
      print('Failed to fetch merchantId: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch merchant ID')),
      );
    }
  }



// Function to generate the main order ID
String generateMainOrderId(int count) {
  String datetime = DateTime.now()
      .toUtc()
      .toString()
      .substring(0, 19)
      .replaceAll("-", "")
      .replaceAll(":", "")
      .replaceAll("T", "-");

  String mainOrderId = "difwabulkid-$datetime-$count"; // Custom format for main order ID
  return mainOrderId;
}

// Function to get the order count for today
Future<int> _getOrderCountForToday() async {
  DateTime todayStart = DateTime.now().subtract(Duration(
      hours: DateTime.now().hour,
      minutes: DateTime.now().minute,
      seconds: DateTime.now().second,
      microseconds: DateTime.now().microsecond));
  DateTime todayEnd = todayStart.add(Duration(days: 1));

  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('difwa-orders')
      .where('timestamp',
          isGreaterThanOrEqualTo: Timestamp.fromDate(todayStart))
      .where('timestamp', isLessThan: Timestamp.fromDate(todayEnd))
      .get();

  return snapshot.docs.length;
}

// Function to get the order count for a specific date
Future<int> _getOrderCountForDate(DateTime date) async {
  // Get the date in the format 'yyyyMMdd' to match the order id format
  String formattedDate = DateFormat('yyyyMMdd').format(date);

  // Query Firestore to count the number of orders for this date
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('difwa-orders')
      .where('selectedDates.date', arrayContains: formattedDate) // Filter by the specific date
      .get();

  // Return the order count, which will be the count of existing orders for that date
  return snapshot.docs.length;
}

// Function to generate daily order ID
Future<String> generateDailyOrderId(DateTime date) async {
  // Get the order count for the date
  int orderCount = await _getOrderCountForDate(date);

  // Increment the order count by 1 to get the new daily order ID
  String dailyOrderId = 'difwa-${DateFormat('yyyyMMdd').format(date)}-${orderCount + 1}';

  // Return the generated daily order ID
  return dailyOrderId;
}

// Function to process the payment
void _processPayment() async {
  double vacantBottlePrice =
      widget.orderData['vacantPrice'] * widget.orderData['quantity'];
  double totalAmount =
      widget.totalPrice * widget.totalDays + vacantBottlePrice;

  if (walletBalance >= totalAmount) {
    double newBalance = walletBalance - totalAmount;
    try {
      Timestamp currentTimestamp = Timestamp.now();
      await FirebaseFirestore.instance
          .collection('difwa-users')
          .doc(currentUserId)
          .update({'walletBalance': newBalance});

      int orderCount = await _getOrderCountForToday();
      String mainOrderId = generateMainOrderId(orderCount);

      // Mapping selected dates with history
      List<Future<Map<String, dynamic>>> selectedDatesWithHistory =
          widget.selectedDates.map((date) async {
        String dailyOrderId = await generateDailyOrderId(date);

        return {
          'date': date.toIso8601String(),
          'statusHistory': [
            {
              'status': 'pending',
              'dailyorderid': dailyOrderId,
              'time': currentTimestamp,
            }
          ],
        };
      }).toList();

      List<Map<String, dynamic>> selectedDatesWithHistoryList =
          await Future.wait(selectedDatesWithHistory);

      await FirebaseFirestore.instance.collection('difwa-orders').add({
        'orderId': mainOrderId, // Add main order ID
        'userId': currentUserId,
        'totalPrice': totalAmount,
        'totalDays': widget.totalDays,
        'selectedDates': selectedDatesWithHistoryList,
        'orderData': widget.orderData,
        'status': 'paid',
        'timestamp': FieldValue.serverTimestamp(),
        'merchantId': merchantId,
      });

      // Navigate to Congratulations page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CongratulationsPage()),
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error processing payment: $e')),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content:
              Text('Insufficient balance. Please add funds to your wallet.')),
    );
  }
}



  @override
  Widget build(BuildContext context) {
    double vacantBottlePrice =
        widget.orderData['vacantPrice'] * widget.orderData['quantity'];
    double totalAmount =
        widget.totalPrice * widget.totalDays + vacantBottlePrice;

    return Scaffold(
      backgroundColor: ThemeConstants.whiteColor,
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                color: ThemeConstants.primaryColorNew,
                shape: const RoundedRectangleBorder(
                  side: BorderSide(
                      width: 1, color: ThemeConstants.primaryColorNew),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      Image.asset(
                        'assets/images/water.jpg',
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${widget.orderData['bottle']['size']}L',
                                style: AppTextStyle.Text12400.copyWith(
                                    color: ThemeConstants.whiteColor)),
                            const SizedBox(height: 8),
                            Text(
                                'Price: ₹ ${widget.orderData['price']} per bottle',
                                style: AppTextStyle.Text12400.copyWith(
                                    color: ThemeConstants.whiteColor)),
                            const SizedBox(height: 8),
                            Text('One Bottle Price: ₹ ${widget.totalPrice}',
                                style: AppTextStyle.Text12400.copyWith(
                                    color: ThemeConstants.whiteColor)),
                            Text('Vacant Bottle Price: ₹ ${vacantBottlePrice}',
                                style: AppTextStyle.Text12400.copyWith(
                                    color: ThemeConstants.whiteColor)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    decoration: BoxDecoration(
                      color: ThemeConstants
                          .whiteColor, // Set the background color here
                      border: Border.all(
                        color: ThemeConstants
                            .secondaryLight, // Set the border color here
                        width: 1, // Set the border width here
                      ),
                      borderRadius: BorderRadius.circular(
                          10), // Set the border radius if needed
                    ),
                    child: TableCalendar(
                      firstDay: DateTime.utc(2000, 1, 1),
                      lastDay: DateTime.utc(2100, 12, 31),
                      focusedDay: DateTime.now(),
                      selectedDayPredicate: (day) {
                        return widget.selectedDates.any(
                            (selectedDate) => isSameDay(selectedDate, day));
                      },
                      calendarStyle: const CalendarStyle(
                        // Decoration for selected day
                        selectedDecoration: BoxDecoration(
                          color: ThemeConstants.primaryColorNew,
                          shape: BoxShape.circle,
                        ),
                        // Decoration for today's day
                        todayDecoration: BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.circle,
                        ),
                        // Default decoration for all other days
                        defaultDecoration: BoxDecoration(
                          color: Colors.transparent,
                        ),
                      ),
                    )),
              ),
              const SizedBox(height: 16),
              Text('Total Days: ${widget.totalDays} days'),
              const SizedBox(height: 16),
              Text(
                'Total Price: ₹ ${totalAmount}',
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
              const SizedBox(height: 16),
              const Text('Your Wallet Balance:'),
              StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('difwa-users')
                    .doc(currentUserId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (snapshot.hasData) {
                    var userDoc = snapshot.data!;
                    double balance = (userDoc['walletBalance'] is int)
                        ? (userDoc['walletBalance'] as int).toDouble()
                        : (userDoc['walletBalance'] ?? 0.0);

                    return Text(
                      '₹ ${balance.toStringAsFixed(2)}',
                      style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 24),
                    );
                  } else {
                    return const Text('No data');
                  }
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _processPayment,
                child: const Text('Pay using Wallet'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
