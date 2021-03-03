import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Data.dart';

class MyFavorite extends StatefulWidget {
  @override
  _MyFavoriteState createState() => _MyFavoriteState();
}

class _MyFavoriteState extends State<MyFavorite> {

  FirebaseUser currentUser;
  List<Data> dataList = [];
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    auth.currentUser().then((value) => {this.currentUser = value});
    loadData();
  }

  void loadData() async {
    DatabaseReference reference =
    FirebaseDatabase.instance.reference().child("Data");
    await reference.once().then((DataSnapshot dataSnapShot) async {
      dataList.clear();
      var keys = dataSnapShot.value.keys;
      var values = dataSnapShot.value;

      for (var key in keys) {
        bool fav = false;
        DatabaseReference favRef = FirebaseDatabase.instance
            .reference()
            .child("Data")
            .child(key)
            .child("Fav")
            .child(currentUser.uid);
        await favRef.once().then((value) {
          if (value.value != null && value.value["state"] == true) {
            fav = true;
          }
          Data data = new Data(values[key]["imgUrl"], values[key]["name"],
              values[key]["material"], values[key]["price"], key, fav);
          dataList.add(data);
        });
      }

      dataList.sort((a, b) => a.name.compareTo(b.name));
    });

    setState(() {
      dataList = dataList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Favorite", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xffff2fc3),
      ),
      body: null,
    );
  }
}
