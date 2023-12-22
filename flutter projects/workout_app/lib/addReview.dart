import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddReviewWidget extends StatefulWidget {
  final Map<String, dynamic> gymData;

  const AddReviewWidget({super.key, required this.gymData});

  @override
  _AddReviewWidgetState createState() => _AddReviewWidgetState();
}

class _AddReviewWidgetState extends State<AddReviewWidget> {
  double _rating = 0.0;
  final TextEditingController _reviewController = TextEditingController();

  User? currentUser = FirebaseAuth.instance.currentUser;

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> calculateAverageRating() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('gyms')
          .doc(widget.gymData['gymId'])
          .collection('reviews')
          .get();

      List<Map<String, dynamic>> reviews = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      if (reviews.isNotEmpty) {
        double sum = 0;
        for (var review in reviews) {
          sum += review['rating'];
        }

        double avgRating = sum / reviews.length;

        // Update the Firestore document with the new rating
        await FirebaseFirestore.instance
            .collection('gyms')
            .doc(widget.gymData['gymId'])
            .update({'rating': avgRating});
      }
    } catch (e) {
      print('Error calculating and updating average rating: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add a Review'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Text('Rating: '),
              Slider(
                value: _rating,
                onChanged: (value) {
                  setState(() {
                    _rating = value;
                  });
                },
                min: 0.0,
                max: 5.0,
                divisions: 5,
                label: _rating.toString(),
              ),
            ],
          ),
          TextField(
            controller: _reviewController,
            decoration: const InputDecoration(
              labelText: 'Review',
            ),
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            if (currentUser != null) {
              String uid = currentUser!.uid;

              try {
                // Get the username from the 'users' collection
                DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
                    .collection('users')
                    .doc(uid)
                    .get();

                String? username = userSnapshot['username'];
                String? userPhoto = userSnapshot['downloadUrl'];

                // Your logic to add the review to the Firestore collection
                await FirebaseFirestore.instance
                    .collection('gyms')
                    .doc(widget.gymData['gymId'])
                    .collection('reviews')
                    .doc(uid)
                    .set({
                  'userId': uid,
                  'rating': _rating,
                  'review': _reviewController.text,
                  'username': username,
                  'userPhoto': userPhoto,
                  'timestamp': FieldValue.serverTimestamp(),
                });
                calculateAverageRating();
                _showSnackbar("Review Submitted");
                Navigator.pop(context);
              } catch (e) {
                print('Error getting user information: $e');
              }
            }
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
