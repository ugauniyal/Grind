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

  List<Widget> gymPhotos = [
    Image.asset('assets/images/gym1.jpg'),
    Image.asset('assets/images/gym2.jpg'),
    Image.asset('assets/images/gym3.jpg')
  ];

  Position? _currentLocation;
  late bool servicePermission = false;
  late LocationPermission permission;

  @override
  void initState() {
    super.initState();
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
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
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
                  borderRadius:
                      BorderRadius.circular(10.0), // Adjust the value as needed
                ),
                child: Center(
                  child: Text(
                    'Think about this box',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GymDetailsPage(index + 1)),
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
                                topLeft: Radius.circular(16)),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.0),
                                color: Colors.white,
                              ),
                              child: gymPhotos[index],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10, top: 8, bottom: 6.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Gym ${index + 1}",
                                    style: TextStyle(
                                        fontFamily: "TextName",
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18)),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: _getStarColor(rating),
                                      borderRadius: BorderRadius.circular(5),
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
                              'Yoga • Zumba • Aerobics',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 11),
                            child: Text(
                              '2 kms away',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                fontFamily: 'TextFamily',
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 11, bottom: 7),
                            child: Text(
                              '₹1000/month',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                fontFamily: 'TextFamily',
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              itemCount: gymPhotos.length,
            ),
          ],
        ),
      ),
    );
  }
}
