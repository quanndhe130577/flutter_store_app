import 'package:flutter/material.dart';

import 'package:flutter_food_app/Common.dart';
import 'package:flutter_food_app/CommonWidget/CustomAppBar.dart';
import 'package:flutter_food_app/CommonWidget/InheritedAppbarProvider.dart';
import 'package:flutter_food_app/redux/AppState.dart';
import 'package:flutter_food_app/redux/MyCart/MyCartActions.dart';
import 'package:flutter_food_app/Model/MyCartEntity.dart';

import 'package:flutter_food_app/View/DetailProductScreen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:toast/toast.dart';

class MyCart extends StatefulWidget {
  final Store<AppState> store;

  MyCart(this.store);

  @override
  _MyCartState createState() => _MyCartState(this.store);
}

class _MyCartState extends State<MyCart> {
  List<CartModel> dataChoose = [];
  bool isLoading = false;
  Store<AppState> store;

  final double numberOfCartInScreen = 5;

  _MyCartState(this.store);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  double total = 0;
  bool selectedAll = false;

  @override
  Widget build(BuildContext context) {
    void handleSelectAll(bool value) {
      if (value == true) {
        dataChoose = [...store.state.myCartState.cartList];
        total = 0;
        for (var item in store.state.myCartState.cartList) {
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

    void handleTotalAmount() {
      total = 0;
      dataChoose.forEach((element) {
        total += element.quantity * element.price;
      });
      if (this.mounted) {
        setState(() {
          //
        });
      }
    }

    void _removeAllChoseItems() {
      showSimpleLoadingModalDialog(context);

      List<String> list = dataChoose.map((e) => e.uploadId).toList();
      store.dispatch(RemoveFromCartMyCartAction(list));

      dataChoose = [];
      if (this.mounted) {
        setState(() {
          //
        });
      }
    }

    final double lengthForACart = getHeightForWidget(this.context,
        dividedBy: this.numberOfCartInScreen, sub: 50 + (this.numberOfCartInScreen - 1) * 5);

    return Scaffold(
      backgroundColor: Color(0xffffffff),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(heightOfAppBar),
        child: InheritedAppBarProvider(
          child: CustomAppBar(store: this.store),
          opacity: 0.2,
          title: Text("My Cart", style: TextStyle(color: Colors.black)),
          actions: [
            IconButton(
              icon: Icon(Icons.delete),
              color: Colors.red,
              onPressed: () {
                if (dataChoose.length > 0) {
                  showDialogConfirm(
                    title: Text("Remove"),
                    content: Text("Do you want to remove ? "),
                    context: context,
                    yesCallback: () {
                      _removeAllChoseItems();
                    },
                    noCallback: () {},
                  );
                }
              },
            ),
          ],
        ),
      ),
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
                      child:
                          Text("Buy", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: StoreProvider(
        store: this.store,
        child: Column(
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
            StoreConnector<AppState, List<CartModel>>(
              converter: (store) => store.state.myCartState.cartList,
              distinct: true,
              onWillChange: (prev, cur) {
                handleTotalAmount();
                if (prev.length != cur.length) {
                  Toast.show('Remove', context, duration: 1, gravity: Toast.BOTTOM);
                  Navigator.of(this.context).pop();
                }
              },
              builder: (BuildContext context, List<CartModel> dataList) => Expanded(
                child: dataList.length == 0
                    ? Center(
                        child: Text("No product in your cart", style: TextStyle(fontSize: 30)),
                      )
                    : ListView.separated(
                        itemCount: dataList.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (buildContext, index) {
                          return slideUI(dataList[index], lengthForACart);
                        },
                        separatorBuilder: (context, index) {
                          return Divider(
                            thickness: 5,
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget slideUI(CartModel item, double length) {
    bool isSelected = dataChoose.contains(item);

    void removeFromCart() {
      showSimpleLoadingModalDialog(context);
      dataChoose.removeWhere((element) => element.uploadId == item.uploadId);

      if (this.mounted) {
        setState(() {
          //
        });
      }

      store.dispatch(RemoveFromCartMyCartAction([item.uploadId]));
    }

    void handleQuantity(int type, bool isSelected) {
      store.dispatch(HandleQuantityMyCartAction(item.uploadId, type));
    }

    void handleChooseItem(bool value) {
      if (value == true) {
        total += item.price * item.quantity;
        dataChoose.add(item);
        if (dataChoose.length == store.state.myCartState.cartList.length) {
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
      actions: [
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
      secondaryActions: [
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
            showDialogConfirm(
              context: context,
              yesCallback: () {
                removeFromCart();
              },
              noCallback: () {},
              title: Text(
                "Confirm !!!",
                textAlign: TextAlign.center,
              ),
              content: Text(
                "Do you want to remove this product from cart ???",
                textAlign: TextAlign.center,
              ),
            );
          },
        ),
      ],
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
                          builder: (BuildContext context) => DetailProductScreen(item.uploadId, this.store)));
                },
                child: Image.network(item.imgUrl, fit: BoxFit.cover, width: length - 20, height: length - 20),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      child: Text(
                        shortenString(item.name, 15),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Text(
                          '${new String.fromCharCodes(new Runes('\u0024'))} ${item.price} ',
                          style: TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        Expanded(child: Container()),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            width: 120,
                            height: 30,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black38.withOpacity(0.2)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    child: TextButton(
                                      onPressed: () {
                                        handleQuantity(1, isSelected); // minus
                                      },
                                      child: Icon(Icons.remove, size: 15),
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border(right: BorderSide(color: Colors.black38.withOpacity(0.2))),
                                    ),
                                  ),
                                ),
                                //VerticalDivider(thickness: 1, indent: 5, endIndent: 5),
                                Container(
                                  width: 40,
                                  child: Text(item.quantity.toString(), textAlign: TextAlign.center),
                                ),
                                //VerticalDivider(thickness: 1, indent: 5, endIndent: 5),
                                Expanded(
                                  child: Container(
                                    child: TextButton(
                                      onPressed: () {
                                        handleQuantity(0, isSelected); // plus
                                      },
                                      child: Icon(Icons.add, size: 15),
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border(left: BorderSide(color: Colors.black38.withOpacity(0.2))),
                                    ),
                                  ),
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
    );
  }
}
