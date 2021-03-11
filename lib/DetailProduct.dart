import 'package:flutter/material.dart';
import 'Data.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class DetailProduct extends StatefulWidget {
  Data data = new Data("", "", "", "", "", "", false);
  DetailProduct(this.data);

  @override
  _DetailProductState createState() => _DetailProductState(this.data);
}

class _DetailProductState extends State<DetailProduct> {
  Data data = new Data("", "", "", "", "", "", false);
  _DetailProductState(this.data);

  bool favInit = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      favInit = data.fav;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      appBar: AppBar(
        backgroundColor: Color(0xffff2fc3),
        title: Text(data.name),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Text("Buy"),
        elevation: 2,
        backgroundColor: Colors.red,
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        color: Colors.white,
        child: Container(
          height: 60,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SizedBox(
                  height: 60,
                  child: favInit
                      ? Tooltip(
                          message: 'High quality',
                          child: IconButton(
                            icon: Icon(Icons.favorite),
                            color: Colors.red,
                            onPressed: () {
                              favoriteFunc(data.uploadId, !data.fav);
                            },
                          ),
                        )
                      : IconButton(
                          icon: Icon(Icons.favorite),
                          color: Colors.grey,
                          onPressed: () {
                            favoriteFunc(data.uploadId, !data.fav);
                          },
                          tooltip: "Love",
                        ),
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: 60,
                  child: Material(
                    type: MaterialType.transparency,
                    child: InkWell(
                      onTap: () {},
                      child: Icon(Icons.add, size: 24),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: 60,
                  child: Material(
                    type: MaterialType.transparency,
                    child: InkWell(
                      onTap: () {},
                      child: Icon(Icons.add, size: 24),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: 60,
                  child: Material(
                    type: MaterialType.transparency,
                    child: InkWell(
                      onTap: () {},
                      child: Icon(Icons.add_shopping_cart,
                          size: 24, color: Colors.blue),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Container(
          child: ListView(
            children: [
              Image.network(
                data.imgUrl,
                fit: BoxFit.cover,
                width: 400,
                height: 400,
              ),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                child: Text(
                  data.name,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: 5),
              Container(
                width: double.infinity,
                child: Text(
                  '${new String.fromCharCodes(new Runes('\u0024'))} ${data.price} ',
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: 5),
              Container(
                width: double.infinity,
                child: Text(
                  "Material : ${data.material}",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: 5),
              Container(
                width: double.infinity,
                child: Text(
                  "Description : ${data.description != null ? data.description : ""}",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),

              // Row(
              //   children: [
              //     Text(
              //       '${new String.fromCharCodes(new Runes('\u0024'))} ${data.price} ',
              //       style: TextStyle(
              //           color: Colors.red,
              //           fontSize: 20,
              //           fontWeight: FontWeight.bold),
              //       textAlign: TextAlign.center,
              //     ),
              //     // Expanded(
              //     //   child: Align(
              //     //     alignment: Alignment.centerRight,
              //     //     child: TextButton.icon(
              //     //       onPressed: () {},
              //     //       icon: Icon(Icons.add_shopping_cart),
              //     //       label: Text("Add to cart"),
              //     //     ),
              //     //   ),
              //     // )
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }

  FirebaseAuth auth = FirebaseAuth.instance;
  void favoriteFunc(String uploadId, bool fav) {
    auth.currentUser().then((value) {
      DatabaseReference favRef = FirebaseDatabase.instance
          .reference()
          .child("Data")
          .child(uploadId)
          .child("Fav")
          .child(value.uid)
          .child("state");
      favRef.set(fav);

      if (this.mounted) {
        setState(() {
          favInit = fav;
        });
      }
    });
  }
}
