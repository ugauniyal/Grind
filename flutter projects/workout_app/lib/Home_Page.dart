import 'package:flutter/material.dart';
import 'package:workout_app/Chat_Page.dart';
import 'package:workout_app/GymProfile.dart';
import 'package:workout_app/sideBar.dart';

// Function to determine the star color based on the rating
Color _getStarColor(double rating) {
  if (rating >= 4.0) {
    return Colors.green;
  } else if (rating >= 3.0 && rating < 4.0) {
    return Colors.lightGreen;
  } else if (rating >= 2.0 && rating < 3.0) {
    return Colors.yellow;
  } else {
    return Colors.red;
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, this.title});

  String? title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentIndex1 = 0;
  double rating = 3.2;

  List<Widget> gymPhotos = [
    Image.asset('assets/images/gym1.jpg'),
    Image.asset('assets/images/gym2.jpg'),
    Image.asset('assets/images/gym3.jpg')
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      drawer: const NavBar(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Container(
          padding: EdgeInsets.zero,
          child: Text('Grind', style: TextStyle(fontSize: 30)),
        ),
        centerTitle: true,
        primary: false,
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => ChatPage()));
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: ClipOval(
                child: Icon(
                  Icons.chat,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.brown,
                  borderRadius:
                      BorderRadius.circular(10.0), // Adjust the value as needed
                ),
                child: Center(
                  child: Text(
                    'Think about this box',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      // Navigate to the new page when the card is tapped
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GymDetailsPage(index + 1)),
                      );
                    },
                    child: Card(
                      elevation: 10,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(16),
                                topLeft: Radius.circular(16)),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.0),
                                color: Colors.white,
                              ),
                              child: gymPhotos[index],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10, top: 8, bottom: 6.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Gym ${index + 1}",
                                    style: TextStyle(
                                        fontFamily: "TextName",
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18)),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: _getStarColor(rating),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Row(
                                      children: [
                                        Center(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Icon(
                                              Icons.star,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 3.0, right: 10.0),
                                            child: Text(
                                              rating
                                                  .toString(), // Replace with actual rating
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w200,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 11),
                            child: Text(
                              'Yoga • Zumba • Aerobics',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 11),
                            child: Text(
                              '2 kms away',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                fontFamily: 'TextFamily',
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 11, bottom: 7),
                            child: Text(
                              '₹1000/month',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                fontFamily: 'TextFamily',
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              itemCount: gymPhotos.length,
            ),
          ],
        ),
      ),
    );
  }
}
