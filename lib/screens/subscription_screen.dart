import 'dart:ui';

import 'package:difwa/screens/checkout_screen.dart';
import 'package:difwa/utils/app__text_style.dart';
import 'package:difwa/utils/theme_constant.dart';
import 'package:difwa/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

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
    getDatesBasedOnFrequency();

    // Create a temporary list to manage selection state
    List<DateTime> tempSelectedDates = List.from(selectedDates);

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Dates'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  width: 500,
                  height: 400,
                  child: TableCalendar(
                    firstDay: DateTime.utc(2000, 1, 1),
                    lastDay: DateTime.utc(2100, 12, 31),
                    focusedDay: DateTime.now(),
                    selectedDayPredicate: (day) {
                      return tempSelectedDates
                          .any((selectedDate) => isSameDay(selectedDate, day));
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        if (tempSelectedDates.contains(selectedDay)) {
                          tempSelectedDates.remove(selectedDay);
                        } else {
                          tempSelectedDates.add(selectedDay);
                        }
                      });
                    },
                    calendarStyle: const CalendarStyle(
                      selectedDecoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      todayDecoration: BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                      defaultDecoration: BoxDecoration(
                        color: Colors.transparent,
                      ),
                      outsideDecoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                    daysOfWeekStyle: const DaysOfWeekStyle(
                      weekdayStyle: TextStyle(color: Colors.black),
                      weekendStyle: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
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
            TextButton(
              onPressed: () {
                setState(() {
                  tempSelectedDates.clear(); // Clear selection if needed
                });
              },
              child: const Text('Clear Selection'),
            ),
          ],
        );
      },
    );

    // Update totalDays and totalPrice after selection
    totalDays = getTotalDays();
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
      while (currentDate.isBefore(endDate)) {
        dates.add(currentDate);
        currentDate = currentDate.add(const Duration(days: 1));
      }
    } else if (selectedFrequencyIndex == 1) {
      while (currentDate.isBefore(endDate)) {
        dates.add(currentDate);
        currentDate = currentDate.add(const Duration(days: 2));
      }
    } else if (selectedFrequencyIndex == 2) {
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
      backgroundColor: ThemeConstants.whiteColor,
      appBar: AppBar(
        backgroundColor: ThemeConstants.whiteColor,
        title: const Text('Subscribe'),
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
                        child: Image.asset(
                          'assets/images/water.jpg',
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${orderData['bottle']['size']}L',
                              style: AppTextStyle.Text16600.copyWith(
                                  color: ThemeConstants.whiteColor),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Price: ₹ $bottlePrice per bottle',
                              style: AppTextStyle.Text12400.copyWith(
                                  color: ThemeConstants.whiteColor),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'One Bottle Price: ₹ $totalPrice',
                              style: AppTextStyle.Text12400.copyWith(
                                  color: ThemeConstants.whiteColor),
                            ),
                            Text(
                              'Vacant Bottle Price: ₹ ${orderData['vacantPrice'] * orderData['quantity']}',
                              style: AppTextStyle.Text12400.copyWith(
                                  color: ThemeConstants.whiteColor),
                            ),
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
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  buildChoiceChip(
                    label: "1 Month",
                    selected: (selectedPackageIndex == 0),
                    onSelected: (bool selected) {
                      setState(() {
                        selectedPackageIndex = 0;
                        endDate = startDate?.add(const Duration(days: 30));
                      });
                      _generateDates();
                    },
                  ),
                  buildChoiceChip(
                    label: "3 Month",
                    selected: (selectedPackageIndex == 1),
                    onSelected: (bool selected) {
                      setState(() {
                        selectedPackageIndex = 1;
                        endDate = startDate?.add(const Duration(days: 90));
                      });
                      _generateDates();
                    },
                  ),
                  buildChoiceChip(
                    label: "6 Month",
                    selected: (selectedPackageIndex == 2),
                    onSelected: (bool selected) {
                      setState(() {
                        selectedPackageIndex = 2;
                        endDate = startDate?.add(const Duration(days: 180));
                      });
                      _generateDates();
                    },
                  ),
                  buildChoiceChip(
                    label: "1 Year",
                    selected: (selectedPackageIndex == 3),
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
              CustomButton(
                width: 200,
                baseTextColor: ThemeConstants.whiteColor,
                text: "Select Date Range",
                onPressed: () {
                  _selectCustomDateRange(context);
                },
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
                    checkmarkColor: ThemeConstants.whiteColor,
                    selectedColor: ThemeConstants.primaryColorNew,
                    backgroundColor: ThemeConstants.whiteColor,
                    label: Text('Every Day',
                        style: TextStyle(
                            color: selectedFrequencyIndex == 0
                                ? Colors.white
                                : Colors.black)),
                    selected: selectedFrequencyIndex == 0,
                    onSelected: (bool selected) {
                      setState(() {
                        selectedFrequencyIndex = 0;
                        _generateDates();
                      });
                    },
                  ),
                  ChoiceChip(
                    checkmarkColor: ThemeConstants.whiteColor,
                    selectedColor: ThemeConstants.primaryColorNew,
                    backgroundColor: ThemeConstants.whiteColor,
                    label: Text('Alternate Days',
                        style: TextStyle(
                            color: selectedFrequencyIndex == 1
                                ? Colors.white
                                : Colors.black)),
                    selected: selectedFrequencyIndex == 1,
                    onSelected: (bool selected) {
                      setState(() {
                        selectedFrequencyIndex = 1;
                        _generateDates();
                      });
                    },
                  ),
                  ChoiceChip(
                    checkmarkColor: ThemeConstants.whiteColor,
                    selectedColor: ThemeConstants.primaryColorNew,
                    backgroundColor: ThemeConstants.whiteColor,
                    label: Text('Except Sundays',
                        style: TextStyle(
                            color: selectedFrequencyIndex == 2
                                ? Colors.white
                                : Colors.black)),
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
              CustomButton(
                width: 200,
                baseTextColor: ThemeConstants.whiteColor,
                text: "Select Custom Dates",
                onPressed: () {
                  _selectCustomDatesDialog(context);
                },
              ),
              const SizedBox(height: 16),
              Text('Total Days: ${getTotalDays()} days'),
              Text('For One Day: ₹$totalPrice'),
              const SizedBox(height: 16),
              Text(
                'Total Price: ₹ ${totalPrice * getTotalDays() + orderData['vacantPrice'] * orderData['quantity']} ',
                style: AppTextStyle.Text18700,
              ),
              const SizedBox(height: 16),
              CustomButton(
                width: 200,
                baseTextColor: ThemeConstants.whiteColor,
                text: "Go to Checkout",
                onPressed: () {
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildChoiceChip({
    required String label,
    required bool selected,
    required Function(bool) onSelected,
  }) {
    return ChoiceChip(
        checkmarkColor: ThemeConstants.whiteColor,
        selectedColor: ThemeConstants.primaryColorNew,
        backgroundColor: ThemeConstants.whiteColor,
        label: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black,
          ),
        ),
        selected: selected,
        onSelected: onSelected);
  }
}
