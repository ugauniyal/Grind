import 'package:flutter/material.dart';

class Endurance extends StatelessWidget {
  const Endurance({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Endurance Training'),
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
                  'https://images.pexels.com/photos/3775164/pexels-photo-3775164.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
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
                  'Benefits of Endurance Training',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Endurance training, also known as aerobic or cardiovascular training, provides numerous health benefits. It improves cardiovascular health, boosts lung capacity, enhances overall stamina, and helps with weight management. Endurance training is essential for activities that require sustained effort over an extended period.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                Text(
                  'Types of Endurance Exercises',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '1. Running\n2. Cycling\n3. Swimming\n4. Rowing\n5. Jumping Rope\n6. Dancing\n7. Brisk Walking\n8. Cross-Country Skiing',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                Text(
                  'Tips for Improving Endurance',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '1. Gradual Progression: Start with manageable durations and gradually increase the intensity and duration of your workouts.\n2. Consistent Training: Regular and consistent training is key to building and maintaining endurance.\n3. Mix It Up: Include a variety of endurance exercises to engage different muscle groups and prevent boredom.\n4. Proper Nutrition: Fuel your body with a balanced diet to support energy levels and recovery.\n5. Hydration: Stay well-hydrated before, during, and after your endurance workouts.\n6. Adequate Rest: Ensure proper rest and recovery between sessions to prevent overtraining and reduce the risk of injuries.',
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
