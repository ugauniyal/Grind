import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'addReview.dart';

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

class GymDetailsPage extends StatefulWidget {
  // final int gymIndex;
  final Map<String, dynamic> gymData;

  const GymDetailsPage({super.key, 
    required this.gymData,
    required double updatedRating,
  });

  @override
  State<GymDetailsPage> createState() => _GymDetailsPageState();
}

class _GymDetailsPageState extends State<GymDetailsPage> {
  final String _currentAddress = '';
  bool _isMounted = false;
  double averageRating = 0.0;
  double _gymRating = 0.0;
  late double userLatitude;
  late double userLongitude;

  List<Map<String, dynamic>> reviews = [];

  // Future<void> _getAddressFromGymCoordinates() async {
  //   try {
  //     // Get latitude and longitude from gym data
  //     double gymLatitude = widget.gymData['latitude'];
  //     double gymLongitude = widget.gymData['longitude'];
  //     print('Latitude: $gymLatitude, Longitude: $gymLongitude');
  //
  //     List<Placemark> placemarks =
  //         await placemarkFromCoordinates(gymLatitude, gymLongitude);
  //
  //     Placemark place = placemarks[0];
  //
  //     setState(() {
  //       _currentAddress =
  //           '${place.administrativeArea},${place.subLocality},${place.locality}';
  //
  //     });
  //
  //     print(_currentAddress);
  //   } catch (e) {
  //     print(e);
  //   }
  // }\

  Future<void> _getGymRating() async {
    try {
      DocumentSnapshot gymSnapshot = await FirebaseFirestore.instance
          .collection('gyms')
          .doc(widget.gymData['gymId'])
          .get();

      double gymRating = gymSnapshot['rating'] ?? 0.0;

      setState(() {
        _gymRating = gymRating;
      });
    } catch (e) {
      print('Error getting gym rating: $e');
    }
  }

  Future<void> fetchReviews() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('gyms')
          .doc(widget.gymData[
              'gymId']) // Replace 'gymId' with the actual field in your gym data that represents the gym's ID
          .collection('reviews')
          .get();

      setState(() {
        reviews = querySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
      });
    } catch (e) {
      print('Error fetching reviews: $e');
    }
  }

  // Call _getAddressFromGymCoordinates in initState
  @override
  void initState() {
    super.initState();
    _isMounted = true;
    userLongitude = 0.0;
    userLatitude = 0.0;
    getCurrentUserLocation();
    fetchReviews();
    _getGymRating();
    // _getAddressFromGymCoordinates();
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  void openGoogleMaps(double latitude, double longitude) async {
    String googleMapsUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

    if (await canLaunchUrlString(googleMapsUrl)) {
      await launchUrlString(googleMapsUrl);
    } else {
      throw 'Could not launch $googleMapsUrl';
    }
  }

  Future<bool> hasUserReviewed() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      DocumentSnapshot userReview = await FirebaseFirestore.instance
          .collection('gyms')
          .doc(widget.gymData['gymId'])
          .collection('reviews')
          .doc(currentUser.uid)
          .get();

      return userReview.exists;
    }
    return false;
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
    double distance = calculateDistance(
      userLatitude,
      userLongitude,
      widget.gymData['latitude'],
      widget.gymData['longitude'],
    );
    String openHrs =
        (widget.gymData['opening_hrs'] as List<dynamic>).join(', ');
    String closeHrs =
        (widget.gymData['closing_hrs'] as List<dynamic>).join(', ');
    String memberships =
        (widget.gymData['Memberships'] as List<dynamic>).join(', ');
    if (widget.gymData == null) {
      return const Scaffold(
        body: Center(
          child: Text('Error: Gym data is null'),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Gym Details'),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gym Image Carousel
              CarouselSlider(
                options: CarouselOptions(
                  height: 200,
                  enlargeCenterPage: true,
                  autoPlay: true,
                  aspectRatio: 16 / 9,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  viewportFraction: 0.8,
                ),
                items: [
                  Image.network(widget.gymData['gym_photo1'],
                      fit: BoxFit.cover),
                  Image.network(widget.gymData['gym_photo2'],
                      fit: BoxFit.cover),
                  Image.network(widget.gymData['gym_photo3'],
                      fit: BoxFit.cover),
                ],
              ),
              const SizedBox(height: 16),

              // Gym Name and Rating
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.gymData['name'],
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: _getStarColor(_gymRating),
                        ),
                        Text(
                          _gymRating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Gym Location and Distance
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GestureDetector(
                  onTap: () {
                    openGoogleMaps(widget.gymData['latitude'],
                        widget.gymData['longitude']);
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.grey),
                      const SizedBox(width: 8),
                      const Text(
                        'Open in Maps',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const Spacer(),
                      if (userLatitude != 0.0 && userLongitude != 0.0)
                        Text(
                          '${distance.toStringAsFixed(1)} kms away',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // Gym Description
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  widget.gymData['description'],
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),

              // Additional Features (you can add more as needed)
              ListTile(
                leading: const Icon(Icons.access_time),
                title: const Text('Open Hours'),
                subtitle: Text(openHrs),
              ),

              // Additional Features (you can add more as needed)
              ListTile(
                leading: const Icon(Icons.access_time),
                title: const Text('Closing Hours'),
                subtitle: Text(closeHrs),
              ),

              ListTile(
                leading: const Icon(Icons.payment),
                title: const Text('Membership Fee'),
                subtitle: Text(memberships),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('gyms')
                      .doc(widget.gymData['gymId'])
                      .collection('reviews')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text("Loading...");
                    }

                    reviews = snapshot.data!.docs
                        .map((doc) => doc.data() as Map<String, dynamic>)
                        .toList();

                    bool hasUserReviewed = reviews.any((review) =>
                        review['userId'] ==
                        FirebaseAuth.instance.currentUser?.uid);

                    return Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Reviews (${reviews.length})',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (!hasUserReviewed)
                            ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AddReviewWidget(
                                        gymData: widget.gymData);
                                  },
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green, // Background color
                                textStyle: const TextStyle(color: Colors.white),
                              ),
                              child: const Text(
                                'Add Review',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                        ],
                      ),
                    ]);
                  },
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('gyms')
                    .doc(widget.gymData['gymId'])
                    .collection('reviews')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("Loading...");
                  }

                  reviews = snapshot.data!.docs
                      .map((doc) => doc.data() as Map<String, dynamic>)
                      .toList();

                  bool hasUserReviewed = reviews.any((review) =>
                      review['userId'] ==
                      FirebaseAuth.instance.currentUser?.uid);

                  return reviews.isEmpty
                      ? const Center(
                          child: Text(
                            'No reviews yet, be the first one to review!',
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: reviews.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Card(
                                elevation: 3,
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        reviews[index]['userPhoto'] ?? ''),
                                  ),
                                  title: Text(
                                    reviews[index]['username'] ?? '',
                                    style:
                                        const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons.star,
                                              color: Colors.yellow),
                                          Text(reviews[index]['rating']
                                                  .toString() ??
                                              ''),
                                        ],
                                      ),
                                      Text(reviews[index]['review'] ?? ''),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                },
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      );
    }
  }
}
