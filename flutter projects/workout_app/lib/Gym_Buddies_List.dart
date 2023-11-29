import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Buddy {
  final String name;
  final String username;
  final String imageUrl;
  bool isFollowed;

  int? age;

  Buddy({
    required this.name,
    required this.username,
    required this.imageUrl,
    required this.isFollowed,
    this.age,
  });
}

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
                    return CircularProgressIndicator();
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
                        return CircularProgressIndicator();
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
                              request['accepted'] != true)
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
                                  return CircularProgressIndicator();
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
                                if (isAccepted) {
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
                                        onTap: () {
                                          FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(authSnapshot.data!
                                                  .uid) // Assuming the logged-in user's UID
                                              .collection('requests')
                                              .doc(
                                                  uid) // UID of the user to be removed
                                              .delete();
                                        },
                                        child: const Icon(
                                          Icons
                                              .clear, // Replace with the icon you want for the cross
                                          color: Colors
                                              .red, // Set the color as needed
                                        ),
                                      ),
                                      SizedBox(
                                          width:
                                              10), // Add some spacing between icons
                                      GestureDetector(
                                        onTap: () {
                                          FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(authSnapshot.data!
                                                  .uid) // Assuming the logged-in user's UID
                                              .collection('requests')
                                              .doc(
                                                  uid) // UID of the user to be removed
                                              .update({
                                            'accepted': true,
                                            'pending': false,
                                          });
                                        },
                                        child: Icon(
                                          Icons
                                              .check, // Replace with the icon you want for the tick
                                          color: Colors
                                              .green, // Set the color as needed
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
                return CircularProgressIndicator();
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
                    return CircularProgressIndicator();
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
                              return CircularProgressIndicator();
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

                            // Display only the "name" field for added friends
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
                                    onTap: () {
                                      FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(authSnapshot.data!.uid)
                                          .collection('requests')
                                          .doc(
                                              friendUid) // Use the friend's UID
                                          .delete();
                                    },
                                    child: Icon(
                                      Icons.remove_circle,
                                      color: Colors.red,
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
          SizedBox(
            height: 40,
          )
        ],
      ),
    );
  }

  friendRequestItem(Buddy user) {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                height: 60,
                width: 60,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(
                    user.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    user.username,
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  )
                ],
              )
            ],
          ),
          Container(
            height: 40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white,
              ),
              borderRadius: BorderRadius.circular(50),
            ),
            child: MaterialButton(
              color: user.isFollowed
                  ? const Color.fromARGB(255, 214, 213, 214)
                  : const Color.fromRGBO(0, 0, 0, 100),
              onPressed: () {
                setState(() {
                  user.isFollowed = !user.isFollowed;
                });
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              child: Text(
                user.isFollowed ? 'Accept' : 'Decline',
                style: const TextStyle(color: Colors.black),
              ),
            ),
          )
        ],
      ),
    );
  }

  followerItem(Buddy user) {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                height: 60,
                width: 60,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(
                    user.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    user.username,
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  )
                ],
              )
            ],
          ),
          Container(
            height: 40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white,
              ),
              borderRadius: BorderRadius.circular(50),
            ),
            child: MaterialButton(
              color: user.isFollowed
                  ? const Color.fromARGB(255, 214, 213, 214)
                  : const Color.fromRGBO(0, 0, 0, 100),
              onPressed: () {
                setState(() {
                  user.isFollowed = !user.isFollowed;
                });
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              child: Text(
                user.isFollowed ? 'Unfollow' : 'Follow',
                style: const TextStyle(color: Colors.black),
              ),
            ),
          )
        ],
      ),
    );
  }
}
