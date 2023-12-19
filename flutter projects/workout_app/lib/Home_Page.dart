import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:workout_app/Chat_Page.dart';
import 'package:workout_app/GymProfile.dart';
import 'package:workout_app/sideBar.dart';

// Function to determine the star color based on the rating
Color _getStarColor(double rating) {
  if (rating >= 4.0) {
    return Colors.green;
  } else if (rating >= 3.0 && rating < 4.0) {
    return Colors.lightGreen;
  } else if (rating >= 2.0 && rating < 3.0) {
    return Colors.yellow;
  } else {
    return Colors.red;
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentIndex1 = 0;
  double rating = 3.2;
  bool _isMounted = false;
  late List<DocumentSnapshot> gymData = [];

  late double userLatitude;
  late double userLongitude;

  List<Widget> gymPhotos = [
    Image.asset('assets/images/gym1.jpg'),
    Image.asset('assets/images/gym2.jpg'),
    Image.asset('assets/images/gym3.jpg')
  ];

  Position? _currentLocation;
  String _currentAddress = '';
  late bool servicePermission = false;
  late LocationPermission permission;

  @override
  void initState() {
    super.initState();
    fetchGymData();
    _isMounted = true;
    _getCurrentLocation().then((position) {
      if (_isMounted) {
        setState(() {
          _currentLocation = position;
        });
      }
    }).catchError((e) {
      print("Error getting location: $e");
    });

    userLongitude = 0.0;
    userLatitude = 0.0;
    getCurrentUserLocation();
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  Future<void> fetchGymData() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('gyms').get();

    setState(() {
      gymData = querySnapshot.docs;
    });
  }

  Future<void> saveLocationToFirebase(double latitude, double longitude) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    String? uid = currentUser?.uid;

    // Reference to the user's document in the 'users' collection
    DocumentReference userDocRef =
        FirebaseFirestore.instance.collection('users').doc(uid);

    // Use set with SetOptions(merge: true) to update or create fields
    await userDocRef.set({
      'latitude': latitude,
      'longitude': longitude,
    }, SetOptions(merge: true));

    print(
        "Location saved to Firebase: Latitude - $latitude, Longitude - $longitude");
  }

  Future<dynamic> _getCurrentLocation() async {
    servicePermission = await Geolocator.isLocationServiceEnabled();
    if (!servicePermission) {
      print("Service disabled");
      // Show a dialog or message informing the user to enable location services
      // You can use showDialog or any other method to display a message
      return Future.error("Location services are disabled.");
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Permission is not granted, request it
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permission still not granted, handle accordingly
        // You can show a dialog or message to inform the user about the need for location permission
        return Future.error("Location permission denied.");
      }
    }

    // Clear old location
    setState(() {
      _currentLocation = null;
    });

    Position position;
    try {
      // Request location after permission is granted
      position = await Geolocator.getCurrentPosition();
      print("Latitude: ${position.latitude}, Longitude: ${position.longitude}");
      await saveLocationToFirebase(position.latitude, position.longitude);

      // Update the state with the new location
      setState(() {
        _currentLocation = position;
      });
    } catch (e) {
      print("Error getting location: $e");
      throw Exception("Error getting location: $e");
    }
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
    const double earthRadius = 6371; // Radius of the Earth in kilometers

    // Convert degrees to radians
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
    bool anyGymWithin10Kms = gymData.any((gym) {
      double distance = calculateDistance(
        userLatitude,
        userLongitude,
        gym['latitude'] as double,
        gym['longitude'] as double,
      );
      return distance <= 10.0;
    });

    return Scaffold(
      extendBodyBehindAppBar: false,
      drawer: const NavBar(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Container(
          padding: EdgeInsets.zero,
          child: Text('Grind', style: TextStyle(fontSize: 30)),
        ),
        centerTitle: true,
        primary: false,
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => ChatPage()));
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: ClipOval(
                child: Icon(
                  Icons.chat,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.brown,
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: Colors.white, // Choose the color of the border
                    width: 2.0, // Adjust the width of the border as needed
                  ),
                ),
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white, // Choose the color of the border
                        width: 2.0, // Adjust the width of the border as needed
                      ),
                      borderRadius:
                          BorderRadius.circular(8.0), // Adjust as needed
                    ),
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(6.0), // Adjust as needed
                      child: Image.network(
                        'https://media.tenor.com/RqZd0DYvLg8AAAAM/sam-sulek.gif',
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: Text("Gyms Near your location")),
            ),
            if (anyGymWithin10Kms)
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  var gym = gymData[index].data() as Map<String, dynamic>;
                  double distance = calculateDistance(
                    userLatitude,
                    userLongitude,
                    gym['latitude'] as double,
                    gym['longitude'] as double,
                  );
                  rating = (gym['rating'] ?? 0).toDouble();

                  if (distance <= 10.0) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  GymDetailsPage(gymData: gym),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 10,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(16),
                                  topLeft: Radius.circular(16),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16.0),
                                    color: Colors.white,
                                  ),
                                  child: Image.network(
                                    gym['gym_photo1'],
                                    height: 250,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, top: 8, bottom: 6.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      gym['name'],
                                      style: TextStyle(
                                        fontFamily: "TextName",
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: _getStarColor(rating),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Row(
                                          children: [
                                            Center(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0),
                                                child: Icon(
                                                  Icons.star,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                            Center(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 3.0, right: 10.0),
                                                child: Text(
                                                  rating.toString(),
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w200,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 11),
                                child: Text(
                                  '${gym['gym_services']}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 11),
                                child:
                                    userLatitude != 0.0 && userLongitude != 0.0
                                        ? Text(
                                            '${distance.toStringAsFixed(1)} kms away',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                              fontFamily: 'TextFamily',
                                              color: Colors.grey,
                                            ),
                                          )
                                        : Container(),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 11, bottom: 7),
                                child: Text(
                                  'Memberships: ${gym['Memberships']}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    fontFamily: 'TextFamily',
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 11),
                                child: Text(
                                  '${gym['description']}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              // ... other card contents ...
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    // This case should not be reached since we've filtered gyms before entering the builder
                    return Container();
                  }
                },
                itemCount: gymData.length,
              )
            else
              Center(
                child: Container(
                  child: Text("No gym available near you :("),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
