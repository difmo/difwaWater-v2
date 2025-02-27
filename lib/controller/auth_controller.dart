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

///////////////////////////////////////////////////////////////////////// SIGN UP WITH EMAIL //////////////////////////////////////////////////////////////////////////
  Future<void> signwithemail(String email, String name, String password,  String number) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
        
      );

      // Save additional user details in Firestore
      await _saveUserDataemail(userCredential.user!.uid, email, name, number);
      await _fetchUserRole();
      _navigateToDashboard();
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message ?? 'An error occurred while signing up');
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred: $e');
    }
  }

///////////////////////////////////////////////////////////////////////// LOGIN WITH EMAIL //////////////////////////////////////////////////////////////////////////
  Future<void> loginwithemail(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _fetchUserRole();
      _navigateToDashboard();
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message ?? 'An error occurred while logging in');
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred: $e');
    }
  }

///////////////////////////////////////////////////////////////////////// VERIFY USER //////////////////////////////////////////////////////////////////////////
  Future<void> verifyUserExistenceAndLogin(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _fetchUserRole();
      _navigateToHomePage();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
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

///////////////////////////////////////////////////////////////////////// NAVIGATION //////////////////////////////////////////////////////////////////////////
  void _navigateToHomePage() {
    Get.offNamed('/home');
  }

  void _navigateToLoginPage() {
    Get.offNamed('/login');
  }

  void _navigateToDashboard() {
    if (userRole.value == 'isUser') {
      Get.offAllNamed(AppRoutes.userbottom);
    } else if (userRole.value == 'isStoreKeeper') {
      Get.offAllNamed(AppRoutes.userbottom);
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }

///////////////////////////////////////////////////////////////////////// SAVE USER DETAILS ////////////////////////////////////////////////////////////////////
  Future<void> _saveUserDataemail(String uid, String email, String name, String number) async {
    DocumentSnapshot userDoc = await _firestore.collection('difwa-users').doc(uid).get();
    
    if (!userDoc.exists) {
      await _firestore.collection('difwa-users').doc(uid).set({
        'uid': uid,
        'name': name,
        'number': number,
        'email': email,
        'role': 'isUser',
        'walletBalance': 0.0,
      }, SetOptions(merge: true));
    } else {
      await _firestore.collection('difwa-users').doc(uid).update({
        'name': name,
        'number': number,
      });
    }
  }

///////////////////////////////////////////////////////////////////////// FETCH USER ROLE  //////////////////////////////////////////////////////////////////////
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

///////////////////////////////////////////////////////////////////////// HANDLE ROLE CHANGED //////////////////////////////////////////////////////////////////
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

///////////////////////////////////////////////////////////////////////// HANDLE LOGOUT //////////////////////////////////////////////////////////////////////////
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
