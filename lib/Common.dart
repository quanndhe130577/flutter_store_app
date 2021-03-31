import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

FirebaseAuth auth = FirebaseAuth.instance;

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
