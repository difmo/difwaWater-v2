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

      print("hello1");
      await _saveUserDataemail(email); // Check if name is set in Firestore
      await _fetchUserRole();
      print("hello2");

      _navigateToDashboard();
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message ?? 'An error occurred while logging in');
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred: $e');
    }
  }
    Future<void> loginwithemail(String email, String password) async {
    try {
      print("hello");
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      print("hello1");
      await _fetchUserRole();
      print("hello2");

      _navigateToDashboard();
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message ?? 'An error occurred while logging in');
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred: $e');
    }
  }
Future<void> verifyUserExistenceAndLogin(String email, String password) async {
  try {
    print("Checking if user exists...");
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    print("User found, verifying...");
    await _saveUserDataemail(email);
    await _fetchUserRole();
    print("User verified");

    _navigateToHomePage();
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print("User not found, navigate to login page");
      _navigateToLoginPage();
    } else if (e.code == 'wrong-password') {
      Get.snackbar('Error', 'Incorrect password. Please try again.');
    } else {
      Get.snackbar('Error', e.message ?? 'An error occurred while logging in');
    }
  } catch (e) {
    Get.snackbar('Error', 'An unexpected error occurred: $e');
  }
}

void _navigateToHomePage() {
  Get.offNamed('/home'); 
}

void _navigateToLoginPage() {
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
