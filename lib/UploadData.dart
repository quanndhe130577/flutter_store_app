import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'package:toast/toast.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';

class UploadData extends StatefulWidget {
  @override
  _UploadDataState createState() => _UploadDataState();
}

class _UploadDataState extends State<UploadData> {
  String name = "", material = "", price = "";
  File imageFile;
  var _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff000725),
      appBar: AppBar(
        backgroundColor: Color(0xffff2f3c),
        title: Text("Upload Data", style: TextStyle(color: Color(0xffffffff))),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(padding: EdgeInsets.only(top: 15)),
              Container(
                child: imageFile == null
                    ? FlatButton(
                        onPressed: () {
                          _showDialog();
                        },
                        child: Icon(
                          Icons.add_a_photo,
                          size: 80,
                          color: Color(0xffff2fc3),
                        ))
                    : Image.file(imageFile, width: 400, height: 400),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  SizedBox(width: 5, height: 5),
                  Expanded(
                    child: Theme(
                      data: ThemeData(
                        hintColor: Colors.blue,
                      ),
                      child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return "PLease write the name of production";
                          } else {
                            name = value;
                            return null;
                          }
                        },
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: "Name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Color(0xffff2fc3), width: 1),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Color(0xffff2fc3), width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Color(0xffff2fc3), width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Color(0xffff2fc3), width: 1),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    child: Theme(
                      data: ThemeData(
                        hintColor: Colors.blue,
                      ),
                      child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return "PLease write the material of production";
                          } else {
                            material = value;
                            return null;
                          }
                        },
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: "Material",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Color(0xffff2fc3), width: 1),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Color(0xffff2fc3), width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Color(0xffff2fc3), width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Color(0xffff2fc3), width: 1),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    child: Theme(
                      data: ThemeData(
                        hintColor: Colors.blue,
                      ),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (value) {
                          if (value.isEmpty) {
                            return "PLease write the price of production";
                          } else {
                            price = value;
                            return null;
                          }
                        },
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: "Price",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Color(0xffff2fc3), width: 1),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Color(0xffff2fc3), width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Color(0xffff2fc3), width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Color(0xffff2fc3), width: 1),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                ],
              ),
              SizedBox(height: 10),
              RaisedButton(
                onPressed: () {
                  if (imageFile == null) {
                    Toast.show(
                      "Please select an image",
                      context,
                      duration: 2,
                      gravity: Toast.CENTER,
                    );
                    // Fluttertoast.showToast(
                    //     msg: "Please select an image",
                    //     gravity: ToastGravity.CENTER,
                    //     toastLength: Toast.LENGTH_LONG,
                    //     timeInSecForIosWeb: 2);
                  } else {
                    upload();
                  }
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: Color(0xffff2fc3),
                child: Text("Upload",
                    style: TextStyle(fontSize: 19, color: Colors.blue)),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("You want take a photo from ? "),
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    GestureDetector(
                      child: Text("Gallery"),
                      onTap: () {
                        openGallery().then((value) => hideAlertDialog(),
                            onError: (e) {
                          hideAlertDialog();
                        }).catchError(hideAlertDialog);
                      },
                    ),
                    Padding(padding: EdgeInsets.only(top: 20)),
                    GestureDetector(
                      child: Text("Camera"),
                      onTap: () {
                        openCamera().then((value) => hideAlertDialog(),
                            onError: (e) {
                          hideAlertDialog();
                        }).catchError(hideAlertDialog);
                      },
                    ),
                  ],
                ),
              ));
        });
  }

  void hideAlertDialog() {
    Navigator.of(context).pop(true);
  }

  Future<void> openGallery() async {
    final picker = ImagePicker();
    var picture = await picker.getImage(source: ImageSource.gallery);
    this.setState(() {
      this.imageFile = File(picture.path);
    });
  }

  Future<void> openCamera() async {
    final picker = ImagePicker();
    var picture = await picker.getImage(source: ImageSource.camera);
    this.setState(() {
      this.imageFile = File(picture.path);
    });
  }

  Future<void> upload() async {
    if (_formKey.currentState.validate()) {
      final StorageReference reference = FirebaseStorage()
          .ref()
          .child("images")
          .child(new DateTime.now().microsecondsSinceEpoch.toString() +
              "." +
              imageFile.path);
      StorageUploadTask uploadTask = reference.putFile(imageFile);

      var imageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
      String url = imageUrl.toString();

      DatabaseReference databaseReference =
          FirebaseDatabase.instance.reference().child("Data");
      String uploadId = databaseReference.push().key;

      HashMap map = new HashMap();
      map["name"] = name;
      map["material"] = material;
      map["price"] = price;
      map["imgUrl"] = url;

      await databaseReference
          .child(uploadId)
          .set(map)
          .then((value) => Navigator.pop(context));

      // String email = "";
      // FirebaseAuth auth = FirebaseAuth.instance;
      // auth.currentUser().then((value) => {email = value.email});

    }
  }
}
