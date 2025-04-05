import 'package:difwa/config/app_color.dart';
import 'package:difwa/controller/admin_controller/vendors_controller.dart';
import 'package:difwa/controller/auth_controller.dart';
import 'package:difwa/models/user_models/user_details_model.dart';
import 'package:difwa/screens/admin_screens/earnings.dart';
import 'package:difwa/screens/admin_screens/payment_methods.dart';
import 'package:difwa/screens/auth/saved_address.dart';
import 'package:difwa/screens/edit_personaldetails.dart';
import 'package:difwa/screens/personal_details.dart';
import 'package:difwa/utils/theme_constant.dart';
import 'package:difwa/widgets/custom_button.dart';
import 'package:difwa/widgets/logout_popup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoreProfileScreen extends StatefulWidget {
  const StoreProfileScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<StoreProfileScreen> {
  final AuthController _userData = Get.put(AuthController());
  final VendorsController controller = Get.put(VendorsController());
  UserDetailsModel? usersData;
  bool notificationsEnabled = true;
  bool _isToggled = false;

  void _toggleSwitch(bool value) {
    controller.toggleStoreActiveStatusByCurrentUser();
    setState(() {
      _isToggled = value;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mywhite,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 60),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: AppColors.inputfield,
                        backgroundImage: usersData?.profileImage != null &&
                                usersData!.profileImage!.isNotEmpty
                            ? NetworkImage(usersData!.profileImage!)
                            : null,
                        child: (usersData?.profileImage == null ||
                                usersData!.profileImage!.isEmpty)
                            ? Text(
                                (usersData?.name.isNotEmpty ?? false)
                                    ? usersData!.name[0].toUpperCase()
                                    : 'G',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            usersData?.name ?? 'Guest',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            usersData?.email ?? 'guest@gmail.com',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          TextButton(
                            onPressed: () {
                              Get.to(() => EditPersonaldetails());
                            },
                            child: const Text('Edit Profile',
                                style: TextStyle(color: Colors.blue)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _isToggled,
                  activeColor: Colors.blue, // Thumb color when switch is ON
                  activeTrackColor: Colors.blue
                      .withOpacity(0.5), // Track color when switch is ON
                  inactiveThumbColor:
                      Colors.grey, // Thumb color when switch is OFF
                  inactiveTrackColor: Colors.grey
                      .withOpacity(0.5), // Track color when switch is OFF
                  onChanged: _toggleSwitch,
                )
              ],
            ),
            GestureDetector(
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PersonalDetails())),
              child: buildProfileOption(
                  'Profile', 'Edit profile details', Icons.person),
            ),
            GestureDetector(
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => EarningsDashboard())),
              child: buildProfileOption('Earnings', 'all data ', Icons.person),
            ),
            GestureDetector(
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SavveAddressPage())),
              child: buildProfileOption('Delivery Address',
                  'Manage multiple addresses', Icons.location_on),
            ),
            buildProfileOption('Subscription Details',
                'View/modify water plans', Icons.subscriptions),
            GestureDetector(
               onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PaymentMethods())),
              child: buildProfileOption(
                  'Payment Methods', 'Manage payments', Icons.payment),
            ),
            _buildNotificationSetting(),
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
                              Navigator.pushReplacementNamed(context, '/login');
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
    );
  }

  Widget _buildNotificationSetting() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 5,
              spreadRadius: 2,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: const [
                Icon(Icons.notifications, color: Colors.blue),
                SizedBox(width: 16),
                Column(
                  children: [
                    Text('Notifications Settings',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Text('Change Notification Visibility',
                        style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),
            Switch(
                value: notificationsEnabled,
                activeColor: Colors.blue, // Thumb color when switch is ON
                activeTrackColor: Colors.blue
                    .withOpacity(0.5), // Track color when switch is ON
                inactiveThumbColor:
                    Colors.grey, // Thumb color when switch is OFF
                inactiveTrackColor: Colors.grey
                    .withOpacity(0.5), // Track color when switch is OFF
                onChanged: (value) {
                  setState(() {
                    notificationsEnabled = value;
                  });
                }),
          ],
        ),
      ),
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
