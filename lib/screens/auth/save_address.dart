import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:difwa/controller/address_controller.dart';
import 'package:difwa/config/app_color.dart';
import 'package:difwa/screens/auth/adddress_page.dart';
import 'package:difwa/models/address_model.dart'; // Your Address Model

class SavveAddressPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AddressController addressController = Get.put(AddressController());

    return Scaffold(
      appBar: AppBar(title: Text('My Address')),
      body: GetBuilder<AddressController>(
        init: addressController,
        builder: (_) {
          return FutureBuilder<List<Address>>(
            future: addressController.getAddresses(), // Fetch addresses from the controller
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Failed to load addresses'));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No addresses found.'));
              }

              final addresses = snapshot.data!;

              return ListView.builder(
                itemCount: addresses.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    elevation: 5,
                    child: ListTile(
                      title: Text(addresses[index].name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.myblack)),
                      leading: Text(addresses[index].phone, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.myblack)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: AppColors.myblack),
                            onPressed: () {
                              // Navigate to the edit screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddressForm(), // Pass the address to edit
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              // Show a confirmation dialog before deleting
                              bool? confirmDelete = await _showDeleteDialog(context);
                              if (confirmDelete == true) {
                                // Delete the address if confirmed
                                await addressController.deleteAddress(addresses[index].userId);
                              }
                            },
                          ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(addresses[index].street),
                          Text(addresses[index].city),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            child: Image.asset(
              'assets/icons/iconbg.png',
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddressForm()), // Navigate to the form to add a new address
              );
            },
            child: Icon(
              Icons.add_business_sharp,
              color: AppColors.mywhite,
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        ],
      ),
    );
  }

  Future<bool?> _showDeleteDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Address'),
        content: Text('Are you sure you want to delete this address?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
