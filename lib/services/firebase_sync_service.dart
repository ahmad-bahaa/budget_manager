import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseSyncService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Adding the serverClientId can sometimes help with error 10, 
  // though it's usually a SHA-1 issue.
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
  );

  User? get currentUser => _auth.currentUser;

  Future<User?> signIn() async {
    print('FirebaseSyncService: Starting signIn()');
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print('FirebaseSyncService: Google Sign-In cancelled by user');
        return null;
      }
      print('FirebaseSyncService: Google Sign-In successful: ${googleUser.email}');

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      print('FirebaseSyncService: Obtained Google Auth tokens');
      
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      print('FirebaseSyncService: Signing into Firebase with credential');
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      print('FirebaseSyncService: Firebase Sign-In successful for UID: ${userCredential.user?.uid}');
      return userCredential.user;
    } catch (e, stack) {
      print('FirebaseSyncService: Error during signIn(): $e');
      print('FirebaseSyncService: Stack trace: $stack');
      rethrow;
    }
  }

  Future<User?> signInSilently() async {
    print('FirebaseSyncService: Starting signInSilently()');
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signInSilently();
      if (googleUser == null) {
        print('FirebaseSyncService: No silent Google Sign-In account found');
        return null;
      }
      print('FirebaseSyncService: Silent Google Sign-In successful: ${googleUser.email}');

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      print('FirebaseSyncService: Signing into Firebase silently');
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      print('FirebaseSyncService: Firebase Silent Sign-In successful for UID: ${userCredential.user?.uid}');
      return userCredential.user;
    } catch (e) {
      print('FirebaseSyncService: Error during signInSilently(): $e');
      return null;
    }
  }

  Future<void> signOut() async {
    print('FirebaseSyncService: Starting signOut()');
    await _googleSignIn.signOut();
    await _auth.signOut();
    print('FirebaseSyncService: Signed out from Google and Firebase');
  }

  Future<void> uploadData(Map<String, dynamic> data) async {
    print('FirebaseSyncService: Starting uploadData()');
    final user = _auth.currentUser;
    if (user == null) {
      print('FirebaseSyncService: Upload failed - No user signed in');
      throw Exception('User not signed in');
    }

    print('FirebaseSyncService: Uploading data for UID: ${user.uid}');
    try {
      await _firestore.collection('sync_data').doc(user.uid).set(data);
      print('FirebaseSyncService: Data upload successful');
    } catch (e, stack) {
      print('FirebaseSyncService: Error during uploadData(): $e');
      print('FirebaseSyncService: Stack trace: $stack');
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> downloadData() async {
    print('FirebaseSyncService: Starting downloadData()');
    final user = _auth.currentUser;
    if (user == null) {
      print('FirebaseSyncService: Download failed - No user signed in');
      throw Exception('User not signed in');
    }

    print('FirebaseSyncService: Fetching document for UID: ${user.uid}');
    try {
      final doc = await _firestore.collection('sync_data').doc(user.uid).get();
      if (doc.exists) {
        print('FirebaseSyncService: Document found and downloaded');
        return doc.data();
      } else {
        print('FirebaseSyncService: No document found for this user');
        return null;
      }
    } catch (e, stack) {
      print('FirebaseSyncService: Error during downloadData(): $e');
      print('FirebaseSyncService: Stack trace: $stack');
      rethrow;
    }
  }
}
