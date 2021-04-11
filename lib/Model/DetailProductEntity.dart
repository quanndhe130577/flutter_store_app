class DetailProductModel {
  String imgUrl, name, material, uploadId, description;
  bool fav;
  double price;
  ShortenStoreModel store;

  DetailProductModel({
    this.imgUrl = "https://i.imgur.com/0UsUl1m.jpg",
    this.name = "",
    this.material = "",
    this.price = 0,
    this.description = "",
    this.uploadId = "",
    this.fav = true,
    this.store,
  });
}

class ShortenStoreModel {
  String id, imgUrl, name;
  int numberOfProduct;
  double chatResponseRate, evaluate;

  ShortenStoreModel({
    this.id,
    this.name,
    this.imgUrl,
    this.evaluate,
    this.chatResponseRate,
    this.numberOfProduct,
  });

  ShortenStoreModel.defaultValue() {
    this.id = "";
    this.imgUrl = "https://i.imgur.com/YJtLjN8.png";
    this.name = "";
    this.name = "Store";
    this.chatResponseRate = 100;
    this.evaluate = 5.0;
    this.numberOfProduct = 0;
  }
}
