import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'chatDmUI.dart';

void fetchName() async {
  User? user = FirebaseAuth.instance.currentUser;
  String uid = user?.uid ?? '';
  if (uid.isNotEmpty) {
    try {
      CollectionReference userCollection =
          FirebaseFirestore.instance.collection('users');
      DocumentSnapshot userDocument = await userCollection.doc(uid).get();

      if (userDocument.exists) {
        // User document exists, now fetch data from the 'requests' subcollection
        CollectionReference requestsCollection =
            userCollection.doc(uid).collection('requests');
        QuerySnapshot requestsSnapshot = await requestsCollection.get();

        if (requestsSnapshot.docs.isNotEmpty) {
          // Requests subcollection has documents, print the data
          final allRequestsData =
              requestsSnapshot.docs.map((doc) => doc.data()).toList();
          print('Requests Data: $allRequestsData');
        } else {
          print('No documents found in the requests subcollection');
        }
      } else {
        print('User document does not exist');
      }
    } catch (ex) {
      print('Error in fetching data: $ex');
    }
  }
}

class GymBuddies extends StatefulWidget {
  const GymBuddies({super.key});

  @override
  State<GymBuddies> createState() => _GymBuddiesState();
}

class _GymBuddiesState extends State<GymBuddies> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Your Buddies',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          // Friend Requests Section
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.white,
            child: const ListTile(
              title: Text(
                'Friend Requests',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.white,
              child: StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder:
                    (BuildContext context, AsyncSnapshot<User?> authSnapshot) {
                  if (authSnapshot.connectionState == ConnectionState.waiting) {
                    return Text('Loading');
                  }

                  if (authSnapshot.hasError) {
                    return Text('Error: ${authSnapshot.error}');
                  }

                  if (!authSnapshot.hasData || authSnapshot.data == null) {
                    return Text('No user logged in');
                  }

                  User user = authSnapshot.data!;
                  List<String> requestUids = []; // List to store request UIDs

                  return StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.uid)
                        .collection('requests')
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> requestSnapshot) {
                      if (requestSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Text('Loading');
                      }

                      if (requestSnapshot.hasError) {
                        return Text('Error: ${requestSnapshot.error}');
                      }

                      if (!requestSnapshot.hasData ||
                          requestSnapshot.data!.docs.isEmpty) {
                        return Text('No requests available for this user');
                      }

                      // Process the data from the requests snapshot
                      List<Map<String, dynamic>> requestsDataList =
                          requestSnapshot.data!.docs
                              .map((DocumentSnapshot doc) =>
                                  doc.data() as Map<String, dynamic>)
                              .toList();
                      // Filter out accepted friend requests
                      requestsDataList = requestsDataList
                          .where((request) =>
                              !request.containsKey('accepted') ||
                              request['accepted'] != true &&
                                  request['block'] != true)
                          .toList();

                      // Save the request UIDs to the list
                      List<String> requestUids = requestsDataList
                          .map((request) => request['uid'].toString())
                          .toList();

                      // Display the request UIDs
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (String uid in requestUids)
                            StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(uid)
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<DocumentSnapshot>
                                      userSnapshot) {
                                if (userSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Text('Loading');
                                }

                                if (userSnapshot.hasError) {
                                  return Text('Error: ${userSnapshot.error}');
                                }

                                if (!userSnapshot.hasData ||
                                    !userSnapshot.data!.exists) {
                                  return Text('User with UID $uid not found');
                                }

                                // Access the data using userSnapshot.data.data() or userSnapshot.data.get('field_name')
                                Map<String, dynamic> userData =
                                    userSnapshot.data!.data()
                                        as Map<String, dynamic>;
                                // Check if the user is accepted
                                bool isAccepted =
                                    userData.containsKey('accepted') &&
                                        userData['accepted'];
                                bool isPending =
                                    userData.containsKey('pending') &&
                                        userData['pending'];
                                bool isBlock = userData.containsKey('block') &&
                                    userData['block'];

                                if (isAccepted && isBlock) {
                                  // Don't render this user in the UI for friend requests
                                  return SizedBox.shrink();
                                }

                                // Display only the "name" and "username" fields
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      if (userData.containsKey('downloadUrl') &&
                                          userData['downloadUrl'] != null &&
                                          userData['downloadUrl'] is String)
                                        CircleAvatar(
                                          backgroundImage: NetworkImage(
                                            userData['downloadUrl'],
                                          ),
                                          radius: 20,
                                        ),
                                      SizedBox(width: 18),
                                      if (userData.containsKey('name'))
                                        Text(
                                          '${userData['name']}',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      Spacer(), // Add Spacer to push icons to the right
                                      GestureDetector(
                                        onTap: () async {
                                          String loggedInUserId = authSnapshot
                                              .data!
                                              .uid; // Logged-in user's UID
                                          String otherUserId =
                                              uid; // UID of the other user

                                          // Remove the request from the logged-in user's collection
                                          await FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(loggedInUserId)
                                              .collection('requests')
                                              .doc(otherUserId)
                                              .delete();

                                          // Remove the request from the other user's collection
                                          await FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(otherUserId)
                                              .collection('requests')
                                              .doc(loggedInUserId)
                                              .delete();
                                        },
                                        child: const Icon(
                                          Icons.clear,
                                          color: Colors.red,
                                        ),
                                      ),

                                      SizedBox(
                                          width:
                                              10), // Add some spacing between icons
                                      GestureDetector(
                                        onTap: () async {
                                          final userUid =
                                              authSnapshot.data!.uid;
                                          final requestCollection =
                                              FirebaseFirestore.instance
                                                  .collection('users');

                                          // Update the logged-in user's request
                                          await requestCollection
                                              .doc(userUid)
                                              .collection('requests')
                                              .doc(uid)
                                              .set(
                                                  {
                                                'accepted': true,
                                                'pending': false,
                                                'block': false,
                                                'uid': uid,
                                                'swipe': false
                                              },
                                                  SetOptions(
                                                      merge:
                                                          true)); // Use merge to create the document if it doesn't exist

                                          // Update the other user's request
                                          await requestCollection
                                              .doc(uid)
                                              .collection('requests')
                                              .doc(userUid)
                                              .set(
                                                  {
                                                'accepted': true,
                                                'pending': false,
                                                'block': false,
                                                'uid': userUid,
                                                'swipe': false
                                              },
                                                  SetOptions(
                                                      merge:
                                                          true)); // Use merge to create the document if it doesn't exist
                                        },
                                        child: Icon(
                                          Icons.check,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ),

          // List of Followers Section
          // List of Followers Section
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.white,
            child: ListTile(
              title: Text(
                'Added Friends',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (BuildContext context, AsyncSnapshot<User?> authSnapshot) {
              if (authSnapshot.connectionState == ConnectionState.waiting) {
                return Text('loading');
              }

              if (authSnapshot.hasError) {
                return Text('Error: ${authSnapshot.error}');
              }

              if (!authSnapshot.hasData || authSnapshot.data == null) {
                return Text('No user logged in');
              }

              User user = authSnapshot.data!;

              return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .collection('requests')
                    .where('accepted', isEqualTo: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> acceptedSnapshot) {
                  if (acceptedSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Text('Loading');
                  }

                  if (acceptedSnapshot.hasError) {
                    return Text('Error: ${acceptedSnapshot.error}');
                  }

                  if (!acceptedSnapshot.hasData ||
                      acceptedSnapshot.data!.docs.isEmpty) {
                    return Text('No friend requests available');
                  }

                  // Process the data from the acceptedSnapshot
                  List<Map<String, dynamic>> acceptedDataList = acceptedSnapshot
                      .data!.docs
                      .map((DocumentSnapshot doc) =>
                          doc.data() as Map<String, dynamic>)
                      .toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (Map<String, dynamic> acceptedData
                          in acceptedDataList)
                        StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .doc(acceptedData['uid'].toString())
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                            if (userSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Text('Loading');
                            }

                            if (userSnapshot.hasError) {
                              return Text('Error: ${userSnapshot.error}');
                            }

                            if (!userSnapshot.hasData ||
                                !userSnapshot.data!.exists) {
                              return Text('User not found');
                            }

                            // Access the data using userSnapshot.data.data() or userSnapshot.data.get('field_name')
                            Map<String, dynamic> userData = userSnapshot.data!
                                .data() as Map<String, dynamic>;

                            // Get the UID of the friend
                            String friendUid = acceptedData['uid'].toString();

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onLongPress: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ListTile(
                                            leading: Icon(Icons.remove_circle,
                                                color: Colors.red),
                                            title: Text('Remove Friend'),
                                            onTap: () async {
                                              String loggedInUserId = user
                                                  .uid; // Logged-in user's UID
                                              String otherUserId =
                                                  friendUid; // UID of the other user
                                              print(friendUid);
                                              try {
                                                // Remove the friend from the logged-in user's request collection
                                                await FirebaseFirestore.instance
                                                    .collection('users')
                                                    .doc(loggedInUserId)
                                                    .collection('requests')
                                                    .doc(otherUserId)
                                                    .delete();
                                              } catch (e) {
                                                print(
                                                    'Error removing friend from logged-in user\'s requests: $e');
                                              }

                                              try {
                                                // Remove the friend from the other user's request collection
                                                await FirebaseFirestore.instance
                                                    .collection('users')
                                                    .doc(otherUserId)
                                                    .collection('requests')
                                                    .doc(loggedInUserId)
                                                    .delete();
                                              } catch (e) {
                                                print(
                                                    'Error removing friend from other user\'s requests: $e');
                                              }

                                              Navigator.pop(context);
                                            },
                                          ),
                                          ListTile(
                                            leading: Icon(Icons.block,
                                                color: Colors.black),
                                            title: Text('Block User'),
                                            onTap: () {
                                              // Handle block user action
                                              Navigator.pop(context);
                                            },
                                          ),
                                          ListTile(
                                            leading: Icon(Icons.chat_bubble,
                                                color: Colors.blue),
                                            title: Text('Open Chatbox'),
                                            onTap: () {
                                              // Handle open chatbox action
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ChatDmUI(
                                                    receiverUserUsername:
                                                        userData['name'],
                                                    receiverUserID: friendUid,
                                                    profilePicUrl: userData[
                                                            'downloadUrl'] ??
                                                        'https://moorepediatricnc.com/wp-content/uploads/2022/08/default_avatar.jpg',
                                                  ),
                                                ),
                                              );
                                              // Add your code to open the chatbox
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Row(
                                    children: [
                                      if (userData.containsKey('downloadUrl') &&
                                          userData['downloadUrl'] != null &&
                                          userData['downloadUrl'] is String)
                                        CircleAvatar(
                                          backgroundImage: NetworkImage(
                                            userData['downloadUrl'],
                                          ),
                                          radius: 20,
                                        ),
                                      SizedBox(width: 12),
                                      Text(
                                        '${userData['name']}',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Spacer(),
                                      GestureDetector(
                                        onTap: () {
                                          showModalBottomSheet(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  ListTile(
                                                    leading: Icon(
                                                        Icons.remove_circle,
                                                        color: Colors.red),
                                                    title:
                                                        Text('Remove Friend'),
                                                    onTap: () async {
                                                      String loggedInUserId = user
                                                          .uid; // Logged-in user's UID
                                                      String otherUserId =
                                                          friendUid; // UID of the other user
                                                      print(friendUid);
                                                      try {
                                                        // Remove the friend from the logged-in user's request collection
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection('users')
                                                            .doc(loggedInUserId)
                                                            .collection(
                                                                'requests')
                                                            .doc(otherUserId)
                                                            .delete();
                                                      } catch (e) {
                                                        print(
                                                            'Error removing friend from logged-in user\'s requests: $e');
                                                      }

                                                      try {
                                                        // Remove the friend from the other user's request collection
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection('users')
                                                            .doc(otherUserId)
                                                            .collection(
                                                                'requests')
                                                            .doc(loggedInUserId)
                                                            .delete();
                                                      } catch (e) {
                                                        print(
                                                            'Error removing friend from other user\'s requests: $e');
                                                      }

                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                  ListTile(
                                                    leading: Icon(Icons.block,
                                                        color: Colors.black),
                                                    title: Text('Block User'),
                                                    onTap: () {
                                                      FirebaseFirestore.instance
                                                          .collection('users')
                                                          .doc(authSnapshot
                                                              .data!
                                                              .uid) // Assuming the logged-in user's UID
                                                          .collection(
                                                              'requests')
                                                          .doc(
                                                              friendUid) // UID of the user to be removed
                                                          .update({
                                                        'block': true,
                                                        'accepted': false,
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                  ListTile(
                                                    leading: Icon(
                                                        Icons.chat_bubble,
                                                        color: Colors.blue),
                                                    title: Text('Open Chatbox'),
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              ChatDmUI(
                                                            receiverUserUsername:
                                                                userData[
                                                                    'name'],
                                                            receiverUserID:
                                                                friendUid,
                                                            profilePicUrl: userData[
                                                                    'downloadUrl'] ??
                                                                'https://moorepediatricnc.com/wp-content/uploads/2022/08/default_avatar.jpg',
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: Material(
                                          color: Colors.transparent,
                                          child: Ink(
                                            decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(4.0),
                                            ),
                                            child: InkWell(
                                              onTap: () {
                                                showModalBottomSheet(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        ListTile(
                                                          leading: Icon(
                                                              Icons
                                                                  .remove_circle,
                                                              color:
                                                                  Colors.red),
                                                          title: Text(
                                                              'Remove Friend'),
                                                          onTap: () async {
                                                            String
                                                                loggedInUserId =
                                                                user.uid; // Logged-in user's UID
                                                            String otherUserId =
                                                                friendUid; // UID of the other user
                                                            print(friendUid);
                                                            try {
                                                              // Remove the friend from the logged-in user's request collection
                                                              await FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'users')
                                                                  .doc(
                                                                      loggedInUserId)
                                                                  .collection(
                                                                      'requests')
                                                                  .doc(
                                                                      otherUserId)
                                                                  .delete();
                                                            } catch (e) {
                                                              print(
                                                                  'Error removing friend from logged-in user\'s requests: $e');
                                                            }

                                                            try {
                                                              // Remove the friend from the other user's request collection
                                                              await FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'users')
                                                                  .doc(
                                                                      otherUserId)
                                                                  .collection(
                                                                      'requests')
                                                                  .doc(
                                                                      loggedInUserId)
                                                                  .delete();
                                                            } catch (e) {
                                                              print(
                                                                  'Error removing friend from other user\'s requests: $e');
                                                            }

                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        ),
                                                        ListTile(
                                                          leading: Icon(
                                                              Icons.block,
                                                              color:
                                                                  Colors.black),
                                                          title: Text(
                                                              'Block User'),
                                                          onTap: () {
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'users')
                                                                .doc(authSnapshot
                                                                    .data!
                                                                    .uid) // Assuming the logged-in user's UID
                                                                .collection(
                                                                    'requests')
                                                                .doc(
                                                                    friendUid) // UID of the user to be removed
                                                                .update({
                                                              'block': true,
                                                              'accepted': false,
                                                            });
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        ),
                                                        ListTile(
                                                          leading: Icon(
                                                              Icons.chat_bubble,
                                                              color:
                                                                  Colors.blue),
                                                          title: Text(
                                                              'Open Chatbox'),
                                                          onTap: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        ChatDmUI(
                                                                  receiverUserUsername:
                                                                      userData[
                                                                          'name'],
                                                                  receiverUserID:
                                                                      friendUid,
                                                                  profilePicUrl:
                                                                      userData[
                                                                              'downloadUrl'] ??
                                                                          'https://moorepediatricnc.com/wp-content/uploads/2022/08/default_avatar.jpg',
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                              borderRadius:
                                                  BorderRadius.circular(4.0),
                                              highlightColor: Colors.grey[
                                                  400], // Adjust the color to your preference
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Icon(Icons.more_vert),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                    ],
                  );
                },
              );
            },
          ),
          SizedBox(
            height: 40,
          )
        ],
      ),
    );
  }
}
