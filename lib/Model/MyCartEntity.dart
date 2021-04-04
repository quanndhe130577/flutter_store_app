class CartModel {
  String imgUrl, name, uploadId;
  int quantity;
  double price;

  CartModel(this.uploadId, this.imgUrl, this.name, this.price, this.quantity);

  String shortenName(){
    return "${this.name.length < 15 ? this.name : this.name.substring(0, 15) + "..."}";
  }
}
