import 'package:election/Admin/home.dart';
import 'package:flutter/material.dart';
import '../widget/adminnavbar.dart';

class AdminDashboard extends StatefulWidget {
  var email;
  AdminDashboard(@required this.email);
  @override
  State<AdminDashboard> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminDashboard> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.purple,
      ),
      drawer: NavBar(widget.email),
      body: MaterialApp(
        debugShowCheckedModeBanner: false, // removes debug banner
        home: HomePage(widget.email),
      ),
    );
  }
}
