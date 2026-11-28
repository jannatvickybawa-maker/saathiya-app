import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen())),
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
    showDialog(context: context, builder: (_) => AlertDialog(title: Text("MATCH! ❤️"), content: Text(profiles[index]["name"] + " ne bhi tumhe like kiya!"), actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text("OK"))]));
  }
  if (index < profiles.length - 1) {
    setState(() => index++);
  } else {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => FinishScreen()));
  }
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
class FinishScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Profiles Khatam!", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            SizedBox(height: 15),
            Text("Abhi ke liye aur profile nahi hai."),
            SizedBox(height: 20),
            ElevatedButton(onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => SwipeScreen())), child: Text("Phir Se Dekho")),
          ],
        ),
      ),
    );
  }
}
class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  final pass = TextEditingController();
  bool isLogin = true;
  bool loading = false;

  Future<void> submit() async {
    setState(() => loading = true);
    try {
      if (isLogin) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: email.text.trim(), password: pass.text.trim());
      } else {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email.text.trim(), password: pass.text.trim());
      }
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => SwipeScreen()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isLogin ? "Login" : "Sign Up")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: email, decoration: InputDecoration(labelText: "Email")),
            SizedBox(height: 15),
            TextField(controller: pass, obscureText: true, decoration: InputDecoration(labelText: "Password (6+ letter)")),
            SizedBox(height: 25),
            loading ? CircularProgressIndicator() : ElevatedButton(onPressed: submit, child: Text(isLogin ? "Login Karo" : "Account Banao")),
            TextButton(onPressed: () => setState(() => isLogin = !isLogin), child: Text(isLogin ? "Naya account hai? Sign Up karo" : "Pehle se account hai? Login karo")),
          ],
        ),
      ),
    );
  }
}
