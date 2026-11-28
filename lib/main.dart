import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    print("Firebase error: $e");
  }
  runApp(SaathiyaApp());
}

class SaathiyaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Saathiya',
      theme: ThemeData.dark(),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("SAATHIYA", style: TextStyle(fontSize: 48, color: Colors.amber, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("Kya Tum Meri Saathiya Banogi?", style: TextStyle(color: Colors.white70, fontSize: 18)),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SwipeScreen())),
              child: Text("Shuru Karein ❤️"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.pink, padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
            )
          ],
        ),
      ),
    );
  }
}

class SwipeScreen extends StatefulWidget {
  @override
  _SwipeScreenState createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen> {
  int index = 0;
  List profiles = [
    {"name": "Meera, 22 - Delhi", "img": "https://i.pravatar.cc/400?img=5"},
    {"name": "Aarav, 24 - Bhopal", "img": "https://i.pravatar.cc/400?img=12"},
    {"name": "Priya, 21 - Mumbai", "img": "https://i.pravatar.cc/400?img=9"},
  ];
  void next(bool liked) {
    if (liked) {
      showDialog(context: context, builder: (_) => AlertDialog(title: Text("MATCH! ❤️"), content: Text(profiles[index]["name"] + " ne bhi tumhe like kiya!"), actions: [TextButton(onPressed: ()=>Navigator.pop(context), child: Text("Chat Karo"))]));
    }
    setState(() => index = (index + 1) % profiles.length);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Saathiya"), backgroundColor: Colors.pink),
      body: Center(
        child: Column(
          children: [
            Image.network(profiles[index]["img"], height: 400, width: 350),
            Text(profiles[index]["name"], style: TextStyle(fontSize: 24)),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              ElevatedButton(onPressed: () => next(false), child: Text("Pass ❌")),
              SizedBox(width: 20),
              ElevatedButton(onPressed: () => next(true), child: Text("Like ❤️")),
            ])
          ],
        ),
      ),
    );
  }
}
