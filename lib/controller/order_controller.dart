// void updateDateStatus(String orderId, String date, String newStatus) async {
//   DocumentReference orderRef =
//       FirebaseFirestore.instance.collection('difwaorders').doc(orderId);

//   try {
//     // Get the current timestamp from the server
//     Timestamp currentTimestamp = Timestamp.now();

//     DocumentSnapshot orderSnapshot = await orderRef.get();

//     if (orderSnapshot.exists) {
//       List<dynamic> selectedDates = orderSnapshot['selectedDates'];

//       List<dynamic> updatedDates = selectedDates.map((dateObj) {
//         if (dateObj['date'] == date) {
//           List<dynamic> statusHistory = List.from(dateObj['statusHistory']);
//           statusHistory.add({
//             'status': newStatus,
//             'time': currentTimestamp, // Use fetched timestamp instead
//           });

//           return {
//             'date': dateObj['date'],
//             'statusHistory': statusHistory,
//           };
//         }
//         return dateObj;
//       }).toList();

//       await orderRef.update({'selectedDates': updatedDates});
//     }
//   } catch (e) {
//     print('Error updating date status: $e');
//   }
// }



// Widget buildStatusHistory(List<dynamic> statusHistory) {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: statusHistory.map((history) {
//       Timestamp time = history['time'];
//       DateTime dateTime = time.toDate();

//       return Text(
//         '${history['status']} on ${DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime)}',
//         style: TextStyle(fontSize: 14, color: Colors.grey),
//       );
//     }).toList(),
//   );
// }

// Widget buildOrderDetails(Map<String, dynamic> order) {
//   List<dynamic> selectedDates = order['selectedDates'];

//   return ListView.builder(
//     itemCount: selectedDates.length,
//     itemBuilder: (context, index) {
//       Map<String, dynamic> dateInfo = selectedDates[index];

//       return Card(
//         child: ListTile(
//           title: Text('Date: ${dateInfo['date']}'),
//           subtitle: buildStatusHistory(dateInfo['statusHistory']),
//         ),
//       );
//     },
//   );
// }
// List<Map<String, dynamic>> selectedDatesWithHistory = widget.selectedDates
//     .map((date) => {
//           'date': date.toIso8601String(),
//           'statusHistory': [
//             {
//               'status': 'pending',
//               'time': Timestamp.now(), // Use Timestamp.now() instead
//             }
//           ],
//         })
//     .toList();
