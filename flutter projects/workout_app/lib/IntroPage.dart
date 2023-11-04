import 'package:flutter/material.dart';
import 'package:workout_app/main.dart';


class IntroPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Intro') ,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Grind With Us',style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
            ) ,),
            SizedBox(
              height: 11,
            ),
            ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return MyHomePage(title: "Grind");
              }));
            },
                child: Text('Lessgo'))

          ],
        ),
      ),
    );

  }
}
