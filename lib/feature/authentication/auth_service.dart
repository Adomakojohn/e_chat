import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

//log user in
  Future<UserCredential> signInWithEmailPassword(
    String email,
    password,
  ) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      firestore.collection("Users").doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
      });
      initializePushNotifications();
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  //create user
  Future<UserCredential> signUpWithEmailAndPassword(
    String email,
    password,
  ) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      firestore.collection("Users").doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
        'chat_room_id': [],
      });
      initializePushNotifications();
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  //log user out
  Future<void> signOut() async {
    return await _auth.signOut();
  }

  //get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<String?> getCurrentUserId() async {
    User? user = _auth.currentUser;
    return user?.uid;
  }

  // Initialize push notifications
  Future<void> initializePushNotifications() async {
    // Request permissions for iOS (if applicable)
    await _firebaseMessaging.requestPermission();

    // Get the FCM token and save it to Firestore
    _firebaseMessaging.getToken().then((token) {
      if (token != null) {
        print("the token:$token");
        _saveTokenToFirestore(token);
      }
    });

    // Listen for token refresh
    FirebaseMessaging.instance.onTokenRefresh.listen(_saveTokenToFirestore);
  }

  // Save or update the FCM token in Firestore
  Future<void> _saveTokenToFirestore(String token) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await firestore.collection('users').doc(user.uid).update({
        'fcmToken': token,
      });
    }
  }
}
