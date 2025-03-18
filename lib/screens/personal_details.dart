import 'package:difwa/controller/auth_controller.dart';
import 'package:difwa/models/user_models/user_details_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:difwa/config/app_color.dart';

class PersonalDetails extends StatefulWidget {
  @override
  _PersonalDetailsState createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthController _userData = Get.put(AuthController());
  
  UserDetailsModel? usersData;
  bool isLoading = true;  // लोडिंग स्टेट
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    try {
      UserDetailsModel user = await _userData.fetchUserData();
      setState(() {
        usersData = user;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Error fetching user data: $e";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())  // लोडिंग स्पिनर दिखाएं
          : errorMessage != null
              ? Center(child: Text(errorMessage!))  // एरर मैसेज दिखाएं
              : usersData == null
                  ? Center(child: Text('No user details found.'))  // डेटा नहीं मिलने पर मैसेज
                  : Padding(
                      padding: EdgeInsets.all(16),
                      child: Card(
                        color: AppColors.cardbgcolor,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildUserDetailRow('Email', usersData?.email ?? 'N/A'),
                              _buildUserDetailRow('Floor', usersData?.floor ?? 'N/A'),
                              _buildUserDetailRow('Name', usersData?.name ?? 'N/A'),
                              _buildUserDetailRow('Number', usersData?.number ?? 'N/A'),
                              _buildUserDetailRow('Role', usersData?.role ?? 'N/A'),
                              _buildUserDetailRow('UID', usersData?.uid ?? 'N/A'),
                              _buildUserDetailRow('Wallet Balance', '₹${usersData?.walletBalance ?? 0}'),
                            ],
                          ),
                        ),
                      ),
                    ),
    );
  }

  Widget _buildUserDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.myblack,
            ),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16, color: AppColors.myblack),
          ),
        ],
      ),
    );
  }
}
