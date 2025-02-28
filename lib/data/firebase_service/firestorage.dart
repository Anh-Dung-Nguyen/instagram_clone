import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram/data/model/usermodel.dart';
import 'package:instagram/util/exception.dart';
import 'package:uuid/uuid.dart';

class Firebase_Firestorage {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> CreateUser ({
    required String email,
    required String username,
    required String bio,
    required String profile,
  }) async {
    await _firebaseFirestore.collection('users').doc(_auth.currentUser!.uid).set({
      'email': email,
      'username': username,
      'bio': bio,
      'profile': profile,
      'followers': [],
      'following': [],
    });
    return true;
  }

  Future<Usermodel> getUser({String ? uidd}) async {
    try {
      final user = await _firebaseFirestore.collection('users').doc(uidd ?? _auth.currentUser!.uid).get();
      final snapuser = user.data()!;
      return Usermodel(snapuser['bio'], snapuser['email'], snapuser['followers'], snapuser['following'], snapuser['profile'], snapuser['username']);
    } on FirebaseException catch (e) {
        throw exceptions(e.message.toString());
    }
  }

  Future<bool> CreatePost({
    required String postImage,
    required String caption,
    required String location,
  }) async {
    var uid = Uuid().v4();
    DateTime data = new DateTime.now();
    Usermodel user = await getUser();
    await _firebaseFirestore.collection('posts').doc(uid).set({
      'postImage': postImage,
      'username': user.username,
      'profileImage': user.profile,
      'caption': caption,
      'location': location,
      'uid': _auth.currentUser!.uid,
      'postId': uid,
      'like': [],
      'time': data
    });
    return true;
  }

  Future<bool> CreateReels({
    required String video,
    required String caption,
  }) async {
    var uid = Uuid().v4();
    DateTime data = new DateTime.now();
    Usermodel user = await getUser();
    await _firebaseFirestore.collection('reels').doc(uid).set({
      'reelsvideo': video,
      'username': user.username,
      'profileImage': user.profile,
      'caption': caption,
      'uid': _auth.currentUser!.uid,
      'postId': uid,
      'like': [],
      'time': data
    });
    return true;
  }

  Future<bool> Comments({
    required String comment,
    required String type,
    required String uidd,
  }) async {
    var uid = Uuid().v4();
    Usermodel user = await getUser();
    await _firebaseFirestore.collection(type).doc(uidd).collection('comments').doc(uid).set({
      'comment': comment,
      'username': user.username,
      'profileImage': user.profile,
      'CommentUid': uid,
    });
    return true;
  }

  Future<String> like ({
    required List like,
    required String type,
    required String uid,
    required String postId,
  }) async {
    String res = 'Some error';
    try {
      if (like.contains(uid)) {
        _firebaseFirestore.collection(type).doc(postId).update({
          'like': FieldValue.arrayRemove([uid])
        });
      } else {
        _firebaseFirestore.collection(type).doc(postId).update({
          'like': FieldValue.arrayUnion([uid])
        });
      }
      res = 'Success';
    } on Exception catch (e) {
      // TODO
      res = e.toString();
    }
    return res;
  }

  Future<String> follow ({
    required String uid,
  }) async {
    String res = 'Some error';
    DocumentSnapshot snap = await _firebaseFirestore.collection('users').doc(_auth.currentUser!.uid).get();
    List follow = (snap.data()! as dynamic)['following'];
    try {
      if (follow.contains(uid)) {
        await _firebaseFirestore.collection('users').doc(_auth.currentUser!.uid).update({
          'following': FieldValue.arrayRemove([uid])
        });
        await _firebaseFirestore.collection('users').doc(uid).update({
          'followers': FieldValue.arrayRemove([_auth.currentUser!.uid])
        });
      } else {
        await _firebaseFirestore.collection('users').doc(_auth.currentUser!.uid).update({
          'following': FieldValue.arrayUnion([uid])
        });
        await _firebaseFirestore.collection('users').doc(uid).update({
          'followers': FieldValue.arrayUnion([_auth.currentUser!.uid])
        });
      }
      res = 'Success';
    } on Exception catch (e) {
      // TODO
      res = e.toString();
    }
    return res;
  }
}