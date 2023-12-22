import 'package:flutter/material.dart';

class PushWorkout extends StatelessWidget {
  const PushWorkout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Push Workout'),
      ),
      body: ListView(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0), // Adjust the padding as needed
              child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(12.0), // Adjust the radius as needed
                child: Image.network(
                  'https://images.pexels.com/photos/4803734/pexels-photo-4803734.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'What is a Push Workout?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'A push workout primarily targets the muscles involved in pushing movements. These workouts focus on the muscles of the chest, shoulders, and triceps. The goal is to perform exercises that involve pushing weight away from the body, promoting strength and muscle development.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                Text(
                  'Exercises in a Push Workout',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '1. Bench Press\n2. Shoulder Press\n3. Push-Ups\n4. Dumbbell Flyes\n5. Tricep Dips\n6. Overhead Dumbbell Press\n7. Incline Bench Press\n8. Tricep Kickbacks',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                Text(
                  'Tips for an Effective Push Workout',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '1. Warm-Up: Always start with a dynamic warm-up to prepare your muscles for the workout.\n2. Proper Form: Focus on maintaining proper form throughout each exercise to prevent injuries.\n3. Progressive Overload: Gradually increase the weight or resistance to challenge your muscles and promote growth.\n4. Rest Between Sets: Allow adequate rest between sets to maximize strength and performance.\n5. Balanced Routine: Include a variety of push exercises to target different muscle groups within the chest, shoulders, and triceps.\n6. Cool Down: Finish with stretching to enhance flexibility and aid in recovery.',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          // Image.asset(
          //   'assets/push_workout_image2.jpg', // Replace with your image asset path
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
