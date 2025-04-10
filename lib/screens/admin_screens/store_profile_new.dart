import 'package:difwa/controller/admin_controller/order_controller.dart';
import 'package:difwa/controller/admin_controller/vendors_controller.dart';
import 'package:difwa/controller/auth_controller.dart';
import 'package:difwa/models/stores_models/store_new_modal.dart';
import 'package:difwa/models/user_models/user_details_model.dart';
import 'package:difwa/screens/admin_screens/earnings.dart';
import 'package:difwa/utils/theme_constant.dart';
import 'package:difwa/widgets/custom_button.dart';
import 'package:difwa/widgets/logout_popup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SupplierProfileScreen extends StatefulWidget {
  const SupplierProfileScreen({super.key});

  @override
  _SupplierProfileScreenState createState() => _SupplierProfileScreenState();
}

class _SupplierProfileScreenState extends State<SupplierProfileScreen> {
  final AuthController _userData = Get.put(AuthController());
  final VendorsController controller = Get.put(VendorsController());
  final OrdersController _ordersController = Get.put(OrdersController());
  UserDetailsModel? usersData;
  VendorModal? vendorData;
  bool notificationsEnabled = true;
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
    _fetchUserData();
    _fetchVendorData();
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
  }

  void _fetchUserData() async {
    try {
      UserDetailsModel user = await _userData.fetchUserData();
      print(user.name);
      setState(() {
        usersData = user;
      });
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }
  void _fetchVendorData() async {
    try {
      VendorModal? vendor = await controller.fetchStoreData();
      print(vendor!.merchantId);
      setState(() {
        vendorData = vendor;
      });
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: Column(
        children: [
          // Header
          Container(
            padding:
                const EdgeInsets.only(top: 40, bottom: 20, left: 16, right: 16),
            decoration: const BoxDecoration(
              color: Color(0xFF2196F3),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 30,
                      backgroundImage: AssetImage(
                          'assets/avatar.png'), // Replace with actual image
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            vendorData != null 
                                ?vendorData!.bussinessName
                                : "Loading...",
              
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            // "Premium Water Supplier",
                            vendorData != null 
                                ?vendorData!.merchantId
                                : "Loading...",
                            style:
                                TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                          Text(
                            // "Serving fresh water since 2018",
                            vendorData != null 
                                ?vendorData!.businessAddress
                                : "Loading...",
                            style:
                                TextStyle(color: Colors.white60, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white24,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(6),
                      child:
                          const Icon(Icons.edit, color: Colors.white, size: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 12), 
                const Row(
                  children: [
                    Icon(Icons.verified, color: Colors.green, size: 16),
                    SizedBox(width: 4),
                    Text(
                      "Premium Service Provider",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Premium badge box
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF6FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.star, color: Colors.blue),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Premium Service Provider",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Upgrade to Premium for priority deliveries and exclusive benefits",
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Performance overview
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0, 4),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Text(
                              "Performance Overview",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacer(),
                            Text(
                              "This Month",
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            PerformanceMetric(
                                label: "Deliveries", value: totalOrders.toString()),
                            PerformanceMetric(label: "Rating", value: "4.9"),
                            PerformanceMetric(label: "Response", value: "98%"),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Business Details
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0, 4),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Text(
                              "Business Details",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            Icon(Icons.edit, color: Colors.grey),
                          ],
                        ),
                        const SizedBox(height: 12),
                        businessDetail("Service Area",
                            "Downtown Manhattan & Brooklyn Areas"),
                        businessDetail("Daily Capacity", "1000+ gallons"),
                        businessDetail("Pricing",
                            "\$1.5/gallon (Bulk discounts available)"),
                        businessDetail(
                            "Operating Hours", "Mon-Sat: 6:00 AM - 8:00 PM"),
                      ],
                    ),
                  ),

                  GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EarningsDashboard())),
                    child: buildProfileOption(
                        'Earnings', 'all data ', Icons.person),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      child: CustomButton(
                        icon: Icon(
                          Icons.logout,
                          color: Colors.white,
                        ),
                        height: 50,
                        width: double.infinity,
                        text: 'Logout',
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return YesNoPopup(
                                  title: "Logout from app!",
                                  description:
                                      "Are you sure want to exit from application?",
                                  noButtonText: "No",
                                  yesButtonText: "Yes",
                                  onNoButtonPressed: () async {
                                    Navigator.pop(context); // Cancel action
                                  },
                                  onYesButtonPressed: () async {
                                    await FirebaseAuth.instance.signOut();
                                    Navigator.pushReplacementNamed(
                                        context, '/login');
                                  },
                                );
                              });
                        },
                      ),
                    ),
                  ),

              
                ],
              ),
            ),
          ),

          // Bottom NavBar Placeholder
        ],
      ),
    );
  }

  Widget businessDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}

class PerformanceMetric extends StatelessWidget {
  final String label;
  final String value;

  const PerformanceMetric({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        )
      ],
    );
  }
}

Widget buildProfileOption(String title, String subtitle, IconData icon) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
    child: Container(
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Icon(icon, color: ThemeConstants.borderColor),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text(subtitle, style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
    ),
  );
}
