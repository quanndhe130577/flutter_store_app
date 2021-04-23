import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_food_app/Common.dart';

class StoreScreen extends StatefulWidget {
  @override
  _StoreScreenState createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(heightOfAppBar),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          //backgroundColor: Colors.black54.withOpacity(0.3),
          title: TextField(
            decoration: InputDecoration(
              icon: Icon(Icons.search, color: Colors.white),
              hintText: "Search in the shop ",
              hintStyle: TextStyle(color: Colors.white),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide.none,
              ),
              disabledBorder: UnderlineInputBorder(
                borderSide: BorderSide.none,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide.none,
              ),
            ),
            onSubmitted: (text) {
              //searchMethod(text.toLowerCase());
            },
            autofocus: false,
          ),
          centerTitle: false,
          actions: [
            /*TextButton.icon(
              onPressed: () {},
              icon: Icon(Icons.filter_alt_outlined, color: Colors.white, size: 30),
              label: Text("Filter", style: TextStyle(color: Colors.white, fontSize: 15)),
            ),*/
            IconButton(
              icon: Icon(Icons.filter_alt_outlined, size: 30),
              tooltip: "Filter",
              color: Colors.white,
              onPressed: () {
                if (this.mounted) {
                  setState(() {
                    //searchState = !searchState;
                  });
                }
              },
            ),
            IconButton(
              icon: Icon(Icons.more_vert),
              color: Colors.white,
              onPressed: () {
                if (this.mounted) {
                  setState(() {
                    //searchState = !searchState;
                  });
                }
              },
            ),
          ],
        ),
      ),
      body: ListView(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        children: [
          Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: heightOfAppBar + MediaQuery.of(context).padding.top),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage("https://i.imgur.com/NCGELsD.jpg"),
                    fit: BoxFit.cover,
                    colorFilter: new ColorFilter.mode(Colors.black54.withOpacity(0.3), BlendMode.darken),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          ClipOval(
                            child: Image.network(
                              "https://i.imgur.com/0UsUl1m.jpg",
                              height: 75,
                              width: 75,
                              fit: BoxFit.cover,
                            ),
                          ),
                          // CircleAvatar(
                          //     radius: 40,
                          //     backgroundImage: NetworkImage(storeProduct.imgUrl)
                          // ),
                          // ClipRRect(
                          //   borderRadius: BorderRadius.circular(50),
                          //   child: Image.network(
                          //     storeProduct.imgUrl,
                          //     fit: BoxFit.cover,
                          //     width: 75,
                          //     height: 75,
                          //   ),
                          // ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text("Name",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                          ),
                          Column(
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {},
                                icon: Icon(Icons.add),
                                label: Text("Follow", style: TextStyle(fontSize: 12)),
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    side: BorderSide(width: 2.0, color: Colors.white),
                                  )),
                                  minimumSize: MaterialStateProperty.all(Size(100, 35)),
                                  backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.transparent),
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: () {},
                                icon: Icon(Icons.message),
                                label: Text("Chat", style: TextStyle(fontSize: 12)),
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    side: BorderSide(width: 2.0, color: Colors.white),
                                  )),
                                  minimumSize: MaterialStateProperty.all(Size(100, 35)),
                                  backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.transparent),
                                ),
                              ),
                              // OutlinedButton(
                              //   onPressed: () {},
                              //   style: ButtonStyle(
                              //     shape: MaterialStateProperty.all(
                              //         RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0))),
                              //     minimumSize: MaterialStateProperty.all(Size(120, 35)),
                              //   ),
                              //   child: TextButton.icon(
                              //     onPressed: () {},
                              //     icon: Icon(Icons.add, color: Colors.white),
                              //     label: Text("Follow", style: TextStyle(fontSize: 12, color: Colors.white)),
                              //   ),
                              // ),
                              // SizedBox(height: 5),
                              // OutlinedButton(
                              //   onPressed: () {},
                              //   style: ButtonStyle(
                              //     shape: MaterialStateProperty.all(
                              //         RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0))),
                              //     minimumSize: MaterialStateProperty.all(Size(120, 35)),
                              //   ),
                              //   child: TextButton.icon(
                              //     onPressed: () {},
                              //     icon: Icon(Icons.message),
                              //     label: Text("Chat", style: TextStyle(fontSize: 12)),
                              //   ),
                              // ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      IntrinsicHeight(
                        child: Row(
                          children: [
                            Expanded(
                              child: Align(
                                alignment: Alignment.center,
                                child: Column(
                                  children: [
                                    Text("${4.7}/5.0",
                                        style:
                                            TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                                    SizedBox(height: 5),
                                    Text("Evaluate", style: TextStyle(fontSize: 15, color: Colors.white)),
                                  ],
                                ),
                              ),
                            ),
                            VerticalDivider(thickness: 3),
                            Expanded(
                              child: Align(
                                alignment: Alignment.center,
                                child: Column(
                                  children: [
                                    Text("${10.1}k",
                                        style:
                                            TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                                    SizedBox(height: 5),
                                    Text("Followers", style: TextStyle(fontSize: 15, color: Colors.white)),
                                  ],
                                ),
                              ),
                            ),
                            VerticalDivider(thickness: 3),
                            Expanded(
                              child: Align(
                                alignment: Alignment.center,
                                child: Column(
                                  children: [
                                    Text("${92} %",
                                        style:
                                            TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                                    SizedBox(height: 5),
                                    Text("Chat Response", style: TextStyle(fontSize: 15, color: Colors.white)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
