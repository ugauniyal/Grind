import 'package:flutter/material.dart';

class Cardio extends StatelessWidget {
  const Cardio({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cardio Workouts'),
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
                  'https://images.pexels.com/photos/853247/pexels-photo-853247.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
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
                  'Benefits of Cardio Workouts',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Cardiovascular exercises, commonly known as cardio, offer a wide range of health benefits. Regular cardio workouts improve heart health, enhance lung capacity, aid in weight management, boost mood, and increase overall energy levels.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                Text(
                  'Types of Cardio Exercises',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '1. Running\n2. Cycling\n3. Jump Rope\n4. Swimming\n5. High-Intensity Interval Training (HIIT)\n6. Dancing\n7. Rowing\n8. Elliptical Training',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                Text(
                  'Tips for Effective Cardio Workouts',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '1. Start Slow: Begin with a warm-up to prepare your body for more intense activity.\n2. Set Goals: Establish clear and achievable goals for your cardio workouts.\n3. Mix It Up: Vary your cardio exercises to prevent boredom and target different muscle groups.\n4. Stay Hydrated: Drink water before, during, and after your workout.\n5. Listen to Your Body: Pay attention to how your body feels and adjust intensity accordingly.\n6. Include Recovery: Allow time for rest and recovery to prevent overtraining.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                Text(
                  'Creating a Cardio Workout Routine',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Design a well-rounded cardio workout routine by incorporating a mix of aerobic exercises. Consider duration, intensity, and frequency based on your fitness level and goals. Gradually increase the challenge to keep progressing.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                Text(
                  'Consistency is Key',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Consistency is crucial for reaping the benefits of cardio workouts. Aim for a regular exercise schedule, whether it's a few times a week or daily. Consistent effort over time leads to lasting health improvements.",
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
