import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddReviewWidget extends StatefulWidget {
  final Map<String, dynamic> gymData;

  AddReviewWidget({required this.gymData});

  @override
  _AddReviewWidgetState createState() => _AddReviewWidgetState();
}

class _AddReviewWidgetState extends State<AddReviewWidget> {
  double _rating = 0.0;
  TextEditingController _reviewController = TextEditingController();

  User? currentUser = FirebaseAuth.instance.currentUser;

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add a Review'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text('Rating: '),
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
            decoration: InputDecoration(
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
          child: Text('Cancel'),
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

                _showSnackbar("Review Submitted");
                Navigator.pop(context);
              } catch (e) {
                print('Error getting user information: $e');
              }
            }
          },
          child: Text('Submit'),
        ),
      ],
    );
  }
}
