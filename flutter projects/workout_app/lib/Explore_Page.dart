import 'package:flutter/material.dart';
import 'package:workout_app/BottomNagivationBar.dart';
import 'package:workout_app/Cardio.dart';
import 'package:workout_app/Endurance.dart';
import 'package:workout_app/PullWorkout.dart';
import 'package:workout_app/Yoga.dart';
import 'package:workout_app/hiit.dart';
import 'package:workout_app/pushWorkout.dart';
import 'package:workout_app/strengthTraining.dart';
import 'package:workout_app/stretching.dart';

import 'armsWorkout.dart';
import 'legWorkout.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Handle back button press
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) =>
                  const Nav()), // Replace HomePage with your actual home page widget
        );
        return false; // Returning false prevents the default back button behavior
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Explore Page"),
        ),
        // appBar: AppBar(
        //   title: TextField(
        //     style: TextStyle(color: Colors.black),
        //     decoration: InputDecoration(
        //       hintText: "Search...",
        //       hintStyle: TextStyle(color: Colors.grey),
        //       prefixIcon: Padding(
        //         padding: EdgeInsets.all(10.0),
        //         child: Icon(Icons.search, color: Colors.grey),
        //       ),
        //       suffixIcon: Padding(
        //         padding: EdgeInsets.all(10.0),
        //         child: Icon(Icons.clear, color: Colors.grey),
        //       ),
        //       contentPadding:
        //           EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
        //       border: OutlineInputBorder(
        //         borderRadius: BorderRadius.circular(30.0),
        //         borderSide: BorderSide.none,
        //       ),
        //       filled: true,
        //       fillColor: Colors.white,
        //       focusedBorder: OutlineInputBorder(
        //         borderRadius: BorderRadius.circular(30.0),
        //         borderSide: BorderSide(color: Colors.blue, width: 2.0),
        //       ),
        //     ),
        //   ),
        //   automaticallyImplyLeading: false,
        // ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                            image: NetworkImage(
                              'https://images.pexels.com/photos/1431282/pexels-photo-1431282.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
                            ),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const StrengthTraining()),
                            );
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(16),
                            backgroundColor: Colors
                                .transparent, // Set transparent background
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation:
                                0, // Set elevation to 0 to remove button shadow
                          ),
                          child: Center(
                            child: Text(
                              'Strength Training',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.5),
                                    offset: const Offset(3, 3),
                                    blurRadius: 5,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                            image: NetworkImage(
                              'https://images.pexels.com/photos/3758056/pexels-photo-3758056.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
                            ),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Yoga()),
                            );
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(16),
                            backgroundColor: Colors
                                .transparent, // Set transparent background
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation:
                                0, // Set elevation to 0 to remove button shadow
                          ),
                          child: Center(
                            child: Text(
                              'Yoga',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.5),
                                    offset: const Offset(3, 3),
                                    blurRadius: 5,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                            image: NetworkImage(
                              'https://images.pexels.com/photos/4429101/pexels-photo-4429101.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
                            ),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Cardio()),
                            );
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(16),
                            backgroundColor: Colors
                                .transparent, // Set transparent background
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation:
                                0, // Set elevation to 0 to remove button shadow
                          ),
                          child: Center(
                            child: Text(
                              'Cardio',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.5),
                                    offset: const Offset(3, 3),
                                    blurRadius: 5,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                            image: NetworkImage(
                              'https://hips.hearstapps.com/hmg-prod/images/athletes-doing-push-ups-with-dumbbells-on-floor-royalty-free-image-1638463573.jpg?crop=1xw:0.84375xh;center,top&resize=1200:*',
                            ),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Hiit()),
                            );
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(16),
                            backgroundColor: Colors
                                .transparent, // Set transparent background
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation:
                                0, // Set elevation to 0 to remove button shadow
                          ),
                          child: Center(
                            child: Text(
                              'HIIT',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.5),
                                    offset: const Offset(3, 3),
                                    blurRadius: 5,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                            image: NetworkImage(
                              'https://images.pexels.com/photos/4473608/pexels-photo-4473608.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
                            ),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Stretching()),
                            );
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(16),
                            backgroundColor: Colors
                                .transparent, // Set transparent background
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation:
                                0, // Set elevation to 0 to remove button shadow
                          ),
                          child: Center(
                            child: Text(
                              'Stretching',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.5),
                                    offset: const Offset(3, 3),
                                    blurRadius: 5,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                            image: NetworkImage(
                              'https://images.pexels.com/photos/6998744/pexels-photo-6998744.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
                            ),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Endurance()),
                            );
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(16),
                            backgroundColor: Colors
                                .transparent, // Set transparent background
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation:
                                0, // Set elevation to 0 to remove button shadow
                          ),
                          child: Center(
                            child: Text(
                              'Endurance',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.5),
                                    offset: const Offset(3, 3),
                                    blurRadius: 5,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                            image: NetworkImage(
                              'https://images.pexels.com/photos/1199607/pexels-photo-1199607.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
                            ),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const PushWorkout()),
                            );
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(16),
                            backgroundColor: Colors
                                .transparent, // Set transparent background
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation:
                                0, // Set elevation to 0 to remove button shadow
                          ),
                          child: Center(
                            child: Text(
                              'Push Workout',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.5),
                                    offset: const Offset(3, 3),
                                    blurRadius: 5,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                            image: NetworkImage(
                              'https://images.pexels.com/photos/3838290/pexels-photo-3838290.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
                            ),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const PullWorkout()),
                            );
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(16),
                            backgroundColor: Colors
                                .transparent, // Set transparent background
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation:
                                0, // Set elevation to 0 to remove button shadow
                          ),
                          child: Center(
                            child: Text(
                              'Pull Workout',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.5),
                                    offset: const Offset(3, 3),
                                    blurRadius: 5,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                            image: NetworkImage(
                              'https://images.unsplash.com/photo-1434682772747-f16d3ea162c3?q=80&w=2074&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                            ),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LegWorkout()),
                            );
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(16),
                            backgroundColor: Colors
                                .transparent, // Set transparent background
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation:
                                0, // Set elevation to 0 to remove button shadow
                          ),
                          child: Center(
                            child: Text(
                              'Leg Workout',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.5),
                                    offset: const Offset(3, 3),
                                    blurRadius: 5,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                            image: NetworkImage(
                              'https://images.unsplash.com/photo-1621750627159-cf77b0b91aac?q=80&w=1931&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                            ),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ArmsWorkout()),
                            );
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(16),
                            backgroundColor: Colors
                                .transparent, // Set transparent background
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation:
                                0, // Set elevation to 0 to remove button shadow
                          ),
                          child: Center(
                            child: Text(
                              'Arms Workout',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.5),
                                    offset: const Offset(3, 3),
                                    blurRadius: 5,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
