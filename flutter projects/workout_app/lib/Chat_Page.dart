import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'BottomNagivationBar.dart';
import 'chatDmUI.dart';

void main() {
  runApp(const ChatPage());
}

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  User? user = FirebaseAuth.instance.currentUser;

  //getting uid of friend users
  Future<String> _getFriendUid(DocumentSnapshot document) async {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    return data['uid'].toString();
  }

//building list items which will be displayed in chat page, each item contains photo and name
  Widget _buildUserListItem(DocumentSnapshot document) {
    return FutureBuilder(
      future: _getFriendUid(document),
      builder: (context, friendUidSnapshot) {
        if (friendUidSnapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading');
        }

        if (friendUidSnapshot.hasError) {
          return Text('Error: ${friendUidSnapshot.error}');
        }

        String friendUid = friendUidSnapshot.data as String;

        //Getting uids from requests collection which has uid,accepted,block,pending fields which defines the properties of friend
        return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(user?.uid)
              .collection('requests')
              .doc(friendUid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Error');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('Loading');
            }

            DocumentSnapshot<Map<String, dynamic>> requestSnapshot =
                snapshot.data as DocumentSnapshot<Map<String, dynamic>>;

            if (!requestSnapshot.exists) {
              // Request document doesn't exist, handle accordingly
              return Container();
            }

            //checking if conditions and only showing when the user is not blocked nor accepted

            bool isBlocked = requestSnapshot.data()?['block'] ?? false;
            bool isAccepted = requestSnapshot.data()?['accepted'] ?? false;

            //checking if the user is not blocked and accepted
            if (!isBlocked && isAccepted) {
              return _buildUserWidget(friendUid);
            } else {
              return Container();
            }
          },
        );
      },
    );
  }

  //retrieving data of user that are logged in user's friends
  Future<Map<String, dynamic>> _getUserData(String friendUid) async {
    CollectionReference userCollection =
        FirebaseFirestore.instance.collection('users');
    DocumentSnapshot userDocument = await userCollection.doc(friendUid).get();
    return userDocument.exists
        ? userDocument.data() as Map<String, dynamic>
        : {};
  }

  //showing friends list in chat page
  Widget _buildUserWidget(String friendUid) {
    return FutureBuilder(
      future: _getUserData(friendUid),
      builder: (context, userDataSnapshot) {
        if (userDataSnapshot.connectionState == ConnectionState.waiting) {
          return const Text('loading');
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
                const SizedBox(width: 18),
                Text(
                  userData['name'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 60, // Adjust the height between each user row
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  //Retrieving data from request collection and giving it to build user list item
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
            MaterialPageRoute(builder: (context) => const Nav()),
          ),
        ),
        title: const Text(
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
