import 'package:flutter/material.dart';
import 'package:workout_app/chatDmUI.dart';

void main() {
  runApp(ChatPage());
}

class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Contacts',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
        backgroundColor: Colors.black,
      ),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: [
          ContactCard(
            name: 'Contact 1',
            imagePath: 'profile1.jpg',
          ),
          ContactCard(
            name: 'Contact 2',
            imagePath: 'profile2.jpg',
          ),
          ContactCard(
            name: 'Contact 3',
            imagePath: 'profile3.jpg',
          ),
          ContactCard(
            name: 'Contact 4',
            imagePath: 'profile4.jpg',
          ),
        ],
      ),
    );
  }
}

class ContactCard extends StatelessWidget {
  final String name;
  final String imagePath;

  ContactCard({required this.name, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChatDmUI()),
        );
      },
      child: Card(
        color: Colors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage(imagePath),
          ),
          title: Text(
            name,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text('Last message preview'),
          trailing: Icon(Icons.arrow_forward),
        ),
      ),
    );
  }
}
