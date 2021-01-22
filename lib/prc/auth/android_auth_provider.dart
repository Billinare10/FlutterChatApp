import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'auth_provider_base.dart';

class _AndroidAuthProvider implements AuthProviderBase {
  @override
  Future<FirebaseApp> initialize() async {
    return await Firebase.initializeApp(
        name: 'The Chat Room',
        options: FirebaseOptions(
          apiKey: "AIzaSyCEdbL0gOVMkODgjitHct2Ni46GeUdnFOg",
          authDomain: "the-chat-room-7d42c.firebaseapp.com",
          projectId: "the-chat-room-7d42c",
          storageBucket: "the-chat-room-7d42c.appspot.com",
          messagingSenderId: "808397065222",
          appId: "1:808397065222:android:877a039167ad1e60534787",
          measurementId: "G-L0H6TNDCF4",
        ));
  }

  @override
  Future<UserCredential> signInWithGoogle() async {
    // ignore: todo
    //TODO: implement signInWithGoogle
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}

class AuthProvider extends _AndroidAuthProvider {}
