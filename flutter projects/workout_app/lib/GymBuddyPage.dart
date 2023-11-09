import 'package:flutter/material.dart';
import 'package:swipe_cards/draggable_card.dart';
import 'package:swipe_cards/swipe_cards.dart';

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
            content: Text("Send Request ${_names[i]}"),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Find your Gym Buddy"),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              height: 550,
              child: SwipeCards(
                matchEngine: _matchEngine,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    alignment: Alignment.center,
                    color: _swipeItems[index].content.color,
                    child: Text(
                      _swipeItems[index].content.text,
                      style: TextStyle(fontSize: 100),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _matchEngine.currentItem?.nope();
                  },
                  child: Text("Rejected"),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red, // Background color
                    onPrimary: Colors.white, // Text color
                    padding: EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10), // Padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Border radius
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _matchEngine.currentItem?.superLike();
                  },
                  child: Text("Send Request"),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green, // Background color
                    onPrimary: Colors.white, // Text color
                    padding: EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10), // Padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Border radius
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
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
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SwipeCard(),
    );
  }
}
