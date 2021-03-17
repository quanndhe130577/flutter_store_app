import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'Model/MyCartEntity.dart';

import 'package:firebase_database/firebase_database.dart';
import 'DetailProduct.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'Common.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MyCart extends StatefulWidget {
  @override
  _MyCartState createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  FirebaseUser currentUser;
  List<CartModel> dataList = [];
  bool isLoading = false;

  double total = 0;
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    auth.currentUser().then((value) => {this.currentUser = value});
    loadData();
  }

  void loadData() async {
    if (this.mounted) {
      setState(() {
        isLoading = true;
        //dataList = dataList;
      });
    }
    DatabaseReference reference =
        FirebaseDatabase.instance.reference().child("Data");
    await reference.once().then((DataSnapshot dataSnapShot) async {
      dataList.clear();
      var keys = dataSnapShot.value.keys;
      var values = dataSnapShot.value;

      for (var key in keys) {
        DatabaseReference inCartRef = FirebaseDatabase.instance
            .reference()
            .child("Data")
            .child(key)
            .child("InCart")
            .child(currentUser.uid);

        await inCartRef.once().then((inCartItem) {
          if (inCartItem.value != null && inCartItem.value["state"] == true) {
            CartModel data = new CartModel(
                key,
                values[key]["imgUrl"],
                values[key]["name"],
                double.parse(values[key]["price"].toString()),
                inCartItem.value["quantity"]);
            dataList.add(data);
            total += data.price * data.quantity;
          }
        });
      }
      //dataList.sort((a, b) => a.name.compareTo(b.name));
    }).whenComplete(
      () => {
        if (this.mounted)
          {
            setState(() {
              isLoading = false;
            })
          }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      appBar: AppBar(
        backgroundColor: Color(0xffff2fc3),
        title: Text("My Cart"),
        centerTitle: true,
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   child: Text("Buy"),
      //   elevation: 2,
      //   backgroundColor: Colors.red,
      // ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        color: Colors.white,
        child: Container(
          height: 50,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SizedBox(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Total : ${new String.fromCharCodes(new Runes('\u0024'))} $total ",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 20
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              SizedBox(
                width: 180,
                child: Material(
                  //type: MaterialType.transparency,
                  color: Colors.red,
                  child: InkWell(
                    onTap: () {
                      //addToCartHandle(data.uploadId);
                    },
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("Buy",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 30)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Visibility(
            visible: isLoading,
            child: Padding(
              padding: EdgeInsets.only(top: 15),
              child: SpinKitWave(
                color: Colors.red,
                size: 35.0,
              ),
            ),
          ),
          Expanded(
            child: dataList.length == 0
                ? Center(
                    child: Text("No product in your cart",
                        style: TextStyle(fontSize: 30)),
                  )
                : ListView.separated(
                    itemCount: dataList.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (buildContext, index) {
                      return slideUI(dataList[index]);
                      // cardUI(dataList[index]);
                    },
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void removeFromCart(String uploadId) {
    removeFromCartHandle(uploadId).then((value) {
      for (int i = 0; i < dataList.length; i++) {
        if (dataList[i].uploadId == uploadId) {
          total -= dataList[i].price * dataList[i].quantity;
          dataList.removeAt(i);
          break;
        }
      }
      if (this.mounted) {
        setState(() {
          //
        });
      }
    });
  }

  Widget slideUI(CartModel item) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: Container(
        color: Colors.white,
        child: Container(
          color: Colors.white,
          //margin: EdgeInsets.all(1.5),
          padding: EdgeInsets.only(top: 5, right: 10, bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Checkbox(value: true, onChanged: handleCheckBox),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              DetailProduct(item.uploadId)));
                },
                child: Image.network(item.imgUrl,
                    fit: BoxFit.cover, width: 100, height: 100),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      child: Text(
                        item.name,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '${new String.fromCharCodes(new Runes('\u0024'))} ${item.price} ',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        Expanded(child: Container()),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                TextButton(
                                  onPressed: () {
                                    handleQuantity(item.uploadId, 1); // minus
                                  },
                                  child: Icon(Icons.remove),
                                ),
                                Text(item.quantity.toString()),
                                TextButton(
                                  onPressed: () {
                                    handleQuantity(item.uploadId, 0); // plus
                                  },
                                  child: Icon(Icons.add),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        IconSlideAction(
          caption: 'Archive',
          color: Colors.blue,
          icon: Icons.archive,
          onTap: () {
            print('archive');
          },
        ),
        IconSlideAction(
          caption: 'Share',
          color: Colors.indigo,
          icon: Icons.share,
          onTap: () {
            print('share');
          },
        ),
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'More',
          color: Colors.black45,
          icon: Icons.more_horiz,
          onTap: () {
            //print('more');
          },
        ),
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () {
            removeFromCart(item.uploadId);
          },
        ),
      ],
    );
  }

  void handleQuantity(String uploadId, int type) {
    quantityHandle(uploadId, type).then((value) {
      for (int i = 0; i < dataList.length; i++) {
        if (dataList[i].uploadId == uploadId) {
          if (type == 0) {
            dataList[i].quantity++;
            total += dataList[i].price;
            break;
          } else if (type == 1 && dataList[i].quantity > 1) {
            dataList[i].quantity--;
            total -= dataList[i].price;
            break;
          }
        }
      }
      if (this.mounted) {
        setState(() {
          //
        });
      }
    });
  }

  void handleCheckBox(bool value){

  }
}
