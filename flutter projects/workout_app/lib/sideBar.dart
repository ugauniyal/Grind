import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text('TunTun Mausi',style: TextStyle(color: Colors.black),),
            accountEmail: Text('tuntunmausiladoos@gmail.com',style: TextStyle(color: Colors.black),),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.network(
                  'https://m.media-amazon.com/images/S/pv-target-images/eac8b2236c3ad14773975e921a285f1b622de5f3673b36626b0a24e3dfccce37.jpg',
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
          ),
          ListTile(
            leading: Icon(Icons.save),
            title: Text('Saved'),
            onTap: () => Null,
          ),
          ListTile(
            leading: Icon(Icons.people),
            title: Text('Gym Buddies'),
            onTap: () => Null,
          ),
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text('New Requests'),
            onTap: () => Null,
            trailing: Container(
              child: Text(
                '3',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () => Null,
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text('Need help?'),
            onTap: () => Null,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Log Out'),
            onTap: () => Null,
          ),
        ],
      ),
    );
  }
}
