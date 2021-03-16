import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

FirebaseAuth auth = FirebaseAuth.instance;
Future<void> addToCartHandle(String uploadId) async {
  await auth.currentUser().then((value) {
    DatabaseReference favRef = FirebaseDatabase.instance
        .reference()
        .child("Data")
        .child(uploadId)
        .child("InCart")
        .child(value.uid);
    //favRef.child("state").set(true);
    favRef.once().then((item) {
      if (item.value["state"] != null) {
        if (item.value["state"] == true) {
          favRef.child("quantity").set(item.value["quantity"] + 1);
        } else {
          favRef.child("state").set(true);
          favRef.child("quantity").set(1);
        }
      }
      // print(item.value["state"]);
      // print(item.value["quantity"]);
    });
    //.child("quantity").set(1);
  });
}

Future<void> removeFromCartHandle(String uploadId) async {
  await auth.currentUser().then((value) {
    DatabaseReference favRef = FirebaseDatabase.instance
        .reference()
        .child("Data")
        .child(uploadId)
        .child("InCart")
        .child(value.uid);
    favRef.child("state").set(false);
    favRef.child("quantity").set(0);
  });
}

Future<void> favoriteHandle(String uploadId, bool fav) async {
  await auth.currentUser().then((value) {
    DatabaseReference favRef = FirebaseDatabase.instance
        .reference()
        .child("Data")
        .child(uploadId)
        .child("Fav")
        .child(value.uid)
        .child("state");
    favRef.set(fav);
  });
}
