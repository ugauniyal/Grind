import 'dart:async';
import 'dart:math';

import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class GymBuddy extends StatefulWidget {
  const GymBuddy({super.key});

  @override
  _GymBuddyState createState() => _GymBuddyState();
}

class _GymBuddyState extends State<GymBuddy> {
  final AppinioSwiperController controller = AppinioSwiperController();
  late User _user;
  List<UserData> _filteredUsers = [];
  String? viewPhotoUrl;
  final bool _loadingMoreUsers = false;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
      _requestsSubscription;
  late double userLatitude;
  late double userLongitude;

  late bool servicePermission = false;
  late LocationPermission permission;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
    _loadFilteredUsers();
    userLongitude = 0.0;
    userLatitude = 0.0;
    getCurrentUserLocation();
  }

  @override
  void dispose() {
    // Cancel the subscription to avoid memory leaks
    _requestsSubscription?.cancel();
    super.dispose();
  }

  List<String> interestList = [];

  getData(int index) {
    try {
      dynamic interestsData = _filteredUsers[index].interests;
      print(interestsData);

      if (interestsData is List<dynamic>) {
        List<String> userInterestList =
            interestsData.map((interest) => interest.toString()).toList();

        setState(() {
          interestList = userInterestList;
        });
      } else {
        print('Invalid format for interests data.');
      }
    } catch (e) {
      print('Error retrieving data: $e');
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Future<bool> _getCurrentLocation() async {
  //   servicePermission = await Geolocator.isLocationServiceEnabled();
  //   if (!servicePermission) {
  //     print("Service disabled");
  //     // Show a dialog or message informing the user to enable location services
  //     // You can use showDialog or any other method to display a message
  //     return false;
  //   }
  //
  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     // Permission is not granted, request it
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       return false;
  //     }
  //   }
  //   return true;
  // }

  Future<bool> permissionCheck() async {
    PermissionStatus LocationStatus = await Permission.location.request();

    if (LocationStatus == PermissionStatus.granted) {
      return true;
    } else if (LocationStatus == PermissionStatus.denied) {
      return false;
    } else if (LocationStatus == PermissionStatus.permanentlyDenied) {
      openAppSettings();
      return false;
    }
    return true;
  }

  Future<void> _loadFilteredUsers() async {
    DocumentSnapshot<Map<String, dynamic>> currentUserSnapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_user.uid)
            .get();

    QuerySnapshot<Map<String, dynamic>> requestsSnapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_user.uid)
            .collection('requests')
            .get();

    List<String> swipedUserIds = requestsSnapshot.docs
        .where((userDoc) => userDoc['swiped'] == true)
        .map((swipedUserDoc) => swipedUserDoc.id)
        .toList();

    // Query all users excluding the swiped ones and the logged-in user
    QuerySnapshot<Map<String, dynamic>> allUsersSnapshot =
        await FirebaseFirestore.instance.collection('users').get();

    _filteredUsers = allUsersSnapshot.docs
        .where((userDoc) =>
            !swipedUserIds.contains(userDoc.id) &&
            userDoc.id != _user.uid &&
            _isWithinBuddyRadius(userDoc, currentUserSnapshot))
        .map((userDoc) => UserData.fromMap(userDoc.data()))
        .toList();

    setState(() {
      _filteredUsers = _filteredUsers;
    });
  }

  bool _isWithinBuddyRadius(QueryDocumentSnapshot<Map<String, dynamic>> userDoc,
      DocumentSnapshot<Map<String, dynamic>> currentUser) {
    double filteredUserLatitude = userDoc['latitude'];
    double filteredUserLongitude = userDoc['longitude'];

    double userLatitude = currentUser['latitude'];
    double userLongitude = currentUser['longitude'];

    double distance = calculateDistance(
      userLatitude,
      userLongitude,
      filteredUserLatitude,
      filteredUserLongitude,
    );

    double buddyRadius = currentUser['buddyRadius'];

    return distance <= buddyRadius;
  }

  Future<void> getCurrentUserLocation() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      try {
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();

        double latitude = userSnapshot['latitude'];
        double longitude = userSnapshot['longitude'];

        setState(() {
          userLatitude = latitude;
          userLongitude = longitude;
        });

        print(
            'Current User Location: Latitude - $latitude, Longitude - $longitude');
      } catch (e) {
        print('Error retrieving user location: $e');
      }
    } else {
      print('User not signed in.');
    }
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371;

    double dLat = _degreesToRadians(lat2 - lat1);
    double dLon = _degreesToRadians(lon2 - lon1);

    // Haversine formula
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    // Distance in kilometers
    double distance = earthRadius * c;

    return distance;
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: permissionCheck(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == true) {
            // User has granted location permission
            return Scaffold(
              body: _filteredUsers.isNotEmpty
                  ? AppinioSwiper(
                      controller: controller,
                      cardCount: _filteredUsers.length,
                      onSwipeEnd: _swipeEnd,
                      onEnd: _onEnd,
                      swipeOptions:
                          const SwipeOptions.only(left: true, right: true),
                      cardBuilder: (BuildContext context, int index) {
                        String userDob = _filteredUsers[index].age;
                        DateTime userAge = DateTime.parse(userDob);
                        DateTime currentDate = DateTime.now();
                        int age = currentDate.year - userAge.year;
                        if (currentDate.month < userAge.month ||
                            currentDate.month == userAge.month &&
                                currentDate.day < userAge.day) {
                          age--;
                        }
                        double cardHeight =
                            MediaQuery.of(context).size.height * 0.6;
                        String allInterests =
                            _filteredUsers[index].interests.join(', ');

                        // Retrieve latitude and longitude of the filtered user
                        double filteredUserLatitude =
                            _filteredUsers[index].latitude;
                        double filteredUserLongitude =
                            _filteredUsers[index].longitude;

                        // Calculate distance between logged-in user and filtered user
                        double distance = calculateDistance(
                          userLatitude,
                          userLongitude,
                          filteredUserLatitude,
                          filteredUserLongitude,
                        );

                        return Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(_filteredUsers[index].name),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('$age years'),
                                    Text(_filteredUsers[index].bio),

                                    // Display all interests in a single line
                                    if (_filteredUsers[index]
                                        .interests
                                        .isNotEmpty)
                                      Text('Interests: $allInterests'),

                                    // Display the distance between logged-in user and filtered user
                                    Text(
                                        'Distance: ${distance.toStringAsFixed(2)} km'),
                                  ],
                                ),
                              ),

                              // Display the user image using CachedNetworkImage
                              FutureBuilder<String>(
                                future:
                                    _getUserImage(_filteredUsers[index].uid),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    return CachedNetworkImage(
                                      imageUrl: snapshot.data ??
                                          'https://moorepediatricnc.com/wp-content/uploads/2022/08/default_avatar.jpg',
                                      height: cardHeight,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          const Center(
                                        child: Text('Loading'),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const Text('Error loading image'),
                                    );
                                  } else if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: Text('Loading'),
                                    );
                                  } else {
                                    return const Text('Error loading image');
                                  }
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  : _loadingMoreUsers
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 8),
                              Text('Loading more users...'),
                            ],
                          ),
                        )
                      : const Center(
                          child: Text('Loading'),
                        ),
            );
          } else {
            // User has not granted location permission
            return Scaffold(
              body: Container(
                child: Center(
                  child: Text(
                      "Please allow location permissions in your app settings"),
                ),
              ),
            );
          }
        } else {
          return Scaffold(
            body: Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
      },
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
    String? uid = _user.uid;

    if (activity is Swipe) {
      if (activity.direction == AxisDirection.right) {
        try {
          // Create or update the request collection for the logged-in user
          await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .collection('requests')
              .doc(_filteredUsers[previousIndex].uid)
              .set({
            'uid': _filteredUsers[previousIndex].uid,
            'pending': false,
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
      } else {
        try {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .collection('requests')
              .doc(_filteredUsers[previousIndex].uid)
              .set({
            'uid': _filteredUsers[previousIndex].uid,
            'pending': false,
            'accepted': false,
            'block': false,
            'swiped': true,
          }, SetOptions(merge: true));

          await FirebaseFirestore.instance
              .collection('users')
              .doc(_filteredUsers[previousIndex].uid)
              .collection('requests')
              .doc(uid)
              .set({
            'uid': uid,
            'pending': false,
            'accepted': false,
            'block': false,
            'swiped': true,
          }, SetOptions(merge: true));
        } catch (e) {
          print('Error updating requests: $e');
        }
      }
      print('The card was swiped to the : ${activity.direction}');
      print('previous index: $previousIndex, target index: $targetIndex');

      for (int i = 0; i < _filteredUsers.length; i++) {
        print(_filteredUsers[i].name.toString());
      }
    } else {}
  }

  void _onEnd() {
    Container(
      child: const Text("We have no gym buddies left to show you"),
    );
  }
}

class UserData {
  final String uid;
  final String name;
  final String age;
  final String? photoUrl;
  final String bio;
  final double latitude;
  final double longitude;

  final List<String> interests;
  UserData({
    required this.uid,
    required this.name,
    required this.age,
    required this.bio,
    this.photoUrl,
    required this.longitude,
    required this.latitude,
    required this.interests,
  });

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      age: map['age'] ?? '',
      bio: map['bio'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
      latitude: map['latitude'] ?? 0.0,
      longitude: map['longitude'] ?? 0.0,
      interests: List<String>.from(map['interests'] ?? []),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: GymBuddy(),
  ));
}
