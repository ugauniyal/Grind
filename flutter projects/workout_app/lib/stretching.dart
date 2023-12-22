import 'package:flutter/material.dart';

class Stretching extends StatelessWidget {
  const Stretching({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stretching Exercises'),
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
                  'https://images.pexels.com/photos/3766217/pexels-photo-3766217.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
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
                  'Benefits of Stretching',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Incorporating stretching into your routine offers various benefits. Stretching helps improve flexibility, increases range of motion, reduces muscle tension, enhances circulation, and promotes better posture. It is an essential component for overall muscle and joint health.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                Text(
                  'Types of Stretches',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '1. Static Stretching: Holding a stretch position for a prolonged period to elongate the muscle.\n2. Dynamic Stretching: Incorporating controlled, active movements to improve flexibility and increase blood flow.\n3. PNF (Proprioceptive Neuromuscular Facilitation): A more advanced stretching technique involving a combination of contraction and relaxation phases.\n4. Ballistic Stretching: Involves bouncing or swinging movements to increase muscle length.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                Text(
                  'Tips for Effective Stretching',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '1. Warm-Up First: Always warm up your body with light aerobic activity before stretching.\n2. Target Major Muscle Groups: Focus on stretching major muscle groups to improve overall flexibility.\n3. Hold Each Stretch: Hold static stretches for 15-30 seconds; avoid bouncing.\n4. Breathe: Remember to breathe deeply and consistently during each stretch.\n5. Gradual Progression: Start with easier stretches and gradually progress to more advanced ones.\n6. Consistency is Key: Incorporate stretching into your routine regularly for long-term benefits.',
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
