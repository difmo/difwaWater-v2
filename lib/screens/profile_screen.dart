import 'package:difwa/controller/auth_controller.dart';
import 'package:difwa/models/user_models/user_details_model.dart';
import 'package:difwa/screens/admin_screens/store_onboarding_screen.dart';
import 'package:difwa/screens/auth/saved_address.dart';
import 'package:difwa/screens/edit_personaldetails.dart';
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
        _isLoading = false;
        usersData = user;
      });
      // }
    } catch (e) {
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
            backgroundColor: Colors.grey[200],
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
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 5,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
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
                                        usersData?.email ?? 'guest@gmail.com',
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
                            buildProfileOption(
                              title: "Profile",
                              subtitle: "Edit profile details",
                              icon: Icons.person,
                              onTap: () {
                                Get.to(() => EditPersonaldetails());
                              },
                            ),
                            buildProfileOption(
                              title: "Phone Number",
                              subtitle: usersData?.number ?? "Not available",
                              icon: Icons.phone,
                              onTap: () {},
                            ),
                            buildProfileOption(
                              title: "Email Address",
                              subtitle: usersData?.email ?? "Not available",
                              icon: Icons.email,
                              onTap: () {},
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
                              subtitle: "Start selling your products today!",
                              icon: Icons.store,
                              onTap: () {
                                Get.to(() => const StoreOnboardingScreen());
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
                            buildProfileOption(
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
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.blue),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
