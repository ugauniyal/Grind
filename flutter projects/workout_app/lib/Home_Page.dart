import 'package:flutter/material.dart';
import 'package:workout_app/sideBar.dart';
import 'package:workout_app/signIO.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, this.title});

  String? title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentIndex1 = 0;

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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: ClipOval(
                  child: Image.network(
                    'https://m.media-amazon.com/images/S/pv-target-images/eac8b2236c3ad14773975e921a285f1b622de5f3673b36626b0a24e3dfccce37.jpg',
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
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
              Container(
                height: 200,
                width: double.infinity,
                color: Colors.pinkAccent,
                child: Center(
                  child: Text(
                    'Think about this box',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 5,
                      color: Colors.white, // Set the color of the Card
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
                              // Set the color of the Container
                              child: gymPhotos[index],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10, top: 8, bottom: 6.0),
                            child: Text(
                              'Gym ${index + 1}',
                              style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
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
                                fontWeight: FontWeight.w200,
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
                  );
                },
                itemCount: gymPhotos.length,
              ),
            ],
          ),
        ));
  }
}
