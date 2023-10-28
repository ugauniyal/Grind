import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Gym Buddy (Prototype)'),

    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});



  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  List<Widget> body = const[
    Icon(Icons.home),
    Icon(Icons.menu),
    Icon(Icons.person)

  ];


  // void _incrementCounter() {
  //   setState(() {
  //
  //     _counter++;
  //   });
  // }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Colors.white,

        title: const Text('WorkoutApp',style: TextStyle(fontSize: 30)),

        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.notifications),
          onPressed: (){

          },)
        ],
      leading: IconButton(
        onPressed: (){},
        icon: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: (){},
        ),
      ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20)
          )
        ),
      ),
        body: Center(
          child: body[_currentIndex],
        ),
        bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int newIndex){
          setState(() {
            _currentIndex = newIndex;
          });
        },
      items: const [
        BottomNavigationBarItem(
          label: 'Home',
          icon: Icon(Icons.home),
        ),
        BottomNavigationBarItem(
          label: 'Menu',
          icon: Icon(Icons.menu),
        ),
        BottomNavigationBarItem(
          label: 'profile',
          icon: Icon(Icons.person),
        ),
      ],
    ),


    );


  }
}
