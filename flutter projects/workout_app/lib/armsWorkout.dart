import 'package:flutter/material.dart';

class ArmsWorkout extends StatelessWidget {
  const ArmsWorkout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Arms Workout'),
      ),
      body: ListView(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.network(
                  'https://images.unsplash.com/photo-1581009146145-b5ef050c2e1e?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
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
                  'Benefits of Arms Workouts',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Arms workouts help strengthen and tone the muscles in your upper body, including the biceps, triceps, and shoulders. Building arm strength contributes to better functional movement, enhances athletic performance, and adds definition to your arms.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                Text(
                  'Getting Started with Arms Workouts',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "If you're new to arms workouts, begin with basic exercises like bicep curls, tricep dips, and shoulder presses. Use proper form to target the intended muscles and avoid strain. Gradually increase resistance and explore different exercises for variety.",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                Text(
                  'Sample Arms Exercises',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '1. Bicep Curls\n2. Tricep Dips\n3. Shoulder Press\n4. Hammer Curls\n5. Tricep Kickbacks',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                Text(
                  'Tips for Effective Arms Workouts',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '1. Warm up before engaging in arms exercises.\n2. Use proper weight and resistance for your fitness level.\n3. Focus on controlled movements for each repetition.\n4. Incorporate both pushing and pulling exercises for balanced development.\n5. Allow time for rest and recovery between arm workout sessions.',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
