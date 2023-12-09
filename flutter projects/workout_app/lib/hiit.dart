import 'package:flutter/material.dart';

class Hiit extends StatelessWidget {
  const Hiit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('High-Intensity Interval Training (HIIT)'),
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
                  'https://prod-ne-cdn-media.puregym.com/media/822906/hiit-workouts-for-men_blogheader-no-title.jpg?quality=80&width=992',
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
                  'Benefits of High-Intensity Interval Training (HIIT)',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'HIIT is a powerful workout method with various benefits. It helps burn calories, improve cardiovascular health, increase metabolic rate, and enhance overall fitness. HIIT workouts are known for their efficiency in delivering results in a shorter amount of time.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                Text(
                  'Structuring a HIIT Workout',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '1. Warm-Up: Begin with a dynamic warm-up to prepare your body for the intense workout ahead.\n2. Work and Rest Intervals: Alternate between high-intensity exercise and rest or lower-intensity periods. For example, 30 seconds of intense exercise followed by 30 seconds of rest.\n3. Exercise Selection: Choose compound exercises that engage multiple muscle groups for maximum efficiency.\n4. Reps and Sets: Structure your workout with a combination of exercises, reps, and sets based on your fitness level.\n5. Cool Down: Finish with a cooldown to help your heart rate return to normal and prevent muscle stiffness.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                Text(
                  'Tips for Effective HIIT Training',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '1. Start Gradually: If you are new to HIIT, start with shorter sessions and gradually increase the intensity.\n2. Listen to Your Body: Pay attention to how your body responds and modify the intensity or rest periods as needed.\n3. Include Variety: Keep your workouts dynamic by incorporating a variety of exercises.\n4. Stay Hydrated: HIIT can be intense, so ensure you stay well-hydrated throughout your workout.\n5. Recovery is Essential: Allow adequate time for recovery between HIIT sessions to prevent burnout and reduce the risk of injury.',
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
