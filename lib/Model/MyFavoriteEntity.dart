class FavModel {
  String imgUrl, name, material, uploadId, description;
  bool fav;
  double price;

  FavModel(
      this.imgUrl, this.name, this.material, this.price, this.description, this.uploadId, this.fav);

  FavModel.defaultValue() {
    this.imgUrl = "https://i.imgur.com/0UsUl1m.jpg";
    this.name = "";
    this.material = "";
    this.price = 0;
    this.description = "";
    this.uploadId = "";
    this.fav = true;
  }
}
