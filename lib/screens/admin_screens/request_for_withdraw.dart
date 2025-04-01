import 'package:difwa/controller/admin_controller/add_store_controller.dart';
import 'package:difwa/controller/wallet_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RequestForWithdraw extends StatefulWidget {
  const RequestForWithdraw({super.key});

  @override
  State<RequestForWithdraw> createState() => _RequestForWithdrawState();
}

class _RequestForWithdrawState extends State<RequestForWithdraw> {
  TextEditingController amountController = TextEditingController();
  final AddStoreController _addStoreController = Get.put(AddStoreController());
  WalletController? walletController;
  String totalEarnings = "";
  double enteredAmount = 0.0;

  @override
  void initState() {
    super.initState();
    totalEarnings = Get.arguments.toString();
    walletController = WalletController(
      context: context,
      amountController: amountController,
    );
    walletController?.fetchUserWalletBalance();
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  void _withdrawMoney() async {
    print("Withdraw request for \$$enteredAmount");

    double? parsedEarnings = double.tryParse(totalEarnings);
    if (parsedEarnings != null && enteredAmount > parsedEarnings) {
      print("So sorry enter less then of total amount");

      _addStoreController.updateStoreDetails({});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Withdraw Amount",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Current Balance",
                style: TextStyle(color: Colors.grey, fontSize: 16)),
            const SizedBox(height: 4),
            Text(
              "₹ $totalEarnings",
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              onChanged: (value) => setState(() {
                enteredAmount = double.tryParse(value) ?? 0;
              }),
              decoration: InputDecoration(
                prefixText: "₹ ",
                hintText: "0.00",
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [10, 20, 50, 100]
                  .map((amount) => ElevatedButton(
                        onPressed: () {
                          setState(() {
                            enteredAmount = amount.toDouble();
                            amountController.text = amount.toString();
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(color: Colors.grey),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 20),
                        ),
                        child: Text("+₹${amount.toString()}"),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 20),
            const Text(
              "Transaction History",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const SizedBox(height: 10),
            const Text(
              "A 1.5% processing fee may apply. Funds typically arrive within 24 hours.",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _withdrawMoney,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Withdraw",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
