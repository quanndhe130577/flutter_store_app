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
  List<CartModel> dataChoose = [];
  bool isLoading = false;

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
            //total += data.price * data.quantity;
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

  double total = 0;
  bool selectedAll = false;

  @override
  Widget build(BuildContext context) {
    void handleSelectAll(bool value) {
      if (value == true) {
        dataChoose = [...dataList];
        total = 0;
        for (var item in dataList) {
          total += item.price * item.quantity;
        }
      } else {
        dataChoose = [];
        total = 0;
      }

      if (this.mounted) {
        setState(() {
          selectedAll = !selectedAll;
        });
      }
    }

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
              Material(
                child: InkWell(
                  onTap: () {
                    handleSelectAll(!selectedAll);
                  },
                  child: Row(
                    children: [
                      Checkbox(value: selectedAll, onChanged: handleSelectAll),
                      Text(
                        "All",
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Total : ${new String.fromCharCodes(new Runes('\u0024'))} $total ",
                      style: TextStyle(color: Colors.red, fontSize: 20),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 5),
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

  Widget slideUI(CartModel item) {
    bool isSelected = dataChoose.contains(item);

    void removeFromCart(String uploadId) {
      removeFromCartHandle(uploadId).then((value) {
        for (var subitem in dataList) {
          if (subitem.uploadId == uploadId) {
            if (isSelected) total -= subitem.price * subitem.quantity;
            dataList.remove(subitem);
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

    void handleQuantity(int type, bool isSelected) {
      quantityHandle(item.uploadId, type).then((value) {
        for (var sub_item in dataList) {
          if (sub_item.uploadId == item.uploadId) {
            if (type == 0) {
              sub_item.quantity++;
              if (isSelected) total += sub_item.price;
              break;
            } else if (type == 1 && sub_item.quantity > 1) {
              sub_item.quantity--;
              if (isSelected) total -= sub_item.price;
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

    void handleChooseItem(bool value) {
      if (value == true) {
        total += item.price * item.quantity;
        dataChoose.add(item);
        if (dataChoose.length == dataList.length) {
          selectedAll = true;
        }
      } else {
        total -= item.price * item.quantity;
        dataChoose.remove(item);
        selectedAll = false;
      }
      if (this.mounted) {
        setState(() {
          //
        });
      }
    }

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
              Material(
                color: Colors.white,
                child: Checkbox(
                  value: dataChoose.contains(item),
                  onChanged: handleChooseItem,
                ),
              ),
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
                                    handleQuantity(1, isSelected); // minus
                                  },
                                  child: Icon(Icons.remove),
                                ),
                                Text(item.quantity.toString()),
                                TextButton(
                                  onPressed: () {
                                    handleQuantity(0, isSelected); // plus
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
}
