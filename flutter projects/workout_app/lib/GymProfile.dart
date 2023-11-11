import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class GymDetailsPage extends StatelessWidget {
  final int gymIndex;

  GymDetailsPage(this.gymIndex);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gym Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gym Image Carousel
            CarouselSlider(
              options: CarouselOptions(
                height: 200,
                enlargeCenterPage: true,
                autoPlay: true,
                aspectRatio: 16 / 9,
                autoPlayCurve: Curves.fastOutSlowIn,
                enableInfiniteScroll: true,
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                viewportFraction: 0.8,
              ),
              items: [
                Image.asset('assets/images/gym1.jpg', fit: BoxFit.cover),
                Image.asset('assets/images/gym2.jpg', fit: BoxFit.cover),
                Image.asset('assets/images/gym3.jpg', fit: BoxFit.cover),
              ],
            ),
            SizedBox(height: 16),

            // Gym Name and Rating
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Gym $gymIndex',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.yellow),
                      Text(
                        '4.5', // Replace with actual rating
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Gym Location and Distance
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Icon(Icons.location_on, color: Colors.grey),
                  SizedBox(width: 8),
                  Text(
                    'Dilshad Garden, New Delhi',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  Spacer(),
                  Text(
                    '2 kms away',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            // Gym Description
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Welcome to Gym $gymIndex! We offer a variety of fitness programs including Yoga, Zumba, and Aerobics. Our state-of-the-art facilities are designed to help you achieve your fitness goals.',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),

            // Additional Features (you can add more as needed)
            ListTile(
              leading: Icon(Icons.access_time),
              title: Text('Open Hours'),
              subtitle: Text('Mon-Fri: 6 AM - 10 PM\nSat-Sun: 8 AM - 8 PM'),
            ),

            ListTile(
              leading: Icon(Icons.payment),
              title: Text('Membership Fee'),
              subtitle: Text('₹1000/month'),
            ),

            // Add more features as needed
            // Review Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Reviews (21)',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 5, // Replace with actual number of reviews
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Card(
                    elevation: 3,
                    child: ListTile(
                      leading: CircleAvatar(
                        // Replace with actual user avatar
                        backgroundImage:
                            AssetImage('assets/default_avatar.png'),
                      ),
                      title: Text('Username'), // Replace with actual username
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.yellow),
                              Text('4.5'), // Replace with actual rating
                            ],
                          ),
                          Text(
                            'Great gym! I loved the facilities and friendly staff.',
                          ), // Replace with actual review comments
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
