import 'package:election/user/dashboard.dart';
import 'package:flutter/material.dart';
import '../user/lists/ballot.dart';
import '../user/lists/candiates.dart';
import '../user/lists/votes.dart';

// import '../startend (2).dart';
// import '../startend.dart';

class NavBar extends StatelessWidget {
      var email;
 NavBar(this.email, {Key? key}) : super(key: key);
  // const NavBar({Key? key}) : super(key: key);

void selectedItem(BuildContext context, int index){
  Navigator.of(context).pop(); 
  //doesnot show side bar when pressed back button from pages

  switch(index){
    case 0:
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context)=> AdminDashboard(email),
        ),);
        break;
    case 1:
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context)=> CandidateList(),
        ),);
        break;
    case 3:
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context)=> Ballot(email),
        ),);
        break;
    case 4:
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context)=> Votes(),
        ),);
        break;
  }
}

  @override
  Widget build(BuildContext context) {
   return Drawer(
    child: ListView(
      //remove padding
      padding: EdgeInsets.zero,
      children: <Widget>[
        ListTile(
          leading:const Icon(Icons.account_box),
          title: const Text('profile'),
          onTap: ()=> selectedItem(context ,0),
        ),
        ListTile(
          leading: const Icon(Icons.person_add_alt_1_rounded),
          title: const Text('Candidates'),
          onTap: ()=> selectedItem(context ,1),
        ),
        ListTile(
          leading:const Icon(Icons.pages),
          title: const Text('Votes'),
          onTap: ()=> selectedItem(context ,4),
        ),
        ListTile(
          leading:const Icon(Icons.description),
          title: const Text('Ballot'),
          onTap: ()=> selectedItem(context ,3),
        ),
        ListTile(
          leading:const Icon(Icons.exit_to_app),
          title: const Text('Exit'),
          onTap: ()=> selectedItem(context ,4),
        ),
          //       ListTile(
          // leading:const Icon(Icons.description),
          // title: const Text('start'),
          // onTap: ()=> selectedItem(context ,5),
        // ),
      ],
    ),
   );
  }
}