import 'package:firebase_auth/firebase_auth.dart';
import 'package:flappy_bird_flutter/model/player.dart';
import 'package:flappy_bird_flutter/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get uid {
    return _auth.currentUser!.uid;
  }

  Player? _userFromFirebaseUser(User? user){
    return user != null ? Player(uid: user.uid) : null;
  }

  Stream<Player?>? get user {
    return _auth.authStateChanges()
        .map((User? user) => _userFromFirebaseUser(user));
  }

  //sign in anonym
  Future signInAnonym() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return user;
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  //sign in with e-mail
  Future signIn(String email, String password) async {
    try {
      UserCredential result = await _auth
          .signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch(e){
      print(e.toString());
      return null;
    }
  }

  //register
  Future register(String _email, String _password) async {
    try {
      UserCredential result = await _auth
          .createUserWithEmailAndPassword(email: _email, password: _password);
      User? user = result.user;

      String? email = user!.email;
      String? name = email?.substring(0, email.indexOf('@'));
      await DatabaseService(uid: user.uid).setUserData(name, 0);
      return _userFromFirebaseUser(user);
    } catch(e){
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch(e) {
      print(e.toString());
      return null;
    }
  }
}