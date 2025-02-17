// // lib/utils/validators.dart

// class Validators {
//   static String? validateEmail(String? value) {
//     if (value == null || value.trim().isEmpty) {
//       return 'Email is required';
//     }
//     if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(value)) {
//       return 'Enter a valid email address';
//     }
//     return null;
//   }

//   static String? validatePassword(String? value) {
//     if (value == null || value.trim().isEmpty) {
//       return 'Password is required';
//     }
//     if (value.length < 8) {
//       return 'Password must be at least 8 characters';
//     }
//     return null;
//   }
// }
