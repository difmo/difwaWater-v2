// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: LoginPage(),
//     );
//   }
// }

// class LoginPage extends StatefulWidget {
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   bool isPasswordVisible = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 30),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 'Welcome Back',
//                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 8),
//               const Text('Please sign in to continue'),
//               const SizedBox(height: 24),
//               TextFormField(
//                 controller: emailController,
//                 decoration: InputDecoration(
//                   labelText: 'Email Address',
//                   border: OutlineInputBorder(),
//                   prefixIcon: Icon(Icons.email),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: passwordController,
//                 obscureText: !isPasswordVisible,
//                 decoration: InputDecoration(
//                   labelText: 'Password',
//                   border: OutlineInputBorder(),
//                   prefixIcon: Icon(Icons.lock),
//                   suffixIcon: IconButton(
//                     icon: Icon(
//                       isPasswordVisible ? Icons.visibility : Icons.visibility_off,
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         isPasswordVisible = !isPasswordVisible;
//                       });
//                     },
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       Checkbox(value: false, onChanged: (value) {}),
//                       const Text('Remember me'),
//                     ],
//                   ),
//                   TextButton(
//                     onPressed: () {},
//                     child: const Text('Forgot password?'),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () {},
//                   child: const Text('Sign In'),
//                 ),
//               ),
//               const SizedBox(height: 24),
//               Row(
//                 children: const [
//                   Expanded(child: Divider()),
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 10),
//                     child: Text('OR'),
//                   ),
//                   Expanded(child: Divider()),
//                 ],
//               ),
//               const SizedBox(height: 24),
//               SocialLoginButton(icon: Icons.g_mobiledata, text: 'Continue with Google', color: Colors.white),
//               const SizedBox(height: 10),
//               SocialLoginButton(icon: Icons.facebook, text: 'Continue with Facebook', color: Colors.blue),
//               const SizedBox(height: 10),
//               SocialLoginButton(icon: Icons.apple, text: 'Continue with Apple', color: Colors.black),
//               const SizedBox(height: 24),
//               Center(
//                 child: GestureDetector(
//                   onTap: () {},
//                   child: const Text(
//                     "Don't have an account? Sign up",
//                     style: TextStyle(color: Colors.blue),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class SocialLoginButton extends StatelessWidget {
//   final IconData icon;
//   final String text;
//   final Color color;

//   const SocialLoginButton({
//     required this.icon,
//     required this.text,
//     required this.color,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: double.infinity,
//       child: ElevatedButton.icon(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: color,
//           foregroundColor: Colors.white,
//         ),
//         onPressed: () {},
//         icon: Icon(icon),
//         label: Text(text),
//       ),
//     );
//   }
// }
