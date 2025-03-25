import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:difwa/controller/address_controller.dart';
import 'package:difwa/config/app_color.dart';
import 'package:difwa/screens/auth/adddress_form_page.dart';
import 'package:difwa/models/address_model.dart';

class SavveAddressPage extends StatelessWidget {
  const SavveAddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AddressController addressController = Get.put(AddressController());

    return Scaffold(
      appBar: AppBar(title: Text('Address Book', style: TextStyle(fontWeight: FontWeight.bold),)),
      body: GetBuilder<AddressController>(
        init: addressController,
        builder: (_) {
          return StreamBuilder<List<Address>>(
            stream: addressController.getAddresses(), // Fetch addresses from the controller
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
                  bool isSelected = addresses[index].isSelected;

                  return GestureDetector(
                    onTap: () async {
                      bool? confirmSelection = await _showSelectDialog(context);

                      if (confirmSelection == true) {
                        // Update the selection state
                        addressController.selectAddress(addresses[index].docId);
                      }
                    },
                    child: Card(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      color: AppColors.cardbgcolor,
                      elevation: 0,
                      shape: isSelected
                          ? RoundedRectangleBorder(
                              side: BorderSide(color: Colors.blue, width: 2),
                              borderRadius: BorderRadius.circular(8),
                            )
                          : null, // Add border if selected
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16),
                        leading: Icon(Icons.location_on, color: AppColors.myblack, size: 30), // Location icon on the left
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              addresses[index].name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.myblack,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              addresses[index].saveAddress
                                  ? 'Address: ${addresses[index].floor} ${addresses[index].saveAddress}, ${addresses[index].street}, ${addresses[index].city}, ${addresses[index].country}'
                                  : '',
                              style: TextStyle(fontSize: 12, color: AppColors.myblack),
                            ),
                            Text(
                              addresses[index].zip,
                              style: TextStyle(fontSize: 12, color: AppColors.myblack),
                            ),
                          ],
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                addresses[index].phone.isNotEmpty
                                    ? 'Phone Number: ${addresses[index].phone}'
                                    : '',
                                style: TextStyle(fontSize: 12, color: AppColors.myblack),
                              ),
                            ],
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.edit_outlined,
                                color: AppColors.buttonbgColor,
                                size: 30,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddressForm(
                                      address: addresses[index],
                                      flag: 'isEdit',
                                    ), // Pass the address to edit
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.delete_outlined,
                                color: Colors.red,
                                size: 30,
                              ),
                              onPressed: () async {
                                bool? confirmDelete = await _showDeleteDialog(context);
                                if (confirmDelete == true) {
                                  await addressController.deleteAddress(addresses[index].docId);
                                }
                              },
                            ),
                          ],
                        ),
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
                MaterialPageRoute(
                  builder: (context) => AddressForm(
                    address: Address(
                        docId: "",
                        name: "",
                        street: "",
                        city: "",
                        state: "",
                        zip: "",
                        isDeleted: false,
                        isSelected: false,
                        country: "",
                        phone: "",
                        saveAddress: false,
                        userId: "",
                        floor: ""),
                    flag: "",
                  ), // Navigate to the form to add a new address
                ),
              );
            },
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Icon(
              Icons.add_business_sharp,
              color: AppColors.mywhite,
            ),
          ),
        ],
      ),
    );
  }

  Future<bool?> _showSelectDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        alignment: Alignment.center,
        icon: Icon(
          Icons.location_on,
          color: Colors.blue,
          size: 40,
        ),
        title: Text(
          'Select Address?',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        content: Text(
          'Are you sure you want to select this address?',
          style: TextStyle(fontSize: 12),
          textAlign: TextAlign.center,
        ),
        actions: [
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('GO BACK', style: TextStyle(color: AppColors.iconbgEnd)),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('YES', style: TextStyle(color: AppColors.iconbgEnd)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<bool?> _showDeleteDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        alignment: Alignment.center,
        icon: Icon(
          Icons.delete,
          color: Colors.red,
          size: 40,
        ),
        title: Text(
          'Delete Address?',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        content: Text(
          'Are you sure you want to delete this address?',
          style: TextStyle(fontSize: 12),
          textAlign: TextAlign.center,
        ),
        actions: [
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('GO BACK', style: TextStyle(color: AppColors.iconbgEnd)),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('YES', style: TextStyle(color: AppColors.iconbgEnd)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
