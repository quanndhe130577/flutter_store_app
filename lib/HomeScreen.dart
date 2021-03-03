import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_food_app/Data.dart';
import 'package:flutter_food_app/LogInScreen.dart';
import 'UploadData.dart';
import 'package:firebase_database/firebase_database.dart';
import 'MyFavorite.dart';

class HomeScreen extends StatefulWidget {
  String currentEmail = "";

  HomeScreen(this.currentEmail);

  @override
  _HomeScreen createState() => _HomeScreen(this.currentEmail);
}

class _HomeScreen extends State<HomeScreen> {
  String currentEmail = "";
  List<Data> dataList = [];
  FirebaseUser currentUser;
  _HomeScreen(this.currentEmail);

  FirebaseAuth auth = FirebaseAuth.instance;
  Future<void> logOut() async {
    await auth.signOut().then((value) => {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => LogInScreen()))
        });
  }

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
      backgroundColor: Color(0xffffffff),
      appBar: AppBar(
        backgroundColor: Color(0xffff2fc3),
        title: Text("Home"),
        actions: [
          FlatButton.icon(
            onPressed: () {
              logOut();
            },
            icon: Icon(Icons.person),
            label: Text("Log out"),
          )
        ],
      ),
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 170,
              color: Color(0xff000725),
              child: Column(
                children: [
                  Padding(padding: EdgeInsets.only(top: 30)),
                  Image(
                      image: AssetImage("images/icon.jpg"),
                      height: 90,
                      width: 90),
                  SizedBox(height: 10),
                  Text(currentEmail, style: TextStyle(color: Colors.white))
                ],
              ),
            ),
            ListTile(
              title: Text("Upload"),
              leading: Icon(Icons.cloud_upload),
              onTap: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => UploadData()));
                loadData();
              },
            ),
            ListTile(
              title: Text("My Favorite"),
              leading: Icon(Icons.favorite),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => MyFavorite()));
              },
            ),
            ListTile(
              title: Text("My Profile"),
              leading: Icon(Icons.person),
            ),
            Divider(),
            //line
            ListTile(
              title: Text("Contact Us"),
              leading: Icon(Icons.email),
            ),
          ],
        ),
      ),
      body: dataList.length == 0
          ? Center(
              child: Text("No data available", style: TextStyle(fontSize: 30)),
            )
          : ListView.builder(
              itemCount: dataList.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (buildContext, index) {
                return cardUI(
                    dataList[index].imgUrl,
                    dataList[index].name,
                    dataList[index].material,
                    dataList[index].price,
                    dataList[index].uploadId,
                    dataList[index].fav);
              }),
    );
  }

  Widget cardUI(String imgUrl, String name, String material, String price,
      String uploadId, bool fav) {
    return Card(
      elevation: 7,
      margin: EdgeInsets.all(15),
      color: Color(0xffff2fc3),
      child: Container(
        color: Colors.white,
        margin: EdgeInsets.all(1.5),
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Image.network(imgUrl, fit: BoxFit.cover, height: 100),
            SizedBox(height: 5),
            Text(
              name,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 1),
            Text("Material : $material"),
            Container(
              width: double.infinity,
              child: Text(
                '$price ${new String.fromCharCodes(new Runes('\u0024'))}',
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.right,
              ),
            ),
            SizedBox(height: 1),
            fav
                ? IconButton(
                    icon: Icon(Icons.favorite),
                    color: Colors.red,
                    onPressed: () {
                      auth.currentUser().then((value) {
                        DatabaseReference favRef = FirebaseDatabase.instance
                            .reference()
                            .child("Data")
                            .child(uploadId)
                            .child("Fav")
                            .child(value.uid)
                            .child("state");
                        favRef.set(!fav);
                        favoriteFunc(uploadId, !fav);
                      });
                    },
                  )
                : IconButton(
                    icon: Icon(Icons.favorite),
                    color: Colors.grey,
                    onPressed: () {
                      auth.currentUser().then((value) {
                        DatabaseReference favRef = FirebaseDatabase.instance
                            .reference()
                            .child("Data")
                            .child(uploadId)
                            .child("Fav")
                            .child(value.uid)
                            .child("state");
                        favRef.set(!fav);
                        favoriteFunc(uploadId, !fav);
                      });
                    },
                  )
          ],
        ),
      ),
    );
  }

  void favoriteFunc(String uploadId, bool fav) {
    for (var item in dataList) {
      if (item.uploadId == uploadId) {
        item.fav = fav;
      }
    }
    setState(() {
      //
    });
  }
}
