// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';

// class FirebaseHelper {
//   static Future<void> initializeFirebase() async {
//     await Firebase.initializeApp();
//   }

//   static Future<User?> signUp({
//     required String email,
//     required String password,
//   }) async {
//     try {
//       UserCredential userCredential =
//           await FirebaseAuth.instance.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       return userCredential.user;
//     } on FirebaseAuthException catch (e) {
//       print('Error: $e');
//       return null;
//     }
//   }
// }
