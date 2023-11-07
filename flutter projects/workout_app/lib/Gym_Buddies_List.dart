import 'package:flutter/material.dart';

class User {
  final String name;
  final String username;
  final String imageUrl;
  bool isFollowed;

  User({
    required this.name,
    required this.username,
    required this.imageUrl,
    required this.isFollowed,
  });
}

class GymBuddies extends StatefulWidget {
  const GymBuddies({super.key});

  @override
  State<GymBuddies> createState() => _GymBuddiesState();
}

class _GymBuddiesState extends State<GymBuddies> {
  List<User> friendRequests = [
    User(
      name: 'ronaldo',
      username: 'Cristiano Ronaldo',
      imageUrl:
      "https://upload.wikimedia.org/wikipedia/commons/8/8c/Cristiano_Ronaldo_2018.jpg",
      isFollowed: false,
    ),
    User(
      name: 'virat.kohli',
      username: 'Virat Kohli',
      imageUrl:
      "https://cdn.images.express.co.uk/img/dynamic/68/590x/Virat-Kohli-India-cricket-star-927773.jpg?r=1686998680160",
      isFollowed: false,
    ),
  ];

  List<User> followersList = [
    User(
      name: 'virat.kohli',
      username: 'Virat Kohli',
      imageUrl:
      "https://cdn.images.express.co.uk/img/dynamic/68/590x/Virat-Kohli-India-cricket-star-927773.jpg?r=1686998680160",
      isFollowed: false,
    ),
    User(
      name: 'steve_smith',
      username: 'Steve Smith',
      imageUrl:
      "https://staticg.sportskeeda.com/editor/2023/02/4a3c6-16766121781745-1920.jpg",
      isFollowed: false,
    ),
    User(
      name: 'leomessi',
      username: 'Leo Messi',
      imageUrl:
      "https://img.olympicchannel.com/images/image/private/t_s_w960/t_s_16_9_g_auto/f_auto/primary/wq4l6w3ftzn6gequts2v",
      isFollowed: false,
    ),
    User(
      name: 'ronaldo',
      username: 'Cristiano Ronaldo',
      imageUrl:
      "https://upload.wikimedia.org/wikipedia/commons/8/8c/Cristiano_Ronaldo_2018.jpg",
      isFollowed: false,
    ),
  ];

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
              child: ListView.builder(
                itemCount: friendRequests.length,
                itemBuilder: (context, index) {
                  User user = friendRequests[index];
                  return friendRequestItem(user);
                },
              ),
            ),
          ),

          // List of Followers Section
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.white,
            child: ListTile(
              title: Text(
                'Followers',
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
              child: ListView.builder(
                itemCount: followersList.length,
                itemBuilder: (context, index) {
                  User user = followersList[index];
                  return followerItem(user);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  friendRequestItem(User user) {
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

  followerItem(User user) {
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
