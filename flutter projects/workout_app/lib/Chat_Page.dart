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
  User? user = FirebaseAuth.instance.currentUser;

  Future<String> _getFriendUid(DocumentSnapshot document) async {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    return data['uid'].toString();
  }

  Future<Map<String, dynamic>> _getUserData(String friendUid) async {
    CollectionReference userCollection =
        FirebaseFirestore.instance.collection('users');
    DocumentSnapshot userDocument = await userCollection.doc(friendUid).get();
    return userDocument.exists
        ? userDocument.data() as Map<String, dynamic>
        : {};
  }

  Widget _buildUserListItem(DocumentSnapshot document) {
    return FutureBuilder(
      future: _getFriendUid(document),
      builder: (context, friendUidSnapshot) {
        if (friendUidSnapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (friendUidSnapshot.hasError) {
          return Text('Error: ${friendUidSnapshot.error}');
        }

        String friendUid = friendUidSnapshot.data as String;

        return FutureBuilder(
          future: _getUserData(friendUid),
          builder: (context, userDataSnapshot) {
            if (userDataSnapshot.connectionState == ConnectionState.waiting) {
              return Text('loading');
            }

            if (userDataSnapshot.hasError) {
              return Text('Error: ${userDataSnapshot.error}');
            }

            Map<String, dynamic> userData =
                userDataSnapshot.data as Map<String, dynamic>;

            if (userData.isEmpty) {
              // User document does not exist
              return Container();
            }

            return GestureDetector(
              onTap: () {
                // Handle tap event, navigate to ChatDmUI
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatDmUI(
                      receiverUserUsername: userData['name'],
                      receiverUserID: friendUid,
                      profilePicUrl: userData['downloadUrl'] ??
                          'https://moorepediatricnc.com/wp-content/uploads/2022/08/default_avatar.jpg',
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
                        userData['downloadUrl'] ??
                            'https://moorepediatricnc.com/wp-content/uploads/2022/08/default_avatar.jpg',
                      ),
                    ),
                    SizedBox(width: 18),
                    Text(
                      userData['name'],
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
          },
        );
      },
    );
  }

  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .collection('requests')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading');
        }

        List<DocumentSnapshot> usersWithAcceptedRequests = snapshot.data!.docs;

        return ListView.builder(
          itemCount: usersWithAcceptedRequests.length,
          itemBuilder: (context, index) {
            DocumentSnapshot doc = usersWithAcceptedRequests[index];
            return _buildUserListItem(doc);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.white,
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Nav()),
          ),
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
