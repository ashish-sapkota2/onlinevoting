import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:election/api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../lists/voters.dart';
import 'package:image_picker/image_picker.dart';

class EditData extends StatefulWidget {
  final List list;
  final int index;

  EditData({required this.list, required this.index});

  @override
  _EditDataState createState() => new _EditDataState();
}

class _EditDataState extends State<EditData> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController controllerName = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController phone = new TextEditingController();
  TextEditingController controllerGender = new TextEditingController();
  TextEditingController controllerFaculty = new TextEditingController();
  //TextEditingController controlleragenda = new TextEditingController();
  File? pickedImage;
  String imagePath = "";
  void imagePickerOption() {
    Get.bottomSheet(
      SingleChildScrollView(
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
          child: Container(
            color: Colors.white,
            height: 250,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Pic Image From",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.purple,
                    ),
                    onPressed: () {
                      pickImage(ImageSource.camera);
                    },
                    icon: const Icon(Icons.camera),
                    label: const Text("CAMERA"),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.purple,
                    ),
                    onPressed: () {
                      pickImage(ImageSource.gallery);
                    },
                    icon: const Icon(Icons.image),
                    label: const Text("GALLERY"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.purple,
                    ),
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(Icons.close),
                    label: const Text("CANCEL"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> pickImage(ImageSource gallery) async {
    try {
      var photo = await ImagePicker().pickImage(source: gallery);
      setState(() {
        pickedImage = File(photo!.path);
      });

      Get.back();
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<void> editData() async {
    List<int> imageBytes = pickedImage?.readAsBytesSync() as List<int>;
    String baseimage = base64Encode(imageBytes);
    var url = "$uri/voting/php/editvoter.php/";
    // var url="http://192.168.1.66/voting/php/edit.php/";
    final response = await http.post(Uri.parse(url), body: {
      "uid": widget.list[widget.index]['uid'],
      "rid": widget.list[widget.index]['rid'],
      "name": controllerName.text,
      "email": email.text,
      "phone": phone.text,
      "gender": controllerGender.text,
      "faculty": controllerFaculty.text,
      'image': baseimage
    });
    var data = json.decode(json.encode(response.body));
    if (data.compareTo("Successful") == 0) {
      print(data);
      showSuccessSnackBar(Text("Detail updated Sucessfully"));
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => new VotersList()));
    } else {
      print("Success");
      showSuccessSnackBar(Text("Failed to update"));
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => new VotersList()));
    }
  }

  @override
  void initState() {
    controllerName =
        new TextEditingController(text: widget.list[widget.index]['name']);
    email = new TextEditingController(text: widget.list[widget.index]['email']);
    phone = new TextEditingController(text: widget.list[widget.index]['phone']);
    controllerGender =
        new TextEditingController(text: widget.list[widget.index]['gender']);
    controllerFaculty =
        new TextEditingController(text: widget.list[widget.index]['faculty']);
    super.initState();
  }

  showSuccessSnackBar(message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: message,
      backgroundColor: Colors.purple,
      //margin: EdgeInsets.all(20),
      duration: Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8))),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("EDIT DATA"),
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Column(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(
                  height: 50,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Stack(children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.purple, width: 5),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(100),
                        ),
                      ),
                      child: ClipOval(
                        child: pickedImage != null
                            ? Image.file(
                                pickedImage!,
                                //if pickked image is null then the default image is shown whose link is given,
                                //otherwise picked image is shown
                                width: 170,
                                height: 170,
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                '$uri/voting/${widget.list[widget.index]['image']}',
                                //  '$uri/voting/${widget.list[widget.index]['image']}',

                                //'https://upload.wikimedia.org/wikipedia/commons/5/5f/Alberto_conversi_profile_pic.jpg',
                                width: 170,
                                height: 170,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 5,
                      child: IconButton(
                        onPressed: imagePickerOption,
                        icon: const Icon(
                          Icons.add_a_photo_outlined,
                          color: Colors.purple,
                          size: 30,
                        ),
                      ),
                    )
                  ]),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(primary: Colors.purple),
                      onPressed: imagePickerOption,
                      icon: const Icon(Icons.add_a_photo_sharp),
                      label: const Text('UPLOAD IMAGE')),
                )
              ],
            ),
            new Column(
              children: <Widget>[
                new TextFormField(
                  controller: controllerName,
                  decoration: new InputDecoration(
                      contentPadding: EdgeInsets.only(left: 10),
                      labelText: "Name"),
                ),
                new TextFormField(
                  controller: email,
                  decoration: new InputDecoration(
                      contentPadding: EdgeInsets.only(left: 10),
                      labelText: "Email"),
                  keyboardType: TextInputType.emailAddress,
                  validator: (email) {
                    if (email!.isEmpty) {
                      return 'Please Enter Email';
                    }
                    if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                        .hasMatch(email)) {
                      return 'Please enter a valid Email';
                    }
                  },
                ),
                new TextFormField(
                  controller: phone,
                  decoration: new InputDecoration(
                      contentPadding: EdgeInsets.only(left: 10),
                      labelText: "Phone_number"),
                  validator: (phone) {
                    String regexPattern = r'^[9][6-9]\d{8}';
                    var regExp = new RegExp(regexPattern);
                    if (phone!.isEmpty) {
                      return 'Please Enter Phone Number';
                    }
                    if (!regExp.hasMatch(phone)) {
                      return 'Please a valid phone number';
                    }
                    if (phone.length != 10) {
                      return 'Mobile Number must be of 10 digit';
                    }
                    return null;
                  },
                ),
                new TextFormField(
                  controller: controllerGender,
                  decoration: new InputDecoration(
                      contentPadding: EdgeInsets.only(left: 10),
                      labelText: "Gender"),
                ),
                new TextFormField(
                  controller: controllerFaculty,
                  decoration: new InputDecoration(
                      contentPadding: EdgeInsets.only(left: 10),
                      labelText: "Faculty"),
                ),
                new Padding(
                  padding: const EdgeInsets.all(10.0),
                ),
                new ElevatedButton(
                  child: new Text("EDIT DATA"),
                  style: ElevatedButton.styleFrom(primary: Colors.purple),
                  onPressed: () {
                    if (_formkey.currentState!.validate()) {
                      editData();
                    }
                  },
                )
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
