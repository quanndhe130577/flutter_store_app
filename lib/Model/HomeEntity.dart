class HomeModel {
  String imgUrl, name, uploadId, material;
  double price;

  HomeModel(this.uploadId, this.imgUrl, this.name, this.price, this.material);

  String shortenName(){
    return "${this.name.length < 15 ? this.name : this.name.substring(0, 15) + "..."}";
  }
}
