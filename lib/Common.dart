import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

FirebaseAuth auth = FirebaseAuth.instance;
Future<void> addToCartHandle(String uploadId) async {
  await auth.currentUser().then((user) {
    DatabaseReference itemRef =
        FirebaseDatabase.instance.reference().child("Data").child(uploadId);
    itemRef.once().then((item) {
      if (item.value["InCart"] == null ||
          item.value["InCart"][user.uid] == null) {
        itemRef.child("InCart").child(user.uid).child("state").set(true);
        itemRef.child("InCart").child(user.uid).child("quantity").set(1);
      } else {
        itemRef.child("InCart").child(user.uid).once().then((itemInCart) {
          //if (item.value["state"] != null) {
          if (itemInCart.value["state"] == true) {
            itemRef.child("InCart").child(user.uid).child("quantity").set(itemInCart.value["quantity"] + 1);
          } else {
            itemRef.child("InCart").child(user.uid).child("state").set(true);
            itemRef.child("InCart").child(user.uid).child("quantity").set(1);
          }
          //}
        });
      }
    });
    //.child("quantity").set(1);
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
