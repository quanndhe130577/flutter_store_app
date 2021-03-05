import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Data.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MyFavorite extends StatefulWidget {
  @override
  _MyFavoriteState createState() => _MyFavoriteState();
}

class _MyFavoriteState extends State<MyFavorite> with TickerProviderStateMixin {
  FirebaseUser currentUser;
  List<Data> dataList = [];
  bool isLoading = true;
  FirebaseAuth auth = FirebaseAuth.instance;
  String test = "";

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
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
        DatabaseReference favRef = FirebaseDatabase.instance
            .reference()
            .child("Data")
            .child(key)
            .child("Fav")
            .child(currentUser.uid);
        await favRef.once().then((value) {
          if (value.value != null && value.value["state"] == true) {
            Data data = new Data(
              values[key]["imgUrl"],
              values[key]["name"],
              values[key]["material"],
              values[key]["price"],
              key,
              true,
            );
            dataList.add(data);
          }
        });
      }

      dataList.sort((a, b) => a.name.compareTo(b.name));
    });

    if (this.mounted) {
      setState(() {
        isLoading = false;
        //dataList = dataList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Favorite",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xffff2f3c),
      ),
      body: isLoading
          ? Center(
              //child: Text("No data available", style: TextStyle(fontSize: 30)),
              child: SpinKitSquareCircle(
                color: Colors.red,
                size: 50.0,
                duration: Duration(milliseconds: 1200),
              ),
            )
          : dataList.length == 0
              ? Center(
                  child:
                      Text("No data available", style: TextStyle(fontSize: 30)),
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
            RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                "Remove",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                auth.currentUser().then((value) {
                  DatabaseReference favRef = FirebaseDatabase.instance
                      .reference()
                      .child("Data")
                      .child(uploadId)
                      .child("Fav")
                      .child(value.uid)
                      .child("state");
                  favRef.set(false);
                  removeFav(uploadId);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void removeFav(String uploadId) {
    //loadData();
    // for (var item in dataList) {
    //   if (item.uploadId == uploadId) {
    //     dataList.remove(item);
    //   }
    // }

    dataList.removeWhere((element) => element.uploadId == uploadId);
    if (this.mounted) {
      setState(() {
        //dataList = dataList;
      });
    }
  }
}
