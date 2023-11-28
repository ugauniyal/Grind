import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workout_app/chatDmUI.dart';

import 'BottomNagivationBar.dart';

void main() {
  runApp(ChatPage());
}

class ChatPage extends StatefulWidget {
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;

  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    // Display all the users except the current user
    if (_auth.currentUser!.email != data['email']) {
      return GestureDetector(
        onTap: () {
          // Handle tap event, navigate to ChatDmUI
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatDmUI(
                receiverUserUsername:
                    data['username'], // replace with the correct field
                receiverUserID: data['uid'], // replace with the correct field
                profilePicUrl:
                    data['downloadUrl'], // replace with the correct field
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                  data['downloadUrl'] ??
                      'https://moorepediatricnc.com/wp-content/uploads/2022/08/default_avatar.jpg',
                ),
              ),
              SizedBox(width: 18),
              Text(
                data['name'],
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 60, // Adjust the height between each user row
              ),
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  // Show the list of all users except the logged in user.
  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
        // Get all the users from firestore users collection.
        stream: FirebaseFirestore.instance.collection('users').snapshots(),

        // List of all the users.
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('error');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('loading');
          }

          return ListView(
            children: snapshot.data!.docs
                .map<Widget>((doc) => _buildUserListItem(doc))
                .toList(),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.white,
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => Nav())),
        ),
        title: Text(
          'Contacts',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
        backgroundColor: Colors.black,
      ),
      body: _buildUserList(),
    );
  }
}

class ContactCard extends StatefulWidget {
  final String name;
  final String imagePath;

  ContactCard({required this.name, required this.imagePath});

  @override
  State<ContactCard> createState() => _ContactCardState();
}

class _ContactCardState extends State<ContactCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChatDmUI(
                    receiverUserUsername: '',
                    receiverUserID: '',
                    profilePicUrl: '',
                  )),
        );
      },
      child: Card(
        color: Colors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage(widget.imagePath),
          ),
          title: Text(
            widget.name,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text('Last message preview'),
          trailing: Icon(Icons.arrow_forward),
        ),
      ),
    );
  }
}
