import 'dart:ui';

import 'package:difwa/screens/checkout_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  _SubscriptionScreenState createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  int selectedPackageIndex = -1;
  int selectedFrequencyIndex = -1;
  DateTime? startDate;
  DateTime? endDate;
  List<DateTime> selectedDates = [];

  late Map<String, dynamic> orderData;
  late double totalPrice;
  late double overAllTotalo;
  late int totalDays;
  late double bottlePrice = 200.0;

  @override
  void initState() {
    super.initState();
    orderData = Get.arguments ?? {};
    bottlePrice = orderData['price'];
    print("aaja");
    print(orderData);
    print(bottlePrice);

    totalPrice = bottlePrice * orderData['quantity'];
    print(totalPrice);

    // if (orderData['hasEmptyBottle']) {
    //   totalPrice += orderData['vacantPrice'] * orderData['quantity'];
    // }
    startDate = DateTime.now().add(const Duration(days: 1));
    totalDays = getTotalDays();
  }

  int getTotalDays() {
    return selectedDates.length;
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate
          ? (startDate ?? DateTime.now())
          : (endDate ?? DateTime.now()),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != (isStartDate ? startDate : endDate)) {
      setState(() {
        if (isStartDate) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
      _generateDates();
    }
  }

  Future<void> _selectCustomDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(
        start: startDate ?? DateTime.now(),
        end: endDate ?? DateTime.now().add(const Duration(days: 30)),
      ),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        startDate = picked.start;
        endDate = picked.end;
      });
      _generateDates();
    }
  }

  void _generateDates() {
    selectedDates.clear();
    DateTime currentDate = startDate ?? DateTime.now();
    DateTime endDate =
        this.endDate ?? DateTime.now().add(const Duration(days: 30));

    if (selectedFrequencyIndex == 0) {
      while (currentDate.isBefore(endDate)) {
        selectedDates.add(currentDate);
        currentDate = currentDate.add(const Duration(days: 1));
      }
    } else if (selectedFrequencyIndex == 1) {
      while (currentDate.isBefore(endDate)) {
        selectedDates.add(currentDate);
        currentDate = currentDate.add(const Duration(days: 2));
      }
    } else if (selectedFrequencyIndex == 2) {
      while (currentDate.isBefore(endDate)) {
        if (currentDate.weekday != DateTime.sunday) {
          selectedDates.add(currentDate);
        }
        currentDate = currentDate.add(const Duration(days: 1));
      }
    }
  }

  Future<void> _selectCustomDatesDialog(BuildContext context) async {
    List<DateTime> allDates = getDatesBasedOnFrequency();

    List<DateTime> tempSelectedDates = List.from(selectedDates);

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Dates'),
          content: SingleChildScrollView(
            child: Column(
              children: allDates.map((date) {
                bool isSelected = tempSelectedDates.contains(date);

                return CheckboxListTile(
                  title: Text(DateFormat('yyyy-MM-dd').format(date)),
                  value: isSelected,
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        tempSelectedDates.add(date);
                      } else {
                        tempSelectedDates.remove(date);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  selectedDates = tempSelectedDates;
                });
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );

    totalDays = getTotalDays();

    // Do not re-add the vacant bottle charge here
    totalPrice = bottlePrice * orderData['quantity'];
    if (orderData['hasEmptyBottle']) {
      totalPrice += orderData['vacantPrice'] * orderData['quantity'];
    }
  }

  List<DateTime> getDatesBasedOnFrequency() {
    List<DateTime> dates = [];
    DateTime currentDate = startDate ?? DateTime.now();
    DateTime endDate =
        this.endDate ?? DateTime.now().add(const Duration(days: 30));

    if (selectedFrequencyIndex == 0) {
      // Every day
      while (currentDate.isBefore(endDate)) {
        dates.add(currentDate);
        currentDate = currentDate.add(const Duration(days: 1));
      }
    } else if (selectedFrequencyIndex == 1) {
      // Alternate days
      while (currentDate.isBefore(endDate)) {
        dates.add(currentDate);
        currentDate = currentDate.add(const Duration(days: 2));
      }
    } else if (selectedFrequencyIndex == 2) {
      // Except Sundays
      while (currentDate.isBefore(endDate)) {
        if (currentDate.weekday != DateTime.sunday) {
          dates.add(currentDate);
        }
        currentDate = currentDate.add(const Duration(days: 1));
      }
    }
    return dates;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscribe'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                            Text(
                              '${orderData['bottle']['size']}L',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Price: ₹ $bottlePrice per bottle',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 8),
                            Text('One Bottle Price: ₹ $totalPrice'),
                            Text(
                                'Vacant Bottle Price: ₹ ${orderData['vacantPrice'] * orderData['quantity']}'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Package Duration:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text('1 Month'),
                    selected: selectedPackageIndex == 0,
                    onSelected: (bool selected) {
                      setState(() {
                        selectedPackageIndex = 0;
                        endDate = startDate?.add(const Duration(days: 30));
                      });
                      _generateDates();
                    },
                  ),
                  ChoiceChip(
                    label: const Text('3 Months'),
                    selected: selectedPackageIndex == 1,
                    onSelected: (bool selected) {
                      setState(() {
                        selectedPackageIndex = 1;
                        endDate = startDate?.add(const Duration(days: 90));
                      });
                      _generateDates();
                    },
                  ),
                  ChoiceChip(
                    label: const Text('6 Months'),
                    selected: selectedPackageIndex == 2,
                    onSelected: (bool selected) {
                      setState(() {
                        selectedPackageIndex = 2;
                        endDate = startDate?.add(const Duration(days: 180));
                      });
                      _generateDates();
                    },
                  ),
                  ChoiceChip(
                    label: const Text('1 Year'),
                    selected: selectedPackageIndex == 3,
                    onSelected: (bool selected) {
                      setState(() {
                        selectedPackageIndex = 3;
                        endDate = startDate?.add(const Duration(days: 365));
                      });
                      _generateDates();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _selectCustomDateRange(context);
                },
                child: const Text('Select Date Range'),
              ),
              const SizedBox(height: 16),
              const Text(
                'Frequency:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text('Every Day'),
                    selected: selectedFrequencyIndex == 0,
                    onSelected: (bool selected) {
                      setState(() {
                        selectedFrequencyIndex = 0;
                        _generateDates();
                      });
                    },
                  ),
                  ChoiceChip(
                    label: const Text('Alternate Days'),
                    selected: selectedFrequencyIndex == 1,
                    onSelected: (bool selected) {
                      setState(() {
                        selectedFrequencyIndex = 1;
                        _generateDates(); // Recalculate dates
                      });
                    },
                  ),
                  ChoiceChip(
                    label: const Text('Except Sundays'),
                    selected: selectedFrequencyIndex == 2,
                    onSelected: (bool selected) {
                      setState(() {
                        selectedFrequencyIndex = 2;
                        _generateDates();
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _selectCustomDatesDialog(context);
                },
                child: const Text('Select Custom Dates'),
              ),
              const SizedBox(height: 16),
              Text('Total Days: ${getTotalDays()} days'),
              Text('For One Day: ₹$totalPrice'),
              const SizedBox(height: 16),
              Text(
                'Total Price: ₹ ${totalPrice * getTotalDays() + orderData['vacantPrice'] * orderData['quantity']} ',
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Navigate to Checkout Screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CheckoutScreen(
                        orderData: orderData,
                        totalPrice: totalPrice,
                        totalDays: getTotalDays(),
                        selectedDates: selectedDates,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Go to Checkout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
