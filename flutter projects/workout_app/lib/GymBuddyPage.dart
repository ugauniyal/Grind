import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:swipe_cards/draggable_card.dart';
import 'package:swipe_cards/swipe_cards.dart';

import 'model/user.dart';

void main() {
  runApp(MyApp());
}

class Content {
  final String text;
  final Color color;

  Content({required this.text, required this.color});
}

class SwipeCard extends StatefulWidget {
  @override
  _SwipeCardState createState() => _SwipeCardState();
}

class _SwipeCardState extends State<SwipeCard> {
  User? _user = FirebaseAuth.instance.currentUser;
  TextEditingController _searchController = TextEditingController();
  List<UserCollection> _searchResults = [];
  List<SwipeItem> _swipeItems = [];
  late MatchEngine _matchEngine;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  List<String> _names = ["Red", "Blue", "Green", "Yellow", "Orange"];
  List<Color> _colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange,
  ];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < _names.length; i++) {
      _swipeItems.add(SwipeItem(
        content: Content(text: _names[i], color: _colors[i]),
        likeAction: () {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Request Sent to ${_names[i]}"),
            duration: Duration(milliseconds: 500),
          ));
        },
        nopeAction: () {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Rejected ${_names[i]}"),
            duration: Duration(milliseconds: 500),
          ));
        },
        onSlideUpdate: (SlideRegion? region) {
          print("Region $region");
          return Future<void>.value();
        },
      ));
    }

    _matchEngine = MatchEngine(swipeItems: _swipeItems);
  }

  void _searchUsers(String query) {
    FirebaseFirestore.instance
        .collection('users')
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThan: query + 'z')
        .get()
        .then((QuerySnapshot querySnapshot) {
      List<UserCollection> searchResults = [];
      querySnapshot.docs.forEach((doc) {
        var userData = doc.data() as Map<String, dynamic>;
        searchResults.add(UserCollection(
          id: doc.id,
          name: userData['name'],
          email: userData['email'],
        ));
      });
      _displaySearchResults(searchResults);
    });
  }

  void _displaySearchResults(List<UserCollection> searchResults) {
    setState(() {
      _searchResults = searchResults;
    });
  }

  void _onUserTap(UserCollection user) {
    // Save user data to Firestore
    String? uid = _user?.uid;
    FirebaseFirestore.instance
        .collection('users')
        .doc(user.id)
        .collection('requests')
        .doc(uid)
        .set({'uid': uid, 'pending': true, 'accepted': false, 'block': false});

    // You can show a confirmation message or perform any other action here
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Selected ${user.name}"),
      duration: Duration(milliseconds: 500),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white54,
        iconTheme: IconThemeData(color: Colors.black),
        title: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search users',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                String query = _searchController.text;
                _searchUsers(query);
              },
              child: Text('Search'),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: _searchResults.isNotEmpty
                ? ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      UserCollection user = _searchResults[index];
                      return ListTile(
                        title: Text(user.name),
                        subtitle: Text(user.email),
                        onTap: () {
                          // Handle the tap event on the searched user
                          _onUserTap(user);
                        },
                      );
                    },
                  )
                : Container(
                    margin: EdgeInsets.symmetric(vertical: 20),
                    child: SwipeCards(
                      matchEngine: _matchEngine,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          decoration: BoxDecoration(
                            color: _swipeItems[index].content.color,
                            borderRadius: BorderRadius.circular(15.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 10,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            _swipeItems[index].content.text,
                            style: TextStyle(
                              fontSize: 50,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                      onStackFinished: () {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Stack Finished"),
                          duration: Duration(milliseconds: 500),
                        ));
                      },
                      itemChanged: (SwipeItem item, int index) {
                        print("item: ${item.content.text}, index: $index");
                      },
                      upSwipeAllowed: false,
                      fillSpace: true,
                    ),
                  ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  _matchEngine.currentItem?.nope();
                },
                child: Text("Reject"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red, // Text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  elevation: 5,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _matchEngine.currentItem?.like();
                },
                child: Text("Send Request"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green, // Text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  elevation: 5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Swipe Cards Example',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SwipeCard(),
    );
  }
}
