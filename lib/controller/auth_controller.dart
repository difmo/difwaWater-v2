import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:difwa/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var verificationId = ''.obs;
  var userRole = ''.obs;

  @override
  void onReady() {
    super.onReady();
    _auth.authStateChanges().listen(_handleAuthStateChanged);
  }

  Future<void> login(String phoneNumber, String name) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        await _saveUserData(name); // Pass name to _saveUserData
        await _fetchUserRole();
        _navigateToDashboard();
      },
      verificationFailed: (FirebaseAuthException e) {
        Get.snackbar('Error', e.message ?? 'Verification failed');
      },
      codeSent: (String verId, int? resendToken) {
        verificationId.value = verId;
        Get.toNamed(AppRoutes.otp);
      },
      codeAutoRetrievalTimeout: (String verId) {
        verificationId.value = verId;
      },
    );
  }

    Future<void> registerwithemail(String email, String password) async {
    try {
      // Sign in using email and password
      print("hello");
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // After successful login, save user data and fetch user role
      print("hello1");
      await _saveUserDataemail(email); // Check if name is set in Firestore
      await _fetchUserRole();
      print("hello2");

      // Navigate to dashboard based on user role
      _navigateToDashboard();
    } on FirebaseAuthException catch (e) {
      // If there's an error during login, show a Snackbar with error message
      Get.snackbar('Error', e.message ?? 'An error occurred while logging in');
    } catch (e) {
      // Catch any other errors that may happen (e.g., network errors, etc.)
      Get.snackbar('Error', 'An unexpected error occurred: $e');
    }
  }
    Future<void> loginwithemail(String email, String password) async {
    try {
      // Sign in using email and password
      print("hello");
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // After successful login, save user data and fetch user role
      print("hello1");
      await _fetchUserRole();
      print("hello2");

      // Navigate to dashboard based on user role
      _navigateToDashboard();
    } on FirebaseAuthException catch (e) {
      // If there's an error during login, show a Snackbar with error message
      Get.snackbar('Error', e.message ?? 'An error occurred while logging in');
    } catch (e) {
      // Catch any other errors that may happen (e.g., network errors, etc.)
      Get.snackbar('Error', 'An unexpected error occurred: $e');
    }
  }
Future<void> verifyUserExistenceAndLogin(String email, String password) async {
  try {
    // Check if the user exists by trying to sign in
    print("Checking if user exists...");
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    // If successful, proceed to check user data and navigate
    print("User found, verifying...");
    await _saveUserDataemail(email); // Check if name is set in Firestore
    await _fetchUserRole();
    print("User verified");

    // Navigate to the home page after successful login
    _navigateToHomePage();
  } on FirebaseAuthException catch (e) {
    // If the error is related to user not found or wrong credentials
    if (e.code == 'user-not-found') {
      print("User not found, navigate to login page");
      // Navigate to the login page
      _navigateToLoginPage();
    } else if (e.code == 'wrong-password') {
      // Handle wrong password error specifically
      Get.snackbar('Error', 'Incorrect password. Please try again.');
    } else {
      // Handle any other Firebase authentication errors
      Get.snackbar('Error', e.message ?? 'An error occurred while logging in');
    }
  } catch (e) {
    // Catch any other errors that may happen (e.g., network errors, etc.)
    Get.snackbar('Error', 'An unexpected error occurred: $e');
  }
}

// Navigation methods for Home and Login pages
void _navigateToHomePage() {
  // Replace with your logic to navigate to the home page
  Get.offNamed('/home'); // Example using GetX routing
}

void _navigateToLoginPage() {
  // Replace with your logic to navigate to the login page
  Get.offNamed('/login'); // Example using GetX routing
}


  Future<void> verifyOTP(String otp) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId.value,
        smsCode: otp,
      );
      await _auth.signInWithCredential(credential);
      await _saveUserData(""); // Empty name when OTP is verified
      await _fetchUserRole();
      _navigateToDashboard();
    } catch (e) {
      Get.snackbar('Error', 'Invalid OTP');
    }
  }

  Future<void> _saveUserData(String name) async {
    final user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('difwa-users').doc(user.uid).get();
      if (!userDoc.exists) {
        await _firestore.collection('difwa-users').doc(user.uid).set({
          'mobileNumber': user.phoneNumber,
          'uid': user.uid,
          'role': 'isUser',
          'name': name,
          'walletBalance': 0.0, // Initialize walletBalance for new users
        }, SetOptions(merge: true));
      } else {
        await _firestore.collection('difwa-users').doc(user.uid).update({
          'name': name,
          'walletBalance': 0.0, // Initialize walletBalance for new users
        });
      }
    }
  }


  Future<void> _saveUserDataemail(String email) async {
    final user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('difwa-users').doc(user.uid).get();
      if (!userDoc.exists) {
        await _firestore.collection('difwa-users').doc(user.uid).set({
          'uid': user.uid,
          'role': 'isUser',
          'email': email,
          'walletBalance': 0.0, // Initialize walletBalance for new users
        }, SetOptions(merge: true));
      } else {
        await _firestore.collection('difwa-users').doc(user.uid).update({
          'name': email,
          'walletBalance': 0.0, // Initialize walletBalance for new users
        });
      }
    }
  }

  Future<void> _fetchUserRole() async {
    final user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('difwa-users').doc(user.uid).get();
      if (userDoc.exists) {
        userRole.value = userDoc['role'] ?? 'isUser';
      } else {
        userRole.value = 'isUser';
      }
    }
  }

  void _handleAuthStateChanged(User? user) {
    if (user != null) {
      _firestore
          .collection('difwa-users')
          .doc(user.uid)
          .snapshots()
          .listen((doc) {
        if (doc.exists) {
          userRole.value = doc.data()?['role'] ?? 'isUser';
          _navigateToDashboard();
        }
      });
    }
  }

  void _navigateToDashboard() {
    if (userRole.value == 'isUser') {
      Get.offAllNamed(AppRoutes.userbottom);
    } else if (userRole.value == 'isStoreKeeper') {
      Get.offAllNamed(AppRoutes.userbottom);
    } else {
      Get.offAllNamed(AppRoutes.userbottom);
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      Get.snackbar('Success', 'Logged out successfully');
            Get.offAllNamed(AppRoutes.login);

    } catch (e) {
      Get.snackbar('Error', 'Error logging out: $e');
    }
  }
}
