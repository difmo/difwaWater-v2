import 'package:difwa/config/app_color.dart';
import 'package:difwa/controller/auth_controller.dart';
import 'package:difwa/models/user_models/user_details_model.dart';
import 'package:difwa/screens/admin_screens/store_onboarding_screen.dart';
import 'package:difwa/screens/auth/saved_address.dart';
import 'package:difwa/screens/contact_info_page.dart';
import 'package:difwa/screens/edit_personaldetails.dart';
import 'package:difwa/utils/theme_constant.dart';
import 'package:difwa/widgets/logout_popup.dart';
import 'package:difwa/widgets/simmers/ProfileShimmer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthController _userData = Get.put(AuthController());
  UserDetailsModel? usersData;
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _fetchUserData() async {
    try {
      UserDetailsModel user = await _userData.fetchUserData();

      // if (mounted) {
      setState(() {
        print("number");
        _isLoading = false;
        usersData = user;
      });
      // }
    } catch (e) {
      print("number 2");
      // if (mounted) {
      setState(() {
        _isLoading = false;
      });
      // }
      print("Error fetching user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? ProfileShimmer()
        : Scaffold(
            backgroundColor: Colors.white,
            body: usersData == null
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 50),

                        /// Profile Header
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text("Profile",
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(height: 10),

                        Container(
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          // decoration: BoxDecoration(
                          //   color: Colors.white,
                          //   borderRadius: BorderRadius.circular(12),
                          //   boxShadow: [
                          //     BoxShadow(
                          //       color: Colors.black.withOpacity(0.1),
                          //       blurRadius: 5,
                          //       spreadRadius: 2,
                          //     ),
                          //   ],
                          // ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 40,
                                    backgroundColor: Colors.blue.shade700,
                                    backgroundImage: usersData!.profileImage !=
                                                null &&
                                            usersData!.profileImage!.isNotEmpty
                                        ? NetworkImage(usersData!.profileImage!)
                                        : null,
                                    child: (usersData!.profileImage == null ||
                                            usersData!.profileImage!.isEmpty)
                                        ? Text(
                                            usersData!.name.isNotEmpty
                                                ? usersData!.name[0]
                                                    .toUpperCase()
                                                : 'G',
                                            style: const TextStyle(
                                              fontSize: 28,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          )
                                        : null,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                    width: 12,
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        usersData?.name ?? 'Guest',
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        usersData?.number ?? '1234567890',
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Get.to(() => EditPersonaldetails());
                                        },
                                        child: const Text(
                                          "Edit Profile",
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// Profile Options List
                        Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 6), // Spacing between options
                              decoration: BoxDecoration(
                                color: ThemeConstants.primaryColor.withOpacity(
                                    0.1), // Background color grey[200]
                                borderRadius: BorderRadius.circular(
                                    15.0), // Rounded corners
                              ),
                              child: buildProfileOption(
                                title: "Profile",
                                subtitle: "Edit profile details",
                                icon: Icons.person,
                                onTap: () {
                                  Get.to(() => EditPersonaldetails());
                                },
                              ),
                            ),

                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 6), // Spacing between options
                              decoration: BoxDecoration(
                                color: ThemeConstants.primaryColor.withOpacity(
                                    0.1), // Background color grey[200]
                                borderRadius: BorderRadius.circular(
                                    15.0), // Rounded corners
                              ),
                              child: buildProfileOption(
                                title: "Wallet",
                                subtitle: "Wallet balance",
                                icon: Icons.account_balance_wallet_rounded,
                                onTap: () {
                                  Get.to(() => EditPersonaldetails());
                                },
                              ),
                            ),
                            // buildProfileOption(
                            //   title: "Phone Number",
                            //   subtitle: usersData?.number ?? "Not available",
                            //   icon: Icons.phone,
                            //   onTap: () {},
                            // ),
                            // buildProfileOption(
                            //   title: "Email Address",
                            //   subtitle: usersData?.email ?? "Not available",
                            //   icon: Icons.email,
                            //   onTap: () {},
                            // ),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 6),
                              decoration: BoxDecoration(
                                color: ThemeConstants.primaryColor.withOpacity(
                                    0.1),
                                borderRadius: BorderRadius.circular(
                                    15.0), // Rounded corners
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment
                                    .start, // Align text to the left
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 10,
                                      left: 15,
                                      bottom: 8,
                                    ), // Padding around the text
                                    child: Text(
                                      "Orders", // Title text at the top
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors
                                            .black, // You can change this color as needed
                                      ),
                                    ),
                                  ),
                                  buildProfileOption(
                                    title: "Delivery Address",
                                    subtitle: "Manage multiple addresses",
                                    icon: Icons.location_on,
                                    onTap: () {
                                      Get.to(() => SavveAddressPage());
                                    },
                                  ),
                                  buildProfileOption(
                                    title: "Become A Seller",
                                    subtitle:
                                        "Start selling your products today!",
                                    icon: Icons.store,
                                    onTap: () {
                                      Get.to(
                                          () => const StoreOnboardingScreen());
                                    },
                                  ),
                                  buildProfileOption(
                                    title: "Subscription Details",
                                    subtitle: "View/modify water plans",
                                    icon: Icons.subscriptions,
                                    onTap: () {},
                                  ),
                                  buildProfileOption(
                                    title: "Order History",
                                    subtitle: "Check past & ongoing orders",
                                    icon: Icons.history,
                                    onTap: () {},
                                  ),
                                  buildProfileOption(
                                    title: "Payment Methods",
                                    subtitle: "Manage payments",
                                    icon: Icons.payment,
                                    onTap: () {},
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 6),
                              decoration: BoxDecoration(
                                color: ThemeConstants.primaryColor.withOpacity(
                                    0.1),
                                borderRadius: BorderRadius.circular(
                                    15.0), // Rounded corners
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment
                                    .start, // Align text to the left
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 10,
                                      left: 15,
                                      bottom: 8,
                                    ), // Padding around the text
                                    child: Text(
                                      "Customer Support", // Title text at the top
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors
                                            .black, // You can change this color as needed
                                      ),
                                    ),
                                  ),
                                  buildProfileOption(
                                    title: "Contact Information",
                                    subtitle: "Contact us for any queries",
                                    icon: Icons.contact_phone_outlined,
                                    onTap: () {
                                      Get.to(() => ContactPage());
                                    },
                                  ),
                                  buildProfileOption(
                                    title: "My Requests",
                                    subtitle:
                                        "All the requests of the customer",
                                    icon: Icons.request_page,
                                    onTap: () {
                                      Get.to(
                                          () => const StoreOnboardingScreen());
                                    },
                                  ),
                                  buildProfileOption(
                                    title: "FAQ",
                                    subtitle: "FAQ",
                                    icon: Icons.question_answer_outlined,
                                    onTap: () {},
                                  ),
                                  buildProfileOption(
                                    title: "Locate Us",
                                    subtitle: "location ",
                                    icon: Icons.location_on_outlined,
                                    onTap: () {},
                                  ),
                                  buildProfileOption(
                                    title: "Rate Us",
                                    subtitle: "Rate us on playstore",
                                    icon: Icons.star,
                                    onTap: () {},
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 6), // Spacing between options
                              decoration: BoxDecoration(
                                color: ThemeConstants.primaryColor.withOpacity(
                                    0.1), // Background color grey[200]
                                borderRadius: BorderRadius.circular(
                                    15.0), // Rounded corners
                              ),
                              child: buildProfileOption(
                                title: "Logout",
                                subtitle: "Sign out of your account",
                                icon: Icons.logout,
                                onTap: () {
                                  if (!context.mounted) {
                                    return; // Ensure the context is valid
                                  }

                                  showDialog(
                                    context: context,
                                    barrierDismissible:
                                        false, // Prevent accidental dismiss
                                    builder: (BuildContext dialogContext) {
                                      return YesNoPopup(
                                        title: "Logout from app!",
                                        description:
                                            "Are you sure you want to exit from the application?",
                                        noButtonText: "No",
                                        yesButtonText: "Yes",
                                        onNoButtonPressed: () {
                                          Navigator.pop(
                                              dialogContext); // Close the dialog
                                        },
                                        onYesButtonPressed: () async {
                                          await FirebaseAuth.instance.signOut();
                                          if (!context.mounted) return;
                                          Navigator.pop(
                                              dialogContext); // Close the dialog before navigating
                                          Navigator.pushReplacementNamed(
                                              context, '/login');
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
          );
  }

  Widget buildProfileOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Icon(icon, color: AppColors.textBlack),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  // const SizedBox(height: 4),
                  // Text(subtitle, style: const TextStyle(color: Colors.grey)),
                ],
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
