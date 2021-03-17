class CartModel {
  String imgUrl, name, uploadId;
  int quantity;
  double price;

  CartModel(this.uploadId, this.imgUrl, this.name, this.price, this.quantity);
}
