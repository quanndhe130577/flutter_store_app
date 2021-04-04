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

  String shortenName() {
    return "${this.name.length < 15 ? this.name : this.name.substring(0, 15) + "..."}";
  }

  String shortenDes() {
    return '${this.description != null ? (this.description.length < 15 ? this.description.substring(0, 15) : this.description) : ""}';
  }
}
