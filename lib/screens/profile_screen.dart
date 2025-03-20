import 'package:difwa/controller/auth_controller.dart';
import 'package:difwa/models/user_models/user_details_model.dart';
// import 'package:difwa/routes/app_routes.dart';
import 'package:difwa/screens/admin_screens/store_onboarding_screen.dart';
import 'package:difwa/screens/auth/saved_address.dart';
import 'package:difwa/screens/personal_details.dart';
import 'package:difwa/utils/theme_constant.dart';
import 'package:difwa/widgets/logout_popup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../config/app_color.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthController _userData = Get.put(AuthController());
  UserDetailsModel? usersData;
  @override
  void initState() {
    super.initState();

    // Fetch user data
    _fetchUserData();
  }

  void _fetchUserData() async {
    try {
      UserDetailsModel user = await _userData.fetchUserData();
      print(user.name); // This will print the user details to the console
      setState(() {
        // You can update state here if needed, for example:
        // _user = user;
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
            Container(
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.inputfield,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        usersData?.name ?? 'No Data found',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        usersData?.email ?? 'No email found',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PersonalDetails())),
              child: const MenuOption(
                icon: Icons.person,
                title: 'Profile',
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SavveAddressPage())),
              child: const MenuOption(
                icon: Icons.home,
                title: 'Address',
              ),
            ),
            // const MenuOption(
            //   icon: Icons.help,
            //   title: 'Help Center',
            // ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const StoreOnboardingScreen(),
                  ),
                );
              },
              child: const MenuOption(
                icon: Icons.store,
                title: 'Become A Seller',
              ),
            ),
            // const MenuOption(
            //   icon: Icons.info_outline,
            //   title: 'About Us',
            // ),
            // const MenuOption(
            //   icon: Icons.info_outline,
            //   title: 'About Us',
            // ),
            // const MenuOption(
            //   icon: Icons.contact_mail,
            //   title: 'Contact Us',
            // ),
            GestureDetector(
              onTap: () {
                LogoutDialog.showLogoutDialog(context);
              },
              //  async
              //  {
              //   try {
              //     await _auth.signOut();
              //     Get.snackbar('Success', 'Logged out successfully');
              //     Get.offAllNamed(AppRoutes.login);
              //   } catch (e) {
              //     Get.snackbar('Error', 'Error logging out: $e');
              //   }
              // },
              child: const MenuOption(
                icon: Icons.logout,
                title: 'Logout',
              ),
            ),
            // const MenuOption(
            //   icon: Icons.contact_mail,
            //   title: 'Become a dealer',
            // ),
          ],
        ),
      ),
    );
  }
}

class MenuOption extends StatelessWidget {
  final IconData icon;
  final String title;

  const MenuOption({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 1.0, vertical: 2.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        children: [
          Icon(icon, size: 24, color: AppColors.inputfield),
          const SizedBox(width: 16),
          Text(
            title,
            style: const TextStyle(fontSize: 16),
          ),
          const Spacer(),
          const Icon(Icons.arrow_forward, size: 24, color: ThemeConstants.grey),
        ],
      ),
    );
  }
}
