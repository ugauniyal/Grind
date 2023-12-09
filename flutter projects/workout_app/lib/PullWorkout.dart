import 'package:flutter/material.dart';

class PullWorkout extends StatelessWidget {
  const PullWorkout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pull Workout'),
      ),
      body: ListView(
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.all(16.0), // Adjust the padding as needed
              child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(12.0), // Adjust the radius as needed
                child: Image.network(
                  'https://images.pexels.com/photos/5750626/pexels-photo-5750626.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'What is a Pull Workout?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'A pull workout primarily targets the muscles involved in pulling movements. These workouts focus on the muscles of the back, biceps, and rear shoulders. The goal is to perform exercises that involve pulling weight toward the body, promoting strength and muscle development.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                Text(
                  'Exercises in a Pull Workout',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '1. Pull-Ups\n2. Bent Over Rows\n3. Lat Pulldowns\n4. Face Pulls\n5. Deadlifts\n6. Bicep Curls\n7. Seated Cable Rows\n8. Hammer Curls',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                Text(
                  'Tips for an Effective Pull Workout',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '1. Warm-Up: Begin with a dynamic warm-up to prepare your muscles for the workout.\n2. Proper Form: Focus on maintaining proper form throughout each exercise to prevent injuries.\n3. Progressive Overload: Gradually increase the weight or resistance to challenge your muscles and promote growth.\n4. Balanced Routine: Include a variety of pull exercises to target different muscle groups within the back and biceps.\n5. Rest Between Sets: Allow adequate rest between sets to maximize strength and performance.\n6. Cool Down: Finish with stretching to enhance flexibility and aid in recovery.',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          // Image.asset(
          //   height: 200,
          //   width: double.infinity,
          //   fit: BoxFit.cover,
          // ),
          // Add more sections with text and images as needed
        ],
      ),
    );
  }
}
