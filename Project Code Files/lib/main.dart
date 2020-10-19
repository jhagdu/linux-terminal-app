//Importing Modules
import 'package:LinuxTerminal/pages/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

//Main Function
main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(LinuxTerminal());
}

//LinuxTerminal Class
class LinuxTerminal extends StatefulWidget {
  @override
  _LinuxTerminalState createState() => _LinuxTerminalState();
}

class _LinuxTerminalState extends State<LinuxTerminal> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(),
      routes: {
        "/": (context) => LinuxAppHome(),
      },
    );
  }
}
