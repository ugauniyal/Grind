

import 'package:flutter/material.dart';


class SettingsOnePage extends StatefulWidget {
  const SettingsOnePage({super.key});

  @override
  State<SettingsOnePage> createState() => _SettingsOnePageState();
}

class _SettingsOnePageState extends State<SettingsOnePage> {
  bool enableDiscovery = true;
  bool sendReadReceipt = true;
  bool enableDarkMode = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white54,
        iconTheme: IconThemeData(color: Colors.black),

        title: Text("Settings",style: TextStyle(color: Colors.black),),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget> [
            const SizedBox(height: 10.0,),
            Card(
              elevation: 4.0,
              margin: const EdgeInsets.fromLTRB(32.0, 8.0, 32.0, 16.0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              child: Column(
                children:<Widget> [
                  ListTile(

                    leading: Icon(Icons.lock_outline,color: Colors.black,),
                    title: Text("Change Password"),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: (){
                      //Change Your password
                    },
                  ),
                 Divider(),
                  ListTile(
                    leading: Icon(Icons.social_distance,color: Colors.black,),
                    title: Text("Edit Distance radius"),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: (){
                      //Change Your password
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.people,color: Colors.black,),
                    title: Text("Show me"),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: (){
                      //man , woman,both
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.height,color: Colors.black,),
                    title: Text("Level of gym buddy"),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: (){
                      //beginner,int,adv
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.interests,color: Colors.black,),
                    title: Text("Interests"),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: (){
                      //my interests
                    },
                  )
                ],
              ),
            ),
            const SizedBox(height: 10.0,),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text("Enable Discovery",style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: SwitchListTile(
                  dense: true,
                 activeColor: Colors.black,
                  contentPadding: const EdgeInsets.all(0),
                  value: enableDiscovery,
                  title: Text('Enable Discovery',style: TextStyle(fontSize: 13),),
                  onChanged: (val){
                    setState(() {
                      enableDiscovery = val;
                    });

                  },
                  ),
            ),
            const SizedBox(height: 5.0,),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text("Read Receipt",style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: SwitchListTile(
                  dense: true,
                  activeColor: Colors.black,
                  contentPadding: const EdgeInsets.all(0),
                  value: sendReadReceipt,
                  title: Text('Send Read Receipt',style: TextStyle(fontSize: 13)),
                  onChanged: (val){
                    setState(() {
                      sendReadReceipt = val;
                    });

                  }),
            ),
            const SizedBox(height: 5.0,),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text("Dark Mode",style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: SwitchListTile(
                dense: true,
                  activeColor: Colors.black,
                  contentPadding: const EdgeInsets.all(0),
                  value: enableDarkMode,
                  title: Text('Enable Dark Mode',style: TextStyle(fontSize: 13)),
                  onChanged: (val){
                  setState(() {
                    enableDarkMode = val;
                  });

                  }),
            ),

          ],
        ),
      ),
    );
  }
}
