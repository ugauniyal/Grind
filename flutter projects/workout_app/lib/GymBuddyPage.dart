import 'dart:async';
import 'dart:developer';

import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GymBuddy extends StatefulWidget {
  @override
  _GymBuddyState createState() => _GymBuddyState();
}

class _GymBuddyState extends State<GymBuddy> {
  final AppinioSwiperController controller = AppinioSwiperController();
  late User _user;
  List<UserData> _filteredUsers = [];
  String? viewPhotoUrl;
  bool _loadingMoreUsers = false;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
      _requestsSubscription;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
    _loadFilteredUsers();
  }

  @override
  void dispose() {
    // Cancel the subscription to avoid memory leaks
    _requestsSubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadFilteredUsers() async {
    // Query the 'requests' subcollection for the logged-in user where pending = true
    QuerySnapshot<Map<String, dynamic>> requestsSnapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_user.uid)
            .collection('requests')
            .where('pending', isEqualTo: true)
            .get();

    // Get the list of swiped user IDs
    List<String> swipedUserIds = requestsSnapshot.docs
        .where((userDoc) => userDoc['swiped'] == true)
        .map((swipedUserDoc) => swipedUserDoc.id)
        .toList();

    // Query all users excluding the swiped ones and the logged-in user
    QuerySnapshot<Map<String, dynamic>> allUsersSnapshot =
        await FirebaseFirestore.instance.collection('users').get();

    _filteredUsers = allUsersSnapshot.docs
        .where((userDoc) =>
            !swipedUserIds.contains(userDoc.id) && userDoc.id != _user.uid)
        .map((userDoc) => UserData.fromMap(userDoc.data()))
        .toList();

    setState(() {
      _filteredUsers = _filteredUsers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gym Buddy App'),
      ),
      body: _filteredUsers.length > 0
          ? AppinioSwiper(
              controller: controller,
              cardCount: _filteredUsers.length,
              onSwipeEnd: _swipeEnd,
              onEnd: _onEnd,
              cardBuilder: (BuildContext context, int index) {
                double cardHeight = MediaQuery.of(context).size.height * 0.6;
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(_filteredUsers[index].name),
                      ),
                      // Display the user image using CachedNetworkImage
                      FutureBuilder<String>(
                        future: _getUserImage(_filteredUsers[index].uid),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return CachedNetworkImage(
                              imageUrl: snapshot.data ??
                                  'https://moorepediatricnc.com/wp-content/uploads/2022/08/default_avatar.jpg',
                              height: cardHeight,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Center(
                                child: Text('Loading'),
                              ),
                              errorWidget: (context, url, error) =>
                                  Text('Error loading image'),
                            );
                          } else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: Text('Loading'),
                            );
                          } else {
                            return Text('Error loading image');
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            )
          : _loadingMoreUsers
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 8),
                      Text('Loading more users...'),
                    ],
                  ),
                )
              : Center(
                  child: Text('Loading'),
                ),
    );
  }

  Future<String> _getUserImage(String uid) async {
    DocumentSnapshot<Map<String, dynamic>> userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    String updatedDownloadUrl = userDoc.get('downloadUrl1');

    return updatedDownloadUrl;
  }

  Future<void> _swipeEnd(
      int previousIndex, int targetIndex, SwiperActivity activity) async {
    String? uid = _user?.uid;

    if (activity is Swipe) {
      log('The card was swiped to the : ${activity.direction}');
      log('previous index: $previousIndex, target index: $targetIndex');

      try {
        // Create or update the request collection for the logged-in user
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('requests')
            .doc(_filteredUsers[previousIndex].uid)
            .set({
          'uid': _filteredUsers[previousIndex].uid,
          'pending': true,
          'accepted': false,
          'block': false,
          'swiped': true,
        }, SetOptions(merge: true));

        // Create or update the request collection for the other user
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_filteredUsers[previousIndex].uid)
            .collection('requests')
            .doc(uid)
            .set({
          'uid': uid,
          'pending': true,
          'accepted': false,
          'block': false,
          'swiped': true,
        }, SetOptions(merge: true));
      } catch (e) {
        print('Error updating requests: $e');
      }

      for (int i = 0; i < _filteredUsers.length; i++) {
        print(_filteredUsers[i].name.toString());
      }
    } else {
      // Handle other swipe activities if needed
    }
  }

  void _onEnd() {
    log('end reached!');
  }
}

class UserData {
  final String uid;
  final String name;
  final String? photoUrl;

  UserData({
    required this.uid,
    required this.name,
    this.photoUrl,
  });

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      photoUrl: map['photoUrl'] ??
          '', // Provide a default value or handle null appropriately
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: GymBuddy(),
  ));
}
