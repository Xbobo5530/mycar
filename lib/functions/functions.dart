import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

const tag = 'Functions';

class Functions {
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<FirebaseUser> getCurrentUser() async {
    return await auth.currentUser();
  }

  logout() {
    auth.signOut();
    print('$tag signned out');
  }

  var database = Firestore.instance;
}
